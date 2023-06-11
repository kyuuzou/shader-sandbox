Shader "Unity Shaders Bible/USB_ShadowMap"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        LOD 100

        Pass
        {
            Name "Shadow Caster"
            Tags { "RenderType" = "Opaque" "LightMode" = "ShadowCaster" }

            ZWrite On
            
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_shadowcaster

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                V2F_SHADOW_CASTER;
            };

            v2f vert(appdata v)
            {
                v2f o;
                TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                SHADOW_CASTER_FRAGMENT(i)
            }
            
            ENDCG
        }
        
        Pass
        {
            Name "Shadow Map Texture"
            Tags { "RenderType" = "Opaque" "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 shadowCoord : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _ShadowMapTexture;

            float4 NormalizedDeviceCoordinatesToUV (float4 clipPos)
            {
                float4 uv = clipPos;
                
#if defined(UNITY_HALF_TEXEL_OFFSET )
                uv.xy = float2(uv.x, uv.y * _ProjectionParams.x) + uv.w *
                _ScreenParams.zw;
#else
                uv.xy = float2(uv.x, uv.y * _ProjectionParams.x) + uv.w;
#endif
                uv.xy = float2(uv.x / uv.w, uv.y / uv.w) * 0.5;

                return uv;
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.shadowCoord = NormalizedDeviceCoordinatesToUV(o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed shadow = tex2D(_ShadowMapTexture, i.shadowCoord).a;
                col.rgb *= shadow;
                
                return col;
            }
            ENDCG
        }
    }
}
