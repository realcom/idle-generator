Shader "UI/EdgeEffect"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)

        _EdgeColor ("Edge Color", Color) = (0, 0, 0, 1)
        _EdgeShinyColor ("Edge Shiny Color", Color) = (1, 1, 1, 1)
        _EdgeShinyWidth ("Edge Shiny Width", Range(0, 1)) = 1
        [ShowAsVector2] _EdgeShinyCenter ("Edge Shiny Center", Vector) = (0.5, 0.5, 0.5, 0.5)
        _EdgeShinyAutoPlaySpeed ("Edge Shiny Auto Play Speed", float) = 1
        _EdgeShinyCount("EdgeShinyCount", Range(1, 10)) = 1

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255

        _ColorMask ("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend One OneMinusSrcAlpha
        ColorMask [_ColorMask]

        Pass
        {
            Name "Default"
        CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 2.0

            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            #pragma multi_compile_local _ UNITY_UI_CLIP_RECT
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP


            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float4 texcoord : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                fixed4 color    : COLOR;
                float4 texcoord  : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
                float4  mask : TEXCOORD2;
                UNITY_VERTEX_OUTPUT_STEREO
            };

            sampler2D _MainTex;
            fixed4 _Color;
            fixed4 _TextureSampleAdd;
            float4 _ClipRect;
            float4 _MainTex_ST;
            float _UIMaskSoftnessX;
            float _UIMaskSoftnessY;
            int _UIVertexColorAlwaysGammaSpace;

            UNITY_INSTANCING_BUFFER_START(Props)

                UNITY_DEFINE_INSTANCED_PROP(fixed4, _EdgeColor)
                UNITY_DEFINE_INSTANCED_PROP(fixed4, _EdgeShinyColor)
                UNITY_DEFINE_INSTANCED_PROP(float, _EdgeShinyWidth)
                //UNITY_DEFINE_INSTANCED_PROP(float2, _EdgeShinyCenter)
                UNITY_DEFINE_INSTANCED_PROP(float, _EdgeShinyAutoPlaySpeed)
                UNITY_DEFINE_INSTANCED_PROP(float, _EdgeShinyCount)

            UNITY_INSTANCING_BUFFER_END(Props)

            float Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax)
            {
                return OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
            }

            v2f vert(appdata_t v)
            {
                v2f OUT;
                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);
                float4 vPosition = UnityObjectToClipPos(v.vertex);
                OUT.worldPosition = v.vertex;
                OUT.vertex = vPosition;

                float2 pixelSize = vPosition.w;
                pixelSize /= float2(1, 1) * abs(mul((float2x2)UNITY_MATRIX_P, _ScreenParams.xy));

                float4 clampedRect = clamp(_ClipRect, -2e10, 2e10);
                float2 maskUV = (v.vertex.xy - clampedRect.xy) / (clampedRect.zw - clampedRect.xy);
                OUT.texcoord.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex).xy;
                OUT.texcoord.zw = v.texcoord.zw;
                OUT.mask = float4(v.vertex.xy * 2 - clampedRect.xy - clampedRect.zw, 0.25 / (0.25 * half2(_UIMaskSoftnessX, _UIMaskSoftnessY) + abs(pixelSize.xy)));


                if (_UIVertexColorAlwaysGammaSpace)
                {
                    if(!IsGammaSpace())
                    {
                        v.color.rgb = UIGammaToLinear(v.color.rgb);
                    }
                }

                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                //Round up the alpha color coming from the interpolator (to 1.0/256.0 steps)
                //The incoming alpha could have numerical instability, which makes it very sensible to
                //HDR color transparency blend, when it blends with the world's texture.
                const half alphaPrecision = half(0xff);
                const half invAlphaPrecision = half(1.0/alphaPrecision);
                IN.color.a = round(IN.color.a * alphaPrecision)*invAlphaPrecision;

                half4 color = (tex2D(_MainTex, IN.texcoord.xy) + _TextureSampleAdd);

                #ifdef UNITY_UI_CLIP_RECT
                half2 m = saturate((_ClipRect.zw - _ClipRect.xy - abs(IN.mask.xy)) * IN.mask.zw);
                color.a *= m.x * m.y;
                #endif

                fixed4 edgeColor = UNITY_ACCESS_INSTANCED_PROP(fixed4, _EdgeColor);
                fixed4 edgeShinyColor = UNITY_ACCESS_INSTANCED_PROP(fixed4, _EdgeShinyColor);
                float edgeShinyWidth = UNITY_ACCESS_INSTANCED_PROP(float, _EdgeShinyWidth);
                float2 edgeShinyCenter = IN.texcoord.zw;
                float edgeShinyAutoPlaySpeed = UNITY_ACCESS_INSTANCED_PROP(float, _EdgeShinyAutoPlaySpeed);
                float edgeShinyCount = UNITY_ACCESS_INSTANCED_PROP(float, _EdgeShinyCount);
                
                edgeShinyCount = edgeShinyCount <= 0 ? 1 : edgeShinyCount;
                float offset = 1 / edgeShinyCount;
                const float deg = atan2(IN.texcoord.y - 0.5, IN.texcoord.x - 0.5) / (UNITY_PI*offset);
                //bool isShine =  frac(_Time.y * edgeShinyAutoPlaySpeed  + deg) < edgeShinyWidth;
                
                float fracValue = frac(_Time.y * edgeShinyAutoPlaySpeed  + deg);
                float finalSmoothness = 0.05f;
                float finalValue = fracValue > (1-finalSmoothness) ?
                    1 - Unity_Remap_float(fracValue, float2(1-finalSmoothness, 1), float2(0, 1)):
                    Unity_Remap_float(fracValue, float2(0, 1-finalSmoothness), float2(0, 1));
                
                

                color.a *= finalValue;
                color *= IN.color;

                #ifdef UNITY_UI_ALPHACLIP
                clip (color.a - 0.001);
                #endif

                color.rgb *= color.a;

                return color;
            }
        ENDCG
        }
    }
}
