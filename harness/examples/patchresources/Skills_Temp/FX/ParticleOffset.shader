
Shader "ParticleOffset"
{
	Properties
	{
		//_InvFade ("Soft Particles Factor", Range(0.01,3.0)) = 1.0
		_MainTex("MainTex", 2D) = "white" {}
		_MaskTex("MaskTex", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)
		_CustomAlpha ("Alpha", Float) = 1
		_Intensity ("Intensity", Range(1,5)) = 1
		_SpeedX("Speed X", Range(-10, 10)) = 0
		_SPeedY("Speed Y", Range(-10, 10))  = 0

		[Header(Particle System Only)][Space(4)]
		[Toggle()] _TilingAndOffset("Use Tiling And Offset", Float) = 0
		[Enum(UnityEngine.Rendering.BlendMode)]_Blend ("Blend mode", Float) = 1
	}

	Category 
	{
		SubShader
		{
		LOD 0

			Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" "PreviewType"="Plane" }
			Blend SrcAlpha [_Blend]
			ColorMask RGB
			Cull Back
			Lighting Off 
			ZWrite Off
			ZTest LEqual
			
			Pass {
			
				CGPROGRAM
				
				#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
				#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
				#endif
				
				#pragma vertex vert
				#pragma fragment frag
				#pragma target 2.0
				#pragma multi_compile_instancing
				#pragma multi_compile_particles
				#pragma multi_compile_fog
				#define ASE_NEEDS_FRAG_COLOR


				#include "UnityCG.cginc"

				struct appdata_t 
				{
					float4 vertex : POSITION;
					fixed4 color : COLOR;
					float4 texcoord : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;

					UNITY_VERTEX_INPUT_INSTANCE_ID
					
				};

				struct v2f 
				{
					float4 vertex : SV_POSITION;
					fixed4 color : COLOR;
					float4 uv : TEXCOORD0;
					float4 texcoord1 : TEXCOORD1;

					UNITY_FOG_COORDS(1)
					// #ifdef SOFTPARTICLES_ON
					// float4 projPos : TEXCOORD2;
					// #endif
					UNITY_VERTEX_INPUT_INSTANCE_ID
					UNITY_VERTEX_OUTPUT_STEREO
					
				};
				
				
				// #if UNITY_VERSION >= 560
				// UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
				// #else
				// uniform sampler2D_float _CameraDepthTexture;
				// #endif

				//Don't delete this comment
				// uniform sampler2D_float _CameraDepthTexture;

				CBUFFER_START(UnityPerMaterial)
				sampler2D _MainTex;
				half4 _MainTex_ST;
				sampler2D _MaskTex;
				half4 _MaskTex_ST;
				//uniform float _InvFade;
				float _SpeedX;
				float _SPeedY;
				half4 _Color;
				float _TilingAndOffset;
				float _Intensity;
				fixed _CustomAlpha;
				CBUFFER_END


				v2f vert ( appdata_t v  )
				{
					v2f o;
					UNITY_SETUP_INSTANCE_ID(v);
					UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
					UNITY_TRANSFER_INSTANCE_ID(v, o);
					
					o.vertex = UnityObjectToClipPos(v.vertex);
					// #ifdef SOFTPARTICLES_ON
					// 	o.projPos = ComputeScreenPos (o.vertex);
					// 	COMPUTE_EYEDEPTH(o.projPos.z);
					// #endif
					o.color = v.color;
					o.uv.xy = TRANSFORM_TEX(v.texcoord, _MainTex);
					o.uv.zw = TRANSFORM_TEX(v.texcoord, _MaskTex);
					o.texcoord1 = v.texcoord1;
					UNITY_TRANSFER_FOG(o,o.vertex);
					return o;
				}

				half4 frag ( v2f i  ) : SV_Target
				{
					UNITY_SETUP_INSTANCE_ID( i );
					UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( i );

					// #ifdef SOFTPARTICLES_ON
					// 	float sceneZ = LinearEyeDepth (SAMPLE_DEPTH_TEXTURE_PROJ(_CameraDepthTexture, UNITY_PROJ_COORD(i.projPos)));
					// 	float partZ = i.projPos.z;
					// 	float fade = saturate (_InvFade * (sceneZ-partZ));
					// 	i.color.a *= fade;
					// #endif

					float2 uv_MainTex = lerp(i.uv.xy * _MainTex_ST.xy + float2(_MainTex_ST.z + (_Time.y * _SpeedX), _MaskTex_ST.w + (_Time.y * _SPeedY)), 
						i.uv.xy * _MainTex_ST.xy + float2(_MainTex_ST.z + i.texcoord1.z + (_Time.y * i.texcoord1.x), _MainTex_ST.w + i.texcoord1.w + (_Time.y * i.texcoord1.y)), 
						_TilingAndOffset);
					
					half4 baseColor = tex2D( _MainTex, uv_MainTex);
					half4 col = 0;
					col.rgb = _Color.rgb * (i.color.rgb * baseColor.rgb );
					col.rgb *= _Intensity;
					col.a = tex2D(_MaskTex, i.uv.zw).r * baseColor.a * i.color.a;
					col.a *= _CustomAlpha;
					UNITY_APPLY_FOG(i.fogCoord, col);
					return col;
				}
				ENDCG 
			}
		}	
	}
}
