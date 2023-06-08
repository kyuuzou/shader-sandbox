Shader "Unlit/USB_SDF_Fruit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _PlaneTex ("Plane Texture", 2D) = "white" {}
        _CircleColor ("Circle Color", Color) = (1, 1, 1, 1)
        _CircleRad ("Circle Radius", Range(0.0, 0.5)) = 0.45
        _Edge ("Edge", Range(-0.5, 0.5)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            #define MAX_MARCHING_STEPS 50
            #define MAX_DISTANCE 10.0
            #define SURFACE_DISTANCE 0.001
            
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 hitPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _PlaneTex;
            float4 _MainTex_ST;
            float4 _CircleColor;
            float _CircleRad;
            float _Edge;

            float planeSDF(float3 rayPosition)
            {
                return rayPosition.y - _Edge;
            }

            float sphereCasting(float3 rayOrigin, float3 rayDirection)
            {
                float distanceOrigin = 0.0f;

                for (int i = 0; i < MAX_MARCHING_STEPS; i ++)
                {
                    float3 rayPosition = rayOrigin + rayDirection * distanceOrigin;
                    float distanceScene = planeSDF(rayPosition);
                    distanceOrigin += distanceScene;

                    if (distanceScene < SURFACE_DISTANCE || distanceOrigin > MAX_MARCHING_STEPS)
                    {
                        break;
                    }
                }

                return distanceOrigin;
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.hitPos = v.vertex;
                
                return o;
            }

            fixed4 frag (v2f i, bool face : SV_isFrontFace) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                float3 rayOrigin = mul(unity_WorldToObject, float4(_WorldSpaceCameraPos, 1));
                float3 rayDirection = normalize(i.hitPos - rayOrigin);

                float t = sphereCasting(rayOrigin, rayDirection);
                float4 planeColor = 0;
                
                if (t < MAX_DISTANCE)
                {
                    float3 p = rayOrigin + rayDirection * t;
                    float2 uvP = p.xz;
                    float l = pow(-abs(_Edge), 2) + pow(-abs(_Edge) - 1, 2);
                    float c = length(uvP);

                    float4 circleColor = (smoothstep(c - 0.01, c + 0.01, _CircleRad - abs(pow(_Edge * (1 * 0.5), 2))));
                    planeColor = tex2D(_PlaneTex, uvP * (1.0 + abs(pow(_Edge * l, 2))) - 0.5);
                    planeColor *= circleColor;
                    planeColor += (1.0 - circleColor) * _CircleColor;
                }
                
                if (i.hitPos.y > _Edge)
                {
                    discard;
                }
                
                return face ? col : planeColor;
            }
            ENDCG
        }
    }
}
