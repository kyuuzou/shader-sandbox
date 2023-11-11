Shader "Originals/LineGraphWithGradient"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _CircleColor ("Circle Color", Color) = (1, 1, 1, 1)

        [FloatRange]
        _CircleHoleMultiplier ("Circle Hole Multiplier", Range(0.1, 0.9)) = 0.5
                
        [FloatRange]
        _CircleRadius ("Circle Radius", Range(0.01, 0.1)) = 0.02
        
        _CircleSmooth ("Circle Smooth", float) = 10.0

        [FloatRange]
        _GradientOffset ("Gradient Offset", Range(-1.0, 1.0)) = 0.0
        
        _LineColor ("Line Color", Color) = (1, 1, 1, 1)
        _LineWidth ("Line Width", float) = 10.0
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

            float3 _CircleColor;
            float _CircleHoleMultiplier;
            float _CircleRadius;
            float _CircleSmooth;
            uniform float4 _Coordinates[32];
            float _GradientOffset;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float3 _LineColor;
            float _LineWidth;
            int _NumberOfPoints;

            bool isAbove(float2 check, float2 pointA, float2 pointB) {
                if (check.x < pointA.x || check.x > pointB.x) {
                    return false;
                }
                
                const float yLine = ((pointB.y - pointA.y) / (pointB.x - pointA.x)) * (check.x - pointA.x) + pointA.y;
                return check.y > yLine;
            }
            
            float plot(float2 st, float2 pointA, float2 pointB) {
                const float2 pa = st - pointA;
                const float2 ba = pointB - pointA;
                const float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
                
                return smoothstep(0.0, _LineWidth / _ScreenParams.y, length(pa - ba * h));
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f input) : SV_Target
            {
                float2 st = input.uv.xy / _ScreenParams.w;
                
                float3 color = float3(1.0, 1.0, 1.0);
                const float3 textureColor = tex2D(_MainTex, input.uv);
                color = lerp(color, textureColor, 1.0 - st.y + _GradientOffset);

                // draw lines
                for (int i = 1; i < _NumberOfPoints; i ++) {
                    float3 left = _Coordinates[i - 1];
                    float3 right = _Coordinates[i];
                    
                    if (isAbove(st, left, right)) {
                        // remove gradient when above a line segment
                        color = textureColor;
                    }
                    
	                color = lerp(_LineColor, color, plot(st, left, right));
                }

                // draw points
                const float circleSmooth = _CircleSmooth / _ScreenParams.y;

                for (int i = 0; i < _NumberOfPoints; i ++) {
                    const float d = distance(_Coordinates[i], st);
                    color = lerp(_CircleColor, color, smoothstep(_CircleRadius, _CircleRadius + circleSmooth, d));
                    color = lerp(textureColor, color, smoothstep(_CircleRadius * _CircleHoleMultiplier, _CircleRadius, d));
                }    
                
                return float4(color, 1.0);                
            }
            ENDCG
        }
    }
}
