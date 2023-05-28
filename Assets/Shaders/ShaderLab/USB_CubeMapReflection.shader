Shader "Unlit/USB_CubeMapReflection"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ReflectionTexture ("Reflection Texture", Cube) = "white" {}
        _ReflectionIntensity ("Reflection Intensity", Range(0, 1)) = 1
        _Shininess ("Shininess", Range(0, 1)) = 0
        _TexelDensity ("Texel Density", Range(1, 9)) = 1
        _ColorExposure ("Color Exposure", Range(1, 3)) = 1
        
        [Toggle]
        _UseUnitySampleTexCube ("Use UNITY_SAMPLE_TEXCUBE", Float) = 0
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
            #pragma shader_feature _USEUNITYSAMPLETEXCUBE_ON

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
            samplerCUBE _ReflectionTexture;
            float _ReflectionIntensity;
            half _Shininess;
            float _TexelDensity;
            float _ColorExposure;
            
            float3 AmbientReflection (
                samplerCUBE colorReflection,
                float reflectionIntensity,
                half texelDensity,
                float3 normal,
                float3 viewDirection,
                float colorExposure
            ) {
                float3 reflectionWorld = reflect(viewDirection, normal);

                // float4 texCUBElod(samplerCUBE samp, float4 s)
                // s.xyz = reflection coordinates
                // s.w = texel density
                float4 cubemap = texCUBElod(colorReflection, float4(reflectionWorld, texelDensity));

                return reflectionIntensity * cubemap.rgb * (cubemap.a * colorExposure);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normalWorld = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0))).xyz;
                o.vertexWorld = mul(unity_ObjectToWorld, v.vertex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                half3 viewDirection = normalize(UnityWorldSpaceViewDir(i.vertexWorld));
                fixed4 col = tex2D(_MainTex, i.uv);

#if _USEUNITYSAMPLETEXCUBE_ON
                half3 reflectWorld = reflect(-viewDirection, i.normalWorld);
                half4 reflectionData = UNITY_SAMPLE_TEXCUBE(unity_SpecCube0, reflectWorld);
                half3 reflectionColor = DecodeHDR(reflectionData, unity_SpecCube0_HDR);
                col.rgb *= reflectionColor;
#else
                half3 reflection = AmbientReflection(
                    _ReflectionTexture,
                    _ReflectionIntensity,
                    _Shininess,
                    i.normalWorld,
                    -viewDirection,
                    _ColorExposure
                );
                
                col.rgb *= reflection + _Shininess;
#endif
                return col;
            }
            ENDCG
        }
    }
}
