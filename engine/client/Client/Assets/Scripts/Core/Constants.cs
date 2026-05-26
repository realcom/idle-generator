using System;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;
using ArgumentNullException = System.ArgumentNullException;

public static class Market {
	public const string GOOGLE = "google";
	public const string APPLE = "apple";
	public const string ONE_STORE = "one_store";
	public const string UNKNOWN = "unknown";
}

public class Constants
{
    public static string SERVER_HOST
    {
#if UNITY_WEBGL
	    get
	    {
		    if (Utility.isDebugMode)
			    return "idlez-dev.puzzlemonsters.io:11177";
		    return "idlez.puzzlemonsters.io:11177";
	    }
#else
	    get
	    {
		    if (Utility.isDebugMode)
			    return "idlez-dev.puzzlemonsters.io:11177";
		    return "idlez.puzzlemonsters.io:11177";
	    }
#endif
    }

    public static string WEB_HOST = "http://idlez-api.puzzlemonsters.io";
    

	public const bool DEVELOPMENT_MODE = false;

#if UNITY_EDITOR
	public const bool IGNORE_ASSETBUNDLE = true;
#else
	public const bool IGNORE_ASSETBUNDLE = false;
#endif

	public const string SUBSET = "backpack";

	public const string LOGIN_SCENE = "LoginScene";
	public const string GAME_SCENE = "GameScene";
	public const string GOOGLE_WEB_CLIENT_ID = "454873833772-dkcpq4dlqt6ikqskm5k6p2mfu5cbav9c.apps.googleusercontent.com";

	//
	public static string PATCHSET_UPDATE_URL = "http://updates-cdn2.puzzlemonsters.io";
	public static string PATCHSET_UPDATE_ORIGIN_URL = "http://updates-origin.puzzlemonsters.io";

	public class Key
	{
		public const string LAST_CHANNEL = nameof(LAST_CHANNEL);
		public const string BGM = nameof(BGM);
		public const string FX = nameof(FX);
		public const string LOGIN_TYPE = nameof(LOGIN_TYPE);
		public const string SNS_ID = nameof(SNS_ID);
		public const string SNS_NAME = nameof(SNS_NAME);
		public const string GUEST_SNS_ID = nameof(GUEST_SNS_ID);

		public const string SELECTED_SERVER_ID = "SELECTED_SERVER_HOST";

		public const string LOBBY_BUBBLE_LEVEL = nameof(LOBBY_BUBBLE_LEVEL);
		public const string PLAY_COUNTER = nameof(PLAY_COUNTER);
		public const string SHOW_RATE_APP_ALERT = nameof(SHOW_RATE_APP_ALERT);

		public const string HIDE_TEAM_HELPS = nameof(HIDE_TEAM_HELPS);

		public const string LAST_LOGIN_DATE = nameof(LAST_LOGIN_DATE);

		public const string PAD_SETTINGS_AUTO_MODE = nameof(PAD_SETTINGS_AUTO_MODE);
		public const string PAD_SETTINGS_AUTO_WEAPON_SWAP = nameof(PAD_SETTINGS_AUTO_WEAPON_SWAP);
		public const string PAD_SETTINGS_DPAD_SHOW_TYPE = nameof(PAD_SETTINGS_DPAD_SHOW_TYPE);
		public const string PAD_SETTINGS_DPAD_POSITION_FIXED = nameof(PAD_SETTINGS_DPAD_POSITION_FIXED);
		public const string PAD_SETTINGS_TOUCHMOVE_ENABLED = nameof(PAD_SETTINGS_TOUCHMOVE_ENABLED);

		public const string PLAYER_SETTINGS_GRAPHIC_QUALITY = nameof(PLAYER_SETTINGS_GRAPHIC_QUALITY);
		
		public const string PUSH_TOKEN = nameof(PUSH_TOKEN);
	}

