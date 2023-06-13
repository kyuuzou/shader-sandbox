Shader "Book of Shaders/BoS_SymmetricDoublePolynomialSigmoids"
{
    Properties
    {
        [IntRange]
        _N ("N", Range(1, 20)) = 10
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

            int _N;

            float plot(float2 st, float pct) 
            {
                return smoothstep(pct - 0.01, pct, st.y) - smoothstep(pct, pct + 0.01, st.y);
            }

            float doublePolynomialSigmoid(float x, int n) 
            {
                if (n % 2 == 0) {
                    if (x <= 0.5) {
                        return pow(2.0 * x, 2.0 * n) / 2.0;
                    } else {
                        return 1.0 - pow(2.0 * x - 2.0, 2.0 * n) / 2.0;
                    }
                } else {
                    if (x <= 0.5) {
                        return pow(2.0 * x, 2.0 * (n + 1)) / 2.0;
                    } else {
                        return 1.0 + pow(2.0 * x - 2.0, 2.0 * (n + 1)) / 2.0;
                    }
                }
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
                float y = doublePolynomialSigmoid(st.x, _N);

                float3 color = float3(y, y, y);

                float pct = plot(st, y);
                color = (1.0 - pct) * color + pct * float3(0.0, 1.0, 0.0);

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
