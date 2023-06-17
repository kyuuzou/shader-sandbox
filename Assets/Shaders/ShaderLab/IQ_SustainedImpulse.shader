Shader "Book of Shaders/IQ_SustainedImpulse"
{
    Properties
    {
        _F ("F", Range(0.0, 1.0)) = 0.5
        _K ("K", Range(0.1, 50.0)) = 2.0
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

            float _F, _K;

            float plot(float2 st, float pct) 
            {
                return smoothstep(pct - 0.01, pct, st.y) - smoothstep(pct, pct + 0.01, st.y);
            }

            float expSustainedImpulse (float x, float f, float k)
            {
                float s = max(x-f,0.0);
                return min( x*x/(f*f), 1.0+(2.0/f)*s*exp(-k*s));
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
                float2 st = (i.uv.xy * 4)/_ScreenParams.w;
                float y = expSustainedImpulse(st.x, _F, _K);

                float3 color = 0;
                float pct = plot(st, y);
                color = (1.0 - pct) * color + pct * float3(0.0, 1.0, 0.0);

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
