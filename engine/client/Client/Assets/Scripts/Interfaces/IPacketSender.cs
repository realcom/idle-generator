using System.Collections;
using System.Collections.Generic;
using System.Threading;
using Commons.Packets;
using Commons.Packets.Requests;
using Cysharp.Threading.Tasks;
using UnityEngine;

namespace Interfaces
{
    public interface IPacketSender
    {
        public UniTask<IPacketResponse> SendPacket(Packet packet, CancellationToken cancellationToken, bool withLoading = false, bool freezeInteraction = true);
        public UniTask<TPacketResponse> SendPacket<TPacketResponse>(Packet packet, CancellationToken cancellationToken, bool withLoading = false, bool freezeInteraction = true) where TPacketResponse : class, IPacketResponse, new();
        
    }
}
