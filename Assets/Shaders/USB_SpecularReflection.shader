Shader "Unlit/USB_SpecularReflection"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _SpecularTexture ("Specular Texture", 2D) = "black" {}
        _SpecularIntensity ("Specular Intensity", Range(0, 1)) = 1
        _Shininess ("_Shininess", Range(1, 128)) = 64
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" "LightMode" = "ForwardBase" }
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
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normalWorld : TEXCOORD1;
                float3 vertexWorld : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _SpecularTexture;
            float _SpecularIntensity;
            float _Shininess;
            float4 _LightColor0;

            float3 SpecularLighting (
                float3 colorReflection,
                float specularIntensity,
                float3 normal,
                float3 lightDirection,
                float3 viewDirection,
                float shininess
            ) {
                float3 h = normalize(lightDirection + viewDirection);
                return colorReflection * specularIntensity * pow(max(0, dot(normal, h)), shininess);
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normalWorld = UnityObjectToWorldNormal(v.normal);
                o.vertexWorld = mul(unity_ObjectToWorld, v.vertex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed3 colorReflection = _LightColor0.rgb;
                fixed3 specularColor = tex2D(_SpecularTexture, i.uv) * colorReflection;
                float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDirection = normalize(_WorldSpaceCameraPos - i.vertexWorld);
                
                half3 specular = SpecularLighting(
                    specularColor,
                    _SpecularIntensity,
                    i.normalWorld,
                    lightDirection,
                    viewDirection,
                    _Shininess
                );

                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb += specular;
                return col;
            }
            ENDCG
        }
    }
}
