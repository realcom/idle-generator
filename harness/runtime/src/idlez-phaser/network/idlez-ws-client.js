import { IdlezProtoRegistry } from './proto-registry.js';
import { PACKET_TYPE, PacketKey, PacketStreamDecoder, encodePacket } from './packet-codec.js';
import { toNumber } from './session-store.js';

const REQUEST_CASES = [
  'pingRequest',
  'skipBoardRequest',
  'sendCommandRequest',
  'sendCommandResponse',
  'loginRequest',
  'loginResponse',
  'signInOauthRequest',
  'signInOauthResponse',
  'useCashItemRequest',
  'useCashItemResponse',
  'levelUpItemRequest',
  'levelUpItemResponse',
  'levelDownItemRequest',
  'levelDownItemResponse',
  'decomposeItemRequest',
  'decomposeItemResponse',
  'claimDailyRewardRequest',
  'claimDailyRewardResponse',
  'createItemRequest',
  'createItemResponse',
  'buyItemRequest',
  'buyItemResponse',
  'disposeItemRequest',
  'disposeItemResponse',
  'rerollItemOptionRequest',
  'rerollItemOptionResponse',
  'createReceiptRequest',
  'createReceiptResponse',
  'verifyReceiptRequest',
  'verifyReceiptResponse',
  'createBoardRequest',
  'createBoardResponse',
  'joinBoardRequest',
  'joinBoardResponse',
  'getBoardRequest',
  'getBoardResponse',
  'leaveBoardRequest',
  'leaveBoardResponse',
  'interactBoardRequest',
  'interactBoardResponse',
  'autoPlayToTickBoardRequest',
  'autoPlayToTickBoardResponse',
  'claimAchievementRewardRequest',
  'claimAchievementRewardResponse',
  'increaseAchievementRequest',
  'increaseAchievementResponse',
];

const UPDATE_CASES = [
  'playerItemUpdate',
  'playerAvatarUpdate',
  'playerAchievementUpdate',
  'playerUpdate',
  'playerAcquiredItemsUpdate',
  'playerDisplayMessageUpdate',
  'playerDisconnectedUpdate',
  'playerChatUpdate',
  'boardPlayerUpdate',
  'boardAchievementUpdate',
  'variableUpdate',
  'boardStateUpdate',
];

const RESPONSE_CASES = new Set(REQUEST_CASES.filter(name => name.endsWith('Response')));

