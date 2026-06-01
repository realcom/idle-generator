using Commons.Packets;
using Commons.Packets.Requests;
using Commons.Packets.Updates;
using DotNetty.Buffers;
using DotNetty.Codecs.Http.WebSockets;
using DotNetty.Transport.Channels.Embedded;
using Server.Codecs;
using System.Text;
using Xunit;

namespace Server.Tests;

public sealed class PacketCodecTests
{
    [Fact]
    public void PacketEncoder_and_Decoder_round_trip_request_packets()
    {
        var outbound = new EmbeddedChannel(new PacketEncoder());
        outbound.WriteOutbound(Packet.Pop(0x33, new BuyItemRequest
        {
            ProductItemDataId = 321,
            Count = 2,
        }));

        var encoded = Assert.IsAssignableFrom<IByteBuffer>(outbound.ReadOutbound<IByteBuffer>());
        var inbound = new EmbeddedChannel(new PacketDecoder());

        Assert.True(inbound.WriteInbound(encoded.Retain()));

        var decoded = Assert.IsType<Packet>(inbound.ReadInbound<Packet>());
        try
        {
            Assert.Equal(Packet.Type.Request, decoded.PacketType);
            Assert.Equal((byte)0x33, decoded.Key);
            Assert.Equal(Request.RequestOneofCase.BuyItemRequest, decoded.Request.RequestCase);
            Assert.Equal(321, decoded.Request.BuyItemRequest.ProductItemDataId);
            Assert.Equal(2, decoded.Request.BuyItemRequest.Count);
        }
        finally
        {
            decoded.Dispose();
            encoded.Release();
        }
    }

    [Fact]
    public void PacketDecoder_waits_for_complete_payload_before_emitting()
    {
        var packet = Packet.Pop(0x21, new LoginRequest
        {
            SnsId = "Guest_packet",
            ClientVersion = 7,
            Language = "English",
        });

        byte[] bytes;
        using (packet)
        using (var stream = new MemoryStream())
        {
            packet.Dump(stream);
            bytes = stream.ToArray();
        }

        var inbound = new EmbeddedChannel(new PacketDecoder());
        Assert.False(inbound.WriteInbound(Unpooled.WrappedBuffer(bytes, 0, bytes.Length - 1)));
        Assert.Null(inbound.ReadInbound<object>());

        Assert.True(inbound.WriteInbound(Unpooled.WrappedBuffer(bytes, bytes.Length - 1, 1)));

        var decoded = Assert.IsType<Packet>(inbound.ReadInbound<Packet>());
        try
        {
            Assert.Equal(Request.RequestOneofCase.LoginRequest, decoded.Request.RequestCase);
            Assert.Equal("Guest_packet", decoded.Request.LoginRequest.SnsId);
            Assert.Equal((uint)7, decoded.Request.LoginRequest.ClientVersion);
        }
        finally
        {
            decoded.Dispose();
        }
    }

    [Fact]
    public void PacketWebSocketDecoder_decodes_binary_frames_and_ignores_empty_frames()
    {
        var outbound = new EmbeddedChannel(new PacketEncoder());
        outbound.WriteOutbound(Packet.Pop(0x44, new LeaveBoardRequest()));
        var encoded = Assert.IsAssignableFrom<IByteBuffer>(outbound.ReadOutbound<IByteBuffer>());

        var inbound = new EmbeddedChannel(new PacketWebSocketDecoder());
        Assert.False(inbound.WriteInbound(new BinaryWebSocketFrame(Unpooled.Buffer(0))));
        Assert.Null(inbound.ReadInbound<object>());

        Assert.True(inbound.WriteInbound(new BinaryWebSocketFrame((IByteBuffer)encoded.Retain())));

        var decoded = Assert.IsType<Packet>(inbound.ReadInbound<Packet>());
        try
        {
            Assert.Equal(Packet.Type.Request, decoded.PacketType);
            Assert.Equal(Request.RequestOneofCase.LeaveBoardRequest, decoded.Request.RequestCase);
        }
        finally
        {
            decoded.Dispose();
            encoded.Release();
        }
    }

