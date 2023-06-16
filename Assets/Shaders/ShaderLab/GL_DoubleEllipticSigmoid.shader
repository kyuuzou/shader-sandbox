Shader "Book of Shaders/GL_DoubleEllipticSigmoid"
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

            float doubleEllipticSigmoid (float x, float a, float b){
                float epsilon = 0.00001;
                float min_param_a = 0.0 + epsilon;
                float max_param_a = 1.0 - epsilon;
                float min_param_b = 0.0;
                float max_param_b = 1.0;

                a = max(min_param_a, min(max_param_a, a)); 
                b = max(min_param_b, min(max_param_b, b));
 
                float y = 0;

                if (x<=a) {
                    y = b * (1 - (sqrt(pow(a, 2) - pow(x, 2))/a));
                } else {
                    y = b + ((1-b)/(1-a))*sqrt(pow(1-a, 2) - pow(x-1, 2));
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
                float y = doubleEllipticSigmoid(st.x, _A, _B);

                float3 color = float3(y, y, y);
                float pct = plot(st, y);
                color = (1.0 - pct) * color + pct * float3(0.0, 1.0, 0.0);

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
