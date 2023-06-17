Shader "Book of Shaders/KyndEquations"
{
    Properties
    {
        [IntRange]
        _Function ("Function", Range(0, 34)) = 1
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

            static const float PI = 3.14159265f;

            int _Function;

            float plot(float2 st, float pct) 
            {
                return smoothstep(pct - 0.01, pct, st.y) - smoothstep(pct, pct + 0.01, st.y);
            }

            float equation(float x, int function) {
                float y = 0;

                switch (function) {
                    case 0:
                        y = 1.0 - pow(abs(x), 0.5);
                        break;
                    case 1:
                        y = 1.0 - pow(abs(x), 1.0);
                        break;
                    case 2:
                        y = 1.0 - pow(abs(x), 1.5);
                        break;
                    case 3:
                        y = 1.0 - pow(abs(x), 2.0);
                        break;
                    case 4:
                        y = 1.0 - pow(abs(x), 2.5);
                        break;
                    case 5:
                        y = 1.0 - pow(abs(x), 3.0);
                        break;
                    case 6:
                        y = 1.0 - pow(abs(x), 3.5);
                        break;
                    case 7:
                        y = pow(cos(PI * x / 2.0), 0.5);
                        break;
                    case 8:
                        y = pow(cos(PI * x / 2.0), 1.0);
                        break;
                    case 9:
                        y = pow(cos(PI * x / 2.0), 1.5);
                        break;
                    case 10:
                        y = pow(cos(PI * x / 2.0), 2.0);
                        break;
                    case 11:
                        y = pow(cos(PI * x / 2.0), 2.5);
                        break;
                    case 12:
                        y = pow(cos(PI * x / 2.0), 3.0);
                        break;
                    case 13:
                        y = pow(cos(PI * x / 2.0), 3.5);
                        break;
                    case 14:
                        y = 1.0 - pow(abs(sin(PI * x / 2.0)), 0.5);
                        break;
                    case 15:
                        y = 1.0 - pow(abs(sin(PI * x / 2.0)), 1.0);
                        break;
                    case 16:
                        y = 1.0 - pow(abs(sin(PI * x / 2.0)), 1.5);
                        break;
                    case 17:
                        y = 1.0 - pow(abs(sin(PI * x / 2.0)), 2.0);
                        break;
                    case 18:
                        y = 1.0 - pow(abs(sin(PI * x / 2.0)), 2.5);
                        break;
                    case 19:
                        y = 1.0 - pow(abs(sin(PI * x / 2.0)), 3.0);
                        break;
                    case 20:
                        y = 1.0 - pow(abs(sin(PI * x / 2.0)), 3.5);
                        break;
                    case 21:
                        y = pow(min(cos(PI * x / 2.0), 1.0 - abs(x)), 0.5);
                        break;
                    case 22:
                        y = pow(min(cos(PI * x / 2.0), 1.0 - abs(x)), 1.0);
                        break;
                    case 23:
                        y = pow(min(cos(PI * x / 2.0), 1.0 - abs(x)), 1.5);
                        break;
                    case 24:
                        y = pow(min(cos(PI * x / 2.0), 1.0 - abs(x)), 2.0);
                        break;
                    case 25:
                        y = pow(min(cos(PI * x / 2.0), 1.0 - abs(x)), 2.5);
                        break;
                    case 26:
                        y = pow(min(cos(PI * x / 2.0), 1.0 - abs(x)), 3.0);
                        break;
                    case 27:
                        y = pow(min(cos(PI * x / 2.0), 1.0 - abs(x)), 3.5);
                        break;
                    case 28:
                        y = 1.0 - pow(max(0.0, abs(x) * 2.0 - 1.0), 0.5);
                        break;
                    case 29:
                        y = 1.0 - pow(max(0.0, abs(x) * 2.0 - 1.0), 1.0);
                        break;
                    case 30:
                        y = 1.0 - pow(max(0.0, abs(x) * 2.0 - 1.0), 1.5);
                        break;
                    case 31:
                        y = 1.0 - pow(max(0.0, abs(x) * 2.0 - 1.0), 2.0);
                        break;
                    case 32:
                        y = 1.0 - pow(max(0.0, abs(x) * 2.0 - 1.0), 2.5);
                        break;
                    case 33:
                        y = 1.0 - pow(max(0.0, abs(x) * 2.0 - 1.0), 3.0);
                        break;
                    case 34:
                        y = 1.0 - pow(max(0.0, abs(x) * 2.0 - 1.0), 3.5);
                        break;
                }
                
                return y;
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
                st.x = st.x * 2.0 - 1.0;

                float y = equation(st.x, _Function);

                float3 color = 0;
                float pct = plot(st, y);
                color = (1.0 - pct) * color + pct * float3(0.0, 1.0, 0.0);

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