export class IdlezWsClient {
  constructor({ url = resolveWorldSocketUrl(), session, store, registry = new IdlezProtoRegistry(), timeoutMs = 15000, logger = console } = {}) {
    this.url = url;
    this.session = session;
    this.store = store;
    this.registry = registry;
    this.timeoutMs = timeoutMs;
    this.logger = logger;
    this.state = 'Init';
    this.packetKey = new PacketKey();
    this.callbacks = new Map();
    this.listeners = new Map();
    this.decoder = new PacketStreamDecoder(packet => this.#handlePacket(packet));
  }

  on(type, listener) {
    const listeners = this.listeners.get(type) || new Set();
    listeners.add(listener);
    this.listeners.set(type, listeners);
    return () => listeners.delete(listener);
  }

  async connect() {
    if (this.ws?.readyState === WebSocket.OPEN) return this;

    this.#setState('Connecting');
    try {
      await withTimeout(this.registry.load(), this.timeoutMs, `Proto load timeout: ${this.url}`);
    } catch (error) {
      this.#setState('Disconnected');
      throw error;
    }

    this.packetKey.reset();

    this.ws = new WebSocket(this.url);
    this.ws.binaryType = 'arraybuffer';
    this.ws.onmessage = event => this.decoder.push(event.data);
    this.ws.onclose = event => {
      this.#setState('Disconnected');
      this.#rejectAll(new Error(`WebSocket closed: ${event.code}`));
    };
    this.ws.onerror = () => {
      this.#setState('Disconnected');
      this.#rejectAll(new Error('WebSocket error'));
    };

    await new Promise((resolve, reject) => {
      const timer = setTimeout(() => reject(new Error(`WebSocket connect timeout: ${this.url}`)), this.timeoutMs);
      this.ws.onopen = () => {
        clearTimeout(timer);
        this.#setState('Connected');
        resolve();
      };
      this.ws.onerror = () => {
        clearTimeout(timer);
        this.#setState('Disconnected');
        reject(new Error(`WebSocket connect failed: ${this.url}`));
      };
    });

    this.ws.onerror = () => {
      this.#setState('Disconnected');
      this.#rejectAll(new Error('WebSocket error'));
    };

    return this;
  }

  close() {
    this.ws?.close();
    this.#setState('Disconnected');
  }

  async connectAndLoginGuest(overrides = {}) {
    await this.connect();
    return this.loginGuest(overrides);
  }

  async loginGuest(overrides = {}) {
    const response = await this.sendRequest('loginRequest', createGuestLoginPayload(overrides), { allowBeforeLogin: true });
    if (isOk(response.status)) {
      this.#setState('Loginned');
      this.#emit('signal', {
        type: 'info',
        title: '서버 연결',
        body: `${response.player?.name || 'Guest'} 로그인`,
      });
    }
    return response;
  }

  async levelUpItemDataId(itemDataId, count = 1) {
    const itemId = this.session?.getItemInstanceId(itemDataId);
    if (!itemId) throw new Error(`Missing server item instance for itemDataId ${itemDataId}`);

    const response = await this.sendRequest('levelUpItemRequest', { itemId, count });
    if (isOk(response.status)) {
      this.session?.applyLevelUpResponse(response);
    }
    return response;
  }

  sendRequest(caseName, payload = {}, { allowBeforeLogin = false, expectResponse = true } = {}) {
    if (this.ws?.readyState !== WebSocket.OPEN) {
      return Promise.reject(new Error('WebSocket is not connected'));
    }

    if (!allowBeforeLogin && this.state !== 'Loginned' && caseName !== 'pingRequest') {
      return Promise.reject(new Error(`Cannot send ${caseName} before login`));
    }

    const callbackId = expectResponse ? this.packetKey.nextCallbackId() : 0;
    const request = this.registry.createRequest(caseName, payload, callbackId);

    if (!expectResponse) {
      this.#sendRequestMessage(request);
      return Promise.resolve({ status: 0 });
    }

    return new Promise((resolve, reject) => {
      const timer = setTimeout(() => {
        this.callbacks.delete(String(callbackId));
        reject(new Error(`${caseName} timed out`));
      }, this.timeoutMs);
      this.callbacks.set(String(callbackId), {
        caseName,
        resolve: response => {
          clearTimeout(timer);
          resolve(response);
        },
        reject: error => {
          clearTimeout(timer);
          reject(error);
        },
      });
      this.#sendRequestMessage(request);
    });
  }

  #sendRequestMessage(request) {
    const body = this.registry.encodeRequest(request);
    const packet = encodePacket({
      packetType: PACKET_TYPE.REQUEST,
      key: this.packetKey.nextClientKey(),
      body,
    });
    this.ws.send(packet);
  }

  #handlePacket(packet) {
    try {
      if (packet.packetType === PACKET_TYPE.REQUEST) {
        this.#handleRequest(this.registry.decodeRequest(packet.body));
      } else if (packet.packetType === PACKET_TYPE.UPDATE) {
        this.#handleUpdate(this.registry.decodeUpdate(packet.body));
      }
    } catch (error) {
      this.logger.warn?.('[IdlezWsClient] Failed to handle packet', error);
      this.#emit('signal', {
        type: 'warning',
        title: '서버 패킷 오류',
        body: error.message,
      });
    }
  }

  #handleRequest(request) {
    const caseName = findCase(request, REQUEST_CASES);
    if (!caseName) return;

    if (caseName === 'pingRequest') {
      this.#handlePing(request.pingRequest);
      return;
    }

    const response = request[caseName];
    this.#applyResponse(caseName, response);

    const callback = this.callbacks.get(String(toNumber(request.id)));
    if (callback) {
      this.callbacks.delete(String(toNumber(request.id)));
      callback.resolve(response);
    }

    this.#emit('request', { caseName, request, response });
  }

  #handlePing(pingRequest) {
    this.lastPingAt = Date.now();
    const payload = {
      ...pingRequest,
      timestamp: timestampNow(),
    };
    this.sendRequest('pingRequest', payload, { allowBeforeLogin: true, expectResponse: false }).catch(error => {
      this.logger.warn?.('[IdlezWsClient] Failed to echo ping', error);
    });
  }

  #handleUpdate(update) {
    const caseName = findCase(update, UPDATE_CASES);
    if (!caseName) return;

    const payload = update[caseName];
    switch (caseName) {
      case 'playerItemUpdate':
        this.session?.applyItems(payload.items || []);
        break;
      case 'playerAcquiredItemsUpdate':
        this.session?.applyItems(payload.items || []);
        for (const item of payload.items || []) {
          this.#emit('signal', {
            type: 'loot',
            itemDataId: toNumber(item.itemDataId),
            count: toNumber(item.count, 1),
            reason: 'server:update',
          });
        }
        break;
      case 'playerAvatarUpdate':
        if (this.session) this.session.avatar = payload.avatar;
        break;
      case 'playerAchievementUpdate':
        this.session?.applyAchievements(payload.achievements || []);
        break;
      case 'playerUpdate':
        if (this.session) this.session.player = payload.player;
        break;
      case 'playerDisplayMessageUpdate':
        this.#emit('signal', {
          type: toNumber(payload.type) === 0 ? 'warning' : 'info',
          title: payload.title || '알림',
          body: payload.message || '',
        });
        break;
      case 'playerDisconnectedUpdate':
        this.#emit('signal', {
          type: 'warning',
          title: '서버 연결 종료',
          body: payload.message || String(payload.status || ''),
        });
        break;
      default:
        break;
    }

    this.#emit('update', { caseName, update, payload });
  }

  #applyResponse(caseName, response = {}) {
    if (!RESPONSE_CASES.has(caseName)) return;

    switch (caseName) {
      case 'loginResponse':
        if (isOk(response.status)) this.session?.applyLoginResponse(response);
        break;
      case 'levelUpItemResponse':
        if (isOk(response.status)) this.session?.applyLevelUpResponse(response);
        break;
      case 'buyItemResponse':
      case 'useCashItemResponse':
      case 'claimDailyRewardResponse':
      case 'claimAchievementRewardResponse':
        if (isOk(response.status)) this.session?.applyItems(response.items || []);
        break;
      default:
        break;
    }
  }

  #setState(state) {
    if (this.state === state) return;
    this.state = state;
    this.#emit('state', { state });
  }

  #rejectAll(error) {
    for (const callback of this.callbacks.values()) {
      callback.reject(error);
    }
    this.callbacks.clear();
  }

  #emit(type, detail) {
    for (const listener of this.listeners.get(type) || []) {
      listener(detail);
    }
  }
}

