Shader "Unlit/USB_DiffuseLighting"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _LightIntensity ("Light Intensity", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            Tags { "LightMode" = "ForwardBase" }
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normalWorld : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _LightIntensity;
            float4 _LightColor0;

            float3 LambertShading(
                float3 colorReflection,
                float lightIntensity,
                float3 surfaceNormal,
                float3 lightDirection
            ) {
                return colorReflection * lightIntensity * max(0, dot(surfaceNormal, lightDirection));
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normalWorld = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0))).xyz;
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 colorReflection = _LightColor0.rgb;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                half3 diffuse = LambertShading(colorReflection, _LightIntensity, i.normalWorld, lightDirection);

                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb *= diffuse;
                return col;
            }
            ENDCG
        }
    }
}
