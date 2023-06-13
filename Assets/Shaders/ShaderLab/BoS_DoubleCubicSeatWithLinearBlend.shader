Shader "Book of Shaders/BoS_DoubleCubicSeatWithLinearBlend"
{
    Properties
    {
        _A ("A", Range(0.0, 1.0)) = 0.5
        _B ("B", Range(0.0, 1.0)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
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
            };

            float _A, _B;

            float plot(float2 st, float pct) 
            {
                return smoothstep(pct - 0.01, pct, st.y) - smoothstep(pct, pct + 0.01, st.y);
            }

            float doubleCubicSeatWithLinearBlend(float x, float a, float b) 
            {
                if (x <= a) {
                    return b * x + (1 - b) * a * (1 - pow(1 - (x / a), 3));
                }

                return b * x + (1 - b) * (a + (1 - a) * pow((x - a) / (1 - a), 3));
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 st = i.uv.xy/_ScreenParams.w;
                float y = doubleCubicSeatWithLinearBlend(st.x, _A, _B);
                float3 color = float3(y, y, y);

                float pct = plot(st, y);
                color = (1.0 - pct) * color + pct * float3(0.0, 1.0, 0.0);

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