	public static class Layers {
		public const string PLATFORMS = "Platforms";
		public const string PLAYERS = "Players";
		public const string PLAYERS_HIT = "Players_Hit";
		public const string MAP_EVENTS = "Map_Events";
		public const string DANGERS = "Dangers";
	}
	 
	public const int MAX_ITEM_LEVEL = 7;
	public const int MAX_CHARACTER_LEVEL = 10;
	public const int MAX_GRADE = 5;
	
	//
	public class TeamTag
	{
		public const uint NONE = 0;
		public const uint PLAYER = 0b0001;
		public const uint ENEMY = 0b0010;
		public const uint TEAM_HOME = 0b0100;
		public const uint TEAM_AWAY = 0b1000;
		public const uint NEUTRAL = 0xFFFFFFFF;
	}

    public static class Grade
    {
        public const int NORMAL = 0; // 일반
        public const int RARE = 1; // 고급
        public const int EPIC = 2; // 희귀
        public const int UNIQUE = 3; // 보물
        public const int LEGENDARY = 4; // 전설
        public const int MYTH = 5; // 신화
        public const int LAST = MYTH;
    }

    public const int STAR_GRADE_UNIT = 5;
    public const long MAX_GAME_MONEY = 5_000_000_000_000_000_000L;
	
	public enum AssetBundleType : uint
	{
		ALL = 0xFFFFFFFF,
		COMMONS = 0x00000001,
		MAPS = 0x00000002,
		UNITS = 0x00000004,
		ITEMS = 0x00000008,
		SKILLS = 0x00000010,
		BUFFS = 0x00000020,
		// DIALOGS = 0x00000020,
		SOUNDS = 0x00000040,
		ETC = 0x80000000,
	}	
}


public class RPCMode
{
    public const int Server = 0;
    public const int All = 1;
    public const int Others = 2;
}

public class ClanRole
{
    public const int NORMAL = 0;
    public const int SUB_MASTER = 900;
    public const int MASTER = 1000;
}

public class ClanJoinType
{
	public const int IMMEDIATE = 0;
	public const int REQUEST = 1;
	public const int PRIVATE = 2;

	public const int COUNT = 3;
}

public class ClanSubMasterPermissionFlag
{
	public const int CHANGE_CLAN_DESC = 0b0000_0001;
	public const int CHANGE_CLAN_NOTICE = 0b0000_0010;
	public const int ALLOW_JOIN_REQUEST = 0b0000_0100;
	public const int KICK_CLAN_PLAYER = 0b0000_1000;

	public static bool GetIsPossible(int permission, int flag) => (permission & flag) != 0;
}

public static class AnimatorHash {
	public static readonly int State = Animator.StringToHash(nameof(State));
	public static readonly int MoveSpeed = Animator.StringToHash(nameof(MoveSpeed));
	public static readonly int AttackSpeed = Animator.StringToHash(nameof(AttackSpeed));
	public static readonly int MotionSpeed = Animator.StringToHash(nameof(MotionSpeed));
	public static readonly int MotionTime = Animator.StringToHash(nameof(MotionTime));
	public static readonly int WeaponType = Animator.StringToHash(nameof(WeaponType));
	public static readonly int IsOnBattle = Animator.StringToHash(nameof(IsOnBattle));
	public static readonly int Execution = Animator.StringToHash(nameof(Execution));
	public static readonly int Start = Animator.StringToHash(nameof(Start));
	public static readonly int End = Animator.StringToHash(nameof(End));
	public static readonly int Anim = Animator.StringToHash(nameof(Anim));
	public static readonly int Glow = Animator.StringToHash(nameof(Glow));
	public static readonly int Enter = Animator.StringToHash(nameof(Enter));
	public static readonly int Exit = Animator.StringToHash(nameof(Exit));
	public static readonly int Hide = Animator.StringToHash(nameof(Hide));
	public static readonly int Result = Animator.StringToHash(nameof(Result));
	public static readonly int Sequence = Animator.StringToHash(nameof(Sequence));
	// public static readonly int WeaponChange = Animator.StringToHash("WeaponChange");
}

