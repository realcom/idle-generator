export const PACKET_TYPE = Object.freeze({
  NONE: 0x00,
  REQUEST: 0x11,
  UPDATE: 0x12,
});

export const MAGIC_NUMBER = 0x47;

const FIXED_DATA_LENGTHS = new Map([
  [0x01, 16],
  [0x02, 16],
  [0x03, 12],
  [0x04, 16],
  [0x05, 12],
]);

export class PacketKey {
  constructor() {
    this.reset();
  }

  reset() {
    this.clientKey = 1;
    this.callbackId = 1;
  }

  nextClientKey() {
    const key = this.clientKey & 0xff;
    this.clientKey += MAGIC_NUMBER;
    return key;
  }

  nextCallbackId() {
    return this.callbackId++;
  }
}

export function encodePacket({ packetType, key, body = new Uint8Array(0) }) {
  const payload = body instanceof Uint8Array ? body : new Uint8Array(body);
  const hasLength = hasLengthField(packetType);
  const headerSize = 2 + (hasLength ? 4 : 0);
  const packet = new Uint8Array(headerSize + payload.length);
  packet[0] = key & 0xff;
  packet[1] = xor(packetType, key);

  if (hasLength) {
    const length = payload.length;
    packet[2] = xor(length & 0xff, key);
    packet[3] = xor((length >> 8) & 0xff, key);
    packet[4] = xor((length >> 16) & 0xff, key);
    packet[5] = xor((length >> 24) & 0xff, key);
  }

  for (let i = 0; i < payload.length; i += 1) {
    packet[headerSize + i] = xor(payload[i], key);
  }

  return packet;
}

export class PacketStreamDecoder {
  constructor(onPacket) {
    this.onPacket = onPacket;
    this.buffer = new Uint8Array(0);
  }

  push(chunk) {
    const bytes = chunk instanceof Uint8Array ? chunk : new Uint8Array(chunk);
    if (bytes.length === 0) return;

    const next = new Uint8Array(this.buffer.length + bytes.length);
    next.set(this.buffer, 0);
    next.set(bytes, this.buffer.length);
    this.buffer = next;
    this.#drain();
  }

  #drain() {
    let offset = 0;

    while (this.buffer.length - offset >= 2) {
      const key = this.buffer[offset];
      const packetType = xor(this.buffer[offset + 1], key);
      const hasLength = hasLengthField(packetType);
      const headerSize = 2 + (hasLength ? 4 : 0);
      if (this.buffer.length - offset < headerSize) break;

      const bodyLength = hasLength
        ? xor(this.buffer[offset + 2], key)
          | (xor(this.buffer[offset + 3], key) << 8)
          | (xor(this.buffer[offset + 4], key) << 16)
          | (xor(this.buffer[offset + 5], key) << 24)
        : fixedDataLength(packetType);

      const packetSize = headerSize + bodyLength;
      if (this.buffer.length - offset < packetSize) break;

      const body = new Uint8Array(bodyLength);
      for (let i = 0; i < bodyLength; i += 1) {
        body[i] = xor(this.buffer[offset + headerSize + i], key);
      }

      this.onPacket?.({ key, packetType, body });
      offset += packetSize;
    }

    this.buffer = this.buffer.slice(offset);
  }
}

function hasLengthField(packetType) {
  return packetType === PACKET_TYPE.REQUEST || packetType === PACKET_TYPE.UPDATE;
}

function fixedDataLength(packetType) {
  if (!FIXED_DATA_LENGTHS.has(packetType)) {
    throw new Error(`Unknown fixed-length packet type: ${packetType}`);
  }
  return FIXED_DATA_LENGTHS.get(packetType);
}

function xor(value, key) {
  return (value ^ key) & 0xff;
}
