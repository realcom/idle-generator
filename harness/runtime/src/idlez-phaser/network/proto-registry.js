const PROTO_PATHS = Object.freeze({
  'AddBuff.proto': 'Types/Units/AddBuff.proto',
  'AddDamage.proto': 'Types/Units/AddDamage.proto',
  'AddHeal.proto': 'Types/Units/AddHeal.proto',
  'AddItem.proto': 'Types/AddItem.proto',
  'ArmorType.proto': 'Types/Units/ArmorType.proto',
  'ArmorTypeStatType.proto': 'Types/Units/ArmorTypeStat/ArmorTypeStatType.proto',
  'BuffGroupStatType.proto': 'Types/Units/BuffGroupStat/BuffGroupStatType.proto',
  'Chat.proto': 'Types/Chat.proto',
  'Curve.proto': 'Types/Curve.proto',
  'DamageType.proto': 'Types/Units/DamageType.proto',
  'DamageTypeStatType.proto': 'Types/Units/DamageTypeStat/DamageTypeStatType.proto',
  'GameBoard.proto': 'Game/GameBoard.proto',
  'GameBuff.proto': 'Game/GameBuff.proto',
  'GameDropItem.proto': 'Game/GameDropItem.proto',
  'GameSkill.proto': 'Game/GameSkill.proto',
  'GameUnit.proto': 'Game/GameUnit.proto',
  'GeometryMessage.proto': 'Types/Geometry/GeometryMessage.proto',
  'ItemGroupStatType.proto': 'Types/Units/ItemGroupStat/ItemGroupStatType.proto',
  'ItemOption.proto': 'Types/ItemOption.proto',
  'MaterialItem.proto': 'Types/MaterialItem.proto',
  'Notice.proto': 'Types/Notice.proto',
  'Player.proto': 'Types/Players/Player.proto',
  'PlayerAchievement.proto': 'Types/Players/PlayerAchievement.proto',
  'PlayerAvatar.proto': 'Types/Players/PlayerAvatar.proto',
  'PlayerInfo.proto': 'Types/Players/PlayerInfo.proto',
  'PlayerInventory.proto': 'Types/Players/PlayerInventory.proto',
  'PlayerItem.proto': 'Types/Players/PlayerItem.proto',
  'PlayerMail.proto': 'Types/Players/PlayerMail.proto',
  'PlayerRanking.proto': 'Types/Players/PlayerRanking.proto',
  'PlayerTelegram.proto': 'Types/Players/PlayerTelegram.proto',
  'Requests.proto': 'Packets/Requests/Requests.proto',
  'ResourceAchievement.proto': 'Resources/ResourceAchievement.proto',
  'ResourceAudio.proto': 'Resources/ResourceAudio.proto',
  'ResourceBuff.proto': 'Resources/ResourceBuff.proto',
  'ResourceItem.proto': 'Resources/ResourceItem.proto',
  'ResourceMap.proto': 'Resources/ResourceMap.proto',
  'ResourceSkill.proto': 'Resources/ResourceSkill.proto',
  'ResourceString.proto': 'Resources/ResourceString.proto',
  'ResourceTrigger.proto': 'Resources/ResourceTrigger.proto',
  'ResourceUnit.proto': 'Resources/ResourceUnit.proto',
  'Resources.proto': 'Resources/Resources.proto',
  'SkillGroupStatType.proto': 'Types/Units/SkillGroupStat/SkillGroupStatType.proto',
  'SlotStatType.proto': 'Types/Units/SlotStat/SlotStatType.proto',
  'Tags.proto': 'Resources/Tags.proto',
  'UnitStatType.proto': 'Types/Units/UnitStatType.proto',
  'Updates.proto': 'Packets/Updates/Updates.proto',
  'UseSkill.proto': 'Types/Units/UseSkill.proto',
  'World.proto': 'Types/World.proto',
});

const ROOT_PROTO_FILES = [
  'Packets/Requests/Requests.proto',
  'Packets/Updates/Updates.proto',
  'Game/GameBoard.proto',
];

export class IdlezProtoRegistry {
  constructor({ commonsBasePath = '/engine/commons' } = {}) {
    this.commonsBasePath = commonsBasePath.replace(/\/$/, '');
    this.loaded = false;
    this.loadPromise = null;
  }

  async load() {
    if (this.loaded) return this;
    if (this.loadPromise) return this.loadPromise;

    this.loadPromise = this.#loadInternal();
    return this.loadPromise;
  }

  async #loadInternal() {
    const protobuf = globalThis.protobuf;
    if (!protobuf?.Root) {
      throw new Error('protobufjs runtime is not loaded');
    }

    const root = new protobuf.Root();
    root.resolvePath = (_origin, target) => this.#resolvePath(target);
    await root.load(ROOT_PROTO_FILES.map(path => this.#url(path)));
    root.resolveAll();

    this.root = root;
    this.Request = root.lookupType('Commons.Packets.Requests.Request');
    this.Update = root.lookupType('Commons.Packets.Updates.Update');
    this.GameBoard = root.lookupType('Commons.Game.GameBoard');
    this.StatusCode = root.lookupEnum('Commons.Packets.Requests.StatusCode');
    this.loaded = true;
    return this;
  }

  createRequest(caseName, payload = {}, id = 0) {
    const data = { id };
    data[caseName] = payload;
    return this.Request.create(data);
  }

  encodeRequest(request) {
    return this.Request.encode(request).finish();
  }

  decodeRequest(bytes) {
    return this.Request.decode(bytes);
  }

  decodeUpdate(bytes) {
    return this.Update.decode(bytes);
  }

  decodeGameBoard(bytes) {
    return this.GameBoard.decode(bytes);
  }

  #resolvePath(target) {
    if (/^https?:\/\//i.test(target) || target.startsWith('/')) {
      return target;
    }

    if (target.startsWith('google/protobuf/')) {
      return this.#url(`build/include/${target}`);
    }

    const basename = target.split('/').pop();
    const resolved = PROTO_PATHS[basename];
    if (!resolved) {
      throw new Error(`Unknown proto import: ${target}`);
    }

    return this.#url(resolved);
  }

  #url(path) {
    return new URL(`${this.commonsBasePath}/${path}`, globalThis.location?.href || 'http://127.0.0.1/').href;
  }
}
