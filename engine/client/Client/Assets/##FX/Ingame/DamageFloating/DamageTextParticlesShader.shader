Shader "Custom/DamageTextParticles"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [ShowAsVector2] _TextureSize ("Texture Size", Vector) = (128, 128, 0, 0)
    }
    SubShader
    {            
        Tags { "RenderType"="Opaque" "PreviewType"="Plane" "Queue" = "Transparent+1"}
        LOD 100
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                fixed4 color : COLOR;
                float4 uv : TEXCOORD0;
                float4 customData1 : TEXCOORD1;
            };           

            struct v2f
            {
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
                float4 uv : TEXCOORD0;
                float4 customData1 : TEXCOORD1;
            };
            
            uniform sampler2D _MainTex;
            uniform vector _TextureSize;
            
            v2f vert (const appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.color = v.color;                
                o.customData1 = v.customData1;

                float4 modResult = fmod(v.customData1, 1000.0);
                float2 invTextureSize = 1.0 / _TextureSize.xy;

                o.customData1.x = modResult.x * invTextureSize.x;
                o.customData1.z = modResult.z * invTextureSize.x;
                o.customData1.y = modResult.y * invTextureSize.y;
                o.customData1.w = modResult.w * invTextureSize.y;
                
                return o;
            }
            
            fixed4 frag (v2f v) : SV_Target
            {
                const float2 uv = (v.uv * (v.customData1.zw)) + v.customData1.xy;
                return tex2D(_MainTex, uv) * v.color;
            }
            ENDCG
        }
    }
}