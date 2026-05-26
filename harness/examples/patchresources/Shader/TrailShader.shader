Shader "Unlit/TrailShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _MainOffsetSpeedX ("+ Speed U", Range(-10, 10)) = 0
        _MainOffsetSpeedY ("+ Speed V", Range(-10, 10)) = 0
        _AlphaTex ("Allpha Texture", 2D) = "white"{}
        _AlphaOffsetSpeedX ("+ Speed U", Range(-10, 10)) = 0
        _AlphaOffsetSpeedY ("+ Speed V", Range(-10, 10)) = 0

        [Header(Cull)]
        [Space(10)]
		[Enum(UnityEngine.Rendering.CullMode)] 	_Cull("+ Cull", Float) = 0  

        [Header(ZTest  ZWrite)]
        [Space(10)]
		[Enum(UnityEngine.Rendering.CompareFunction)] _ZTest("+ ZTest", Float) = 4
		[Enum(Off, 0, On, 1)] _ZWrite("+ ZWrite", Float) = 0

        [Header(Blend)]
        [Space(10)]
		[Enum(UnityEngine.Rendering.BlendMode)] _SrcFactor("+ Src Factor", Float) = 5
		[Enum(UnityEngine.Rendering.BlendMode)] _DstFactor("+ Dst Factor", Float) = 10
    }
    SubShader
    {
        Tags {  "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
        Blend [_SrcFactor][_DstFactor]
        ColorMask RGB
        Cull [_Cull] Lighting Off ZWrite [_ZWrite] ZTest [_ZTest]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_particles
            //#pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 uv : TEXCOORD0;
                fixed4 color : COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 uv : TEXCOORD0;
                fixed4 color : COLOR;
                //UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                #ifdef SOFTPARTICLES_ON
                float4 projPos : TEXCOORD2;
                #endif
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _AlphaTex;
            float4 _AlphaTex_ST;
            float _MainOffsetSpeedX;
            float _MainOffsetSpeedY;
            float _AlphaOffsetSpeedX;
            float _AlphaOffsetSpeedY;

            v2f vert (appdata v)
            {
                v2f o;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
                o.vertex = UnityObjectToClipPos(v.vertex);

                 #ifdef SOFTPARTICLES_ON
                o.projPos = ComputeScreenPos (o.vertex);
                COMPUTE_EYEDEPTH(o.projPos.z);
                #endif

                o.color = v.color;
                o.uv.xy = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv.zw = TRANSFORM_TEX(v.uv, _AlphaTex);  
                //UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);
            float _InvFade;

            fixed4 frag (v2f i) : SV_Target
            {
                #ifdef SOFTPARTICLES_ON
                float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
                float partZ = i.projPos.z;
                float fade = saturate (_InvFade * (sceneZ-partZ));
                i.color *= fade;
                #endif

                // sample the texture
                float2 uv1 = i.uv.xy * _MainTex_ST.xy + float2(_MainTex_ST.z + (_Time.y * _MainOffsetSpeedX) , _MainTex_ST.w + (_Time.y * _MainOffsetSpeedY));
                float2 uv2 = i.uv.zw * _AlphaTex_ST.xy + float2(_AlphaTex_ST.z + (_Time.y * _AlphaOffsetSpeedX) , _AlphaTex_ST.w + (_Time.y * _AlphaOffsetSpeedY));

                fixed3 col = tex2D(_MainTex, uv1).rgb;
                fixed a = tex2D(_AlphaTex, uv2).g;
                col *= i.color.rgb;
                a *= i.color.a;
                // apply fog
                //UNITY_APPLY_FOG(i.fogCoord, col);
                return fixed4(col * 2 , a);
            }
            ENDCG
        }
    }
}
