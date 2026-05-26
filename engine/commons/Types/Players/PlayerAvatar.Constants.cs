using Commons.Resources;

namespace Commons.Types.Players
{
    public partial class PlayerAvatar
    {
        public static class WeaponSlot
        {
            public const int Weapon1 = 0;
            public const int Weapon2 = 1;
            public const int Size = 50;
        }
        
        public static class EquipmentSlot
        {
            public const int Costume = 0;
            public const int Hair = 1;
            public const int Head = 2;
            public const int Chest = 3;
            public const int Leg = 4;
            public const int Boots = 5;
            public const int Gloves = 6;
            public const int Necklace = 7;
            public const int Bracelet = 8;
            public const int Ring1 = 9;
            public const int Ring2 = 10;
            public const int CyberOperating = 11;
            public const int CyberExosuit = 12;
            public const int CyberSkeleton = 13;
            public const int CyberArm = 14;
            public const int CyberHand = 15;
            public const int CyberLeg = 16;
            public const int Size = 17;

            public const int Multiple = 9999;
        }

        public static class PetSlot
        {
            public const int Pet1 = 0;
            public const int Pet2 = 1;
            public const int Pet3 = 2;
            public const int Size = 3;
        }

        public static int ToEquipmentSlot(ResourceItem.Types.Type type)
        {
            switch (type)
            {
                case ResourceItem.Types.Type.Costume:
                    return EquipmentSlot.Costume;
                case ResourceItem.Types.Type.Hair:
                    return EquipmentSlot.Hair;
                case ResourceItem.Types.Type.Head:
                    return EquipmentSlot.Head;
                case ResourceItem.Types.Type.Chest:
                    return EquipmentSlot.Chest;
                case ResourceItem.Types.Type.Leg:
                    return EquipmentSlot.Leg;
                case ResourceItem.Types.Type.Boots:
                    return EquipmentSlot.Boots;
                case ResourceItem.Types.Type.Gloves:
                    return EquipmentSlot.Gloves;
                case ResourceItem.Types.Type.Necklace:
                    return EquipmentSlot.Necklace;
                case ResourceItem.Types.Type.Bracelet:
                    return EquipmentSlot.Bracelet;
                case ResourceItem.Types.Type.Ring:
                    return EquipmentSlot.Multiple;
                case ResourceItem.Types.Type.CyberOperating:
                    return EquipmentSlot.CyberOperating;
                case ResourceItem.Types.Type.CyberExosuit:
                    return EquipmentSlot.CyberExosuit;
                case ResourceItem.Types.Type.CyberSkeleton:
                    return EquipmentSlot.CyberSkeleton;
                case ResourceItem.Types.Type.CyberArm:
                    return EquipmentSlot.CyberArm;
                case ResourceItem.Types.Type.CyberHand:
                    return EquipmentSlot.CyberHand;
                case ResourceItem.Types.Type.CyberLeg:
                    return EquipmentSlot.CyberLeg;
            }
            return -1;
        }
        
        public static ResourceItem.Types.Type ToEquipmentType(int slot)
        {
            switch (slot)
            {
                case EquipmentSlot.Costume:
                    return ResourceItem.Types.Type.Costume;
                case EquipmentSlot.Hair:
                    return ResourceItem.Types.Type.Hair;
                case EquipmentSlot.Head:
                    return ResourceItem.Types.Type.Head;
                case EquipmentSlot.Chest:
                    return ResourceItem.Types.Type.Chest;
                case EquipmentSlot.Leg:
                    return ResourceItem.Types.Type.Leg;
                case EquipmentSlot.Boots:
                    return ResourceItem.Types.Type.Boots;
                case EquipmentSlot.Gloves:
                    return ResourceItem.Types.Type.Gloves;
                case EquipmentSlot.Necklace:
                    return ResourceItem.Types.Type.Necklace;
                case EquipmentSlot.Bracelet:
                    return ResourceItem.Types.Type.Bracelet;
                case EquipmentSlot.Ring1:
                case EquipmentSlot.Ring2:
                    return ResourceItem.Types.Type.Ring;
                case EquipmentSlot.CyberOperating:
                    return ResourceItem.Types.Type.CyberOperating;
                case EquipmentSlot.CyberExosuit:
                    return ResourceItem.Types.Type.CyberExosuit;
                case EquipmentSlot.CyberSkeleton:
                    return ResourceItem.Types.Type.CyberSkeleton;
                case EquipmentSlot.CyberArm:
                    return ResourceItem.Types.Type.CyberArm;
                case EquipmentSlot.CyberHand:
                    return ResourceItem.Types.Type.CyberHand;
                case EquipmentSlot.CyberLeg:
                    return ResourceItem.Types.Type.CyberLeg;
            }
            return ResourceItem.Types.Type.Unspecified;
        }
    }
}