export function shouldAutoConnectNetwork(search = globalThis.location?.search || '') {
  const params = new URLSearchParams(search);
  return params.get('network') === '1'
    || params.get('network') === 'true'
    || params.has('ws')
    || params.has('worldWs');
}

export function resolveWorldSocketUrl(search = globalThis.location?.search || '') {
  const params = new URLSearchParams(search);
  const explicit = params.get('ws') || params.get('worldWs');
  if (explicit) return explicit;

  const host = params.get('worldHost') || params.get('server') || '127.0.0.1:11177';
  if (/^wss?:\/\//i.test(host)) return ensureTrailingSlash(host);

  const scheme = globalThis.location?.protocol === 'https:' ? 'wss' : 'ws';
  return ensureTrailingSlash(`${scheme}://${host}`);
}

function createGuestLoginPayload(overrides = {}) {
  const snsId = overrides.snsId || getOrCreateLocalId('idlez.phaser.guestSnsId', 'Guest_');
  const deviceId = overrides.deviceId || getOrCreateLocalId('idlez.phaser.deviceId', 'Web_');
  return {
    snsId,
    language: overrides.language || navigator.language?.split('-')[0] || 'ko',
    clientVersion: Number(overrides.clientVersion || 1),
    country: overrides.country || '',
    deviceId,
    deviceOS: 'Web',
    deviceModel: navigator.userAgent || 'Browser',
    pushToken: '',
    commonsCommitHash: overrides.commonsCommitHash || '',
    loginKey: overrides.loginKey || '',
  };
}

function getOrCreateLocalId(key, prefix) {
  const existing = localStorage.getItem(key);
  if (existing) return existing;

  const value = `${prefix}${crypto.randomUUID?.().replace(/-/g, '') || Math.random().toString(16).slice(2)}`;
  localStorage.setItem(key, value);
  return value;
}

function findCase(message, cases) {
  if (!message) return null;
  if (typeof message.Request === 'string') return message.Request;
  if (typeof message.Update === 'string') return message.Update;
  return cases.find(caseName => message[caseName] != null) || null;
}

function timestampNow() {
  const now = Date.now();
  return {
    seconds: Math.floor(now / 1000),
    nanos: (now % 1000) * 1_000_000,
  };
}

function isOk(status) {
  return toNumber(status) === 0;
}

function ensureTrailingSlash(url) {
  return url.includes('/', 6) ? url : `${url}/`;
}

function withTimeout(promise, timeoutMs, message) {
  let timer = null;
  const timeout = new Promise((_, reject) => {
    timer = setTimeout(() => reject(new Error(message)), timeoutMs);
  });

  return Promise.race([promise, timeout]).finally(() => clearTimeout(timer));
}