public static class ShaderHash {
	// TODO: change names to fit with new PM_ToolSimpleLit shader
	public static readonly int TransparencyLevel = Shader.PropertyToID("_Tweak_transparency");
	public static readonly int DissolveLevel = Shader.PropertyToID("_Cutoff");
    public static readonly int DissolveColor = Shader.PropertyToID("_DissolveColor");
    public static readonly int BaseColor = Shader.PropertyToID("_BaseColor");
	public static readonly int FirstShadeColor = Shader.PropertyToID("_1st_ShadeColor");
	public static readonly int Fill = Shader.PropertyToID("_Fill");
	
	public static readonly int HeadForward = Shader.PropertyToID("_HeadForward");
	public static readonly int HeadRight = Shader.PropertyToID("_HeadRight");
	
	public static readonly int PlayerPosition = Shader.PropertyToID("_PlayerPosition");
	
	public static readonly int FullScreenFactor = Shader.PropertyToID("_factor");
	
	public static readonly int EmissionColor = Shader.PropertyToID("_VFX_EmissionColor");
	public static readonly int EmissionFactor = Shader.PropertyToID("_VFX_EmissionFactor");
	public static readonly int RimColor = Shader.PropertyToID("_VFX_RimColor");
	public static readonly int RimPower = Shader.PropertyToID("_VFX_RimPower");
	public static readonly int RimFactor = Shader.PropertyToID("_VFX_RimFactor");

	public static readonly int LightProbeIntensity = Shader.PropertyToID("_LightProbeIntensity");

	public static readonly int G_EMISSIONVALUE = Shader.PropertyToID("_G_EmissionValue");
    public static readonly int G_CUSTOM_LIGHT_DIRECTION = Shader.PropertyToID("_G_CustomLightDirection");
}

public static class Layer
{
	public static readonly int Default = LayerMask.NameToLayer(nameof(Default));
	public static readonly int TransparentFX = LayerMask.NameToLayer(nameof(TransparentFX));
	public static readonly int IgnoreRaycast = LayerMask.NameToLayer("Ignore Raycast");
	public static readonly int Water = LayerMask.NameToLayer(nameof(Water));
	public static readonly int UI = LayerMask.NameToLayer(nameof(UI));
	public static readonly int Skill = LayerMask.NameToLayer(nameof(Skill));
	public static readonly int DropItem = LayerMask.NameToLayer(nameof(DropItem));
	public static readonly int Wall = LayerMask.NameToLayer(nameof(Wall));
	public static readonly int Player = LayerMask.NameToLayer(nameof(Player));
	public static readonly int PlayerWall = LayerMask.NameToLayer(nameof(PlayerWall));
	public static readonly int Unit = LayerMask.NameToLayer(nameof(Unit));
	public static readonly int UnitWall = LayerMask.NameToLayer(nameof(UnitWall));
	public static readonly int Ground = LayerMask.NameToLayer(nameof(Ground));
	public static readonly int FX = LayerMask.NameToLayer(nameof(FX));
	public static readonly int FXOverUnit = LayerMask.NameToLayer("FX Over Unit");

	public static readonly int DimmedLayerMask = GetMask(
		Skill,
		Player,
		Unit);

	public static readonly int FXLayerMask = GetMask(
		FX,
		FXOverUnit);
	
	public static readonly int UnitLayerMask = GetMask(
		Player,
		Unit);
	
	public static readonly int PlayerPhysicCheckMask = GetMask(
		Unit,
		UnitWall,
		Wall);

	public static int GetMask(params int[] layers)
	{
		if (layers == null)
			throw new ArgumentNullException(nameof (layers));
		var mask = 0;
		foreach (var layer in layers)
		{
			if (layer != -1)
				mask |= 1 << layer;
		}
		return mask;
	}
	
}