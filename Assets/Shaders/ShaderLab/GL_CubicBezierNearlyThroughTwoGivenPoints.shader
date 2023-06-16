Shader "Book of Shaders/GL_CubicBezierNearlyThroughTwoGivenPoints"
{
    Properties
    {
        _A ("A", Range(0.0, 0.5)) = 0.5
        _B ("B", Range(0.0, 1.0)) = 0.5
        _C ("C", Range(0.5, 1.0)) = 0.5
        _D ("D", Range(0.0, 1.0)) = 0.5
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
            #include "Assets/Shaders/Functions/CubicBezier.hlsl"

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

            float _A, _B, _C, _D;

            float plot(float2 st, float pct) 
            {
                return smoothstep(pct - 0.01, pct, st.y) - smoothstep(pct, pct + 0.01, st.y);
            }

            float B0(float t) {
                return (1 - t) * (1 - t) * (1 - t);
            }

            float B1(float t) {
                return 3 * t * (1 - t) * (1 - t);
            }

            float B2(float t) {
                return 3 * t * t * (1 - t);
            }

            float B3(float t) {
                return t * t * t;
            }

            float findx(float t, float x0, float x1, float x2, float x3) {
                return x0 * B0(t) + x1 * B1(t) + x2 * B2(t) + x3 * B3(t);
            }

            float findy(float t, float y0, float y1, float y2, float y3) {
                return y0 * B0(t) + y1 * B1(t) + y2 * B2(t) + y3 * B3(t);
            }

            float cubicBezierNearlyThroughTwoPoints(
                float x, float a, float b, float c, float d) {

                float y = 0;
                float epsilon = 0.00001;
                float min_param_a = 0.0 + epsilon;
                float max_param_a = 1.0 - epsilon;
                float min_param_b = 0.0 + epsilon;
                float max_param_b = 1.0 - epsilon;
                a = max(min_param_a, min(max_param_a, a));
                b = max(min_param_b, min(max_param_b, b));

                float x0 = 0;
                float y0 = 0;
                float x4 = a;
                float y4 = b;
                float x5 = c;
                float y5 = d;
                float x3 = 1;
                float y3 = 1;
                float x1, y1, x2, y2; // to be solved.

                // arbitrary but reasonable 
                // t-values for interior control points
                float t1 = 0.3;
                float t2 = 0.7;

                float B0t1 = B0(t1);
                float B1t1 = B1(t1);
                float B2t1 = B2(t1);
                float B3t1 = B3(t1);
                float B0t2 = B0(t2);
                float B1t2 = B1(t2);
                float B2t2 = B2(t2);
                float B3t2 = B3(t2);

                float ccx = x4 - x0 * B0t1 - x3 * B3t1;
                float ccy = y4 - y0 * B0t1 - y3 * B3t1;
                float ffx = x5 - x0 * B0t2 - x3 * B3t2;
                float ffy = y5 - y0 * B0t2 - y3 * B3t2;

                x2 = (ccx - (ffx * B1t1) / B1t2) / (B2t1 - (B1t1 * B2t2) / B1t2);
                y2 = (ccy - (ffy * B1t1) / B1t2) / (B2t1 - (B1t1 * B2t2) / B1t2);
                x1 = (ccx - x2 * B2t1) / B1t1;
                y1 = (ccy - y2 * B2t1) / B1t1;

                x1 = max(0 + epsilon, min(1 - epsilon, x1));
                x2 = max(0 + epsilon, min(1 - epsilon, x2));

                // Note that this function also requires cubicBezier()!
                y = cubicBezier(x, x1, y1, x2, y2);
                y = max(0, min(1, y));
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
                float y = cubicBezierNearlyThroughTwoPoints(st.x, _A, _B, _C, _D);

                float3 color = float3(y, y, y);
                float pct = plot(st, y);
                color = (1.0 - pct) * color + pct * float3(0.0, 1.0, 0.0);

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
