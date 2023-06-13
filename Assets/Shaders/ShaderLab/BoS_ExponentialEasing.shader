Shader "Book of Shaders/BoS_ExponentialEasing"
{
    Properties
    {
        _A ("A", Range(0.0, 1.0)) = 0.5
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

            float _A;

            float plot(float2 st, float pct) 
            {
                return smoothstep(pct - 0.01, pct, st.y) - smoothstep(pct, pct + 0.01, st.y);
            }

            float exponentialEasing(float x, float a) {
                float epsilon = 0.00001;
                float minParamA = 0.0 + epsilon;
                float maxParamA = 1.0 - epsilon;

                a = max(minParamA, min(maxParamA, a));
  
                if (a < 0.5){
                    // emphasis
                    a = 2.0 * a;
                    return pow(x, a);
                } else {
                    // de-emphasis
                    a = 2.0 * (a - 0.5);
                    return pow(x, 1.0 / (1 - a));
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
                float y = exponentialEasing(st.x, _A);
                float3 color = float3(y, y, y);

                float pct = plot(st, y);
                color = (1.0 - pct) * color + pct * float3(0.0, 1.0, 0.0);

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