    [Fact]
    public void WebSocketEncoder_wraps_buffers_in_binary_frames()
    {
        var payload = Unpooled.WrappedBuffer(new byte[] { 1, 2, 3, 4 });
        var channel = new EmbeddedChannel(new WebSocketEncoder());

        Assert.True(channel.WriteOutbound(payload.Retain()));

        var frame = Assert.IsType<BinaryWebSocketFrame>(channel.ReadOutbound<BinaryWebSocketFrame>());
        try
        {
            Assert.Equal(4, frame.Content.ReadableBytes);
            Assert.Equal(1, frame.Content.GetByte(0));
            Assert.Equal(4, frame.Content.GetByte(3));
        }
        finally
        {
            frame.Release();
            payload.Release();
        }
    }

    [Fact]
    public void ProtocolSwitch_detects_websocket_upgrade_prefix()
    {
        var request = Encoding.ASCII.GetBytes(
            "GET / HTTP/1.1\r\n" +
            "Host: localhost\r\n" +
            "Upgrade: websocket\r\n" +
            "Connection: Upgrade\r\n" +
            "Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==\r\n" +
            "Sec-WebSocket-Version: 13\r\n\r\n");
        var buffer = Unpooled.WrappedBuffer(request);

        try
        {
            Assert.Equal(ServerProtocol.WebSocket, DetectProtocol(buffer));
        }
        finally
        {
            buffer.Release();
        }
    }

    [Fact]
    public void ProtocolSwitch_detects_binary_packet_as_tcp()
    {
        var outbound = new EmbeddedChannel(new PacketEncoder());
        outbound.WriteOutbound(Packet.Pop(0x65, new LeaveBoardRequest()));
        var encoded = Assert.IsAssignableFrom<IByteBuffer>(outbound.ReadOutbound<IByteBuffer>());

        try
        {
            Assert.Equal(ServerProtocol.Tcp, DetectProtocol(encoded));
        }
        finally
        {
            encoded.Release();
        }
    }

    [Fact]
    public void ProtocolSwitch_waits_for_partial_websocket_prefix_before_selecting_protocol()
    {
        var buffer = Unpooled.WrappedBuffer(new[] { (byte)'G' });

        try
        {
            Assert.Null(DetectProtocol(buffer));
        }
        finally
        {
            buffer.Release();
        }
    }

    [Fact]
    public void Packet_round_trip_preserves_update_payload_fields()
    {
        var packet = Packet.Pop(0x55, new PlayerDisconnectedUpdate
        {
            Status = StatusCode.ServerMaintenance,
            Message = "maintenance",
        });

        byte[] bytes;
        using (packet)
        using (var stream = new MemoryStream())
        {
            packet.Dump(stream);
            bytes = stream.ToArray();
        }

        var parsed = Packet.PopWithoutInitialize();
        try
        {
            Assert.True(parsed.Parse(new MemoryStream(bytes)));
            Assert.Equal(Packet.Type.Update, parsed.PacketType);
            Assert.Equal(Update.UpdateOneofCase.PlayerDisconnectedUpdate, parsed.Update.UpdateCase);
            Assert.Equal(StatusCode.ServerMaintenance, parsed.Update.PlayerDisconnectedUpdate.Status);
            Assert.Equal("maintenance", parsed.Update.PlayerDisconnectedUpdate.Message);
        }
        finally
        {
            parsed.Dispose();
        }
    }

    private static ServerProtocol? DetectProtocol(IByteBuffer buffer)
    {
        return global::Server.Server<global::WorldServer.WorldServer, global::WorldServer.WorldPlayer.WorldPlayer>
            .ProtocolSwitchHandler.DetectProtocol(buffer);
    }
}
