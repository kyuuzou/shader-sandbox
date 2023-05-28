Shader "Unlit/USB_FresnelEffect"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _FresnelPower ("Fresnel Power", Range(1, 5)) = 1
        _FresnelIntensity ("Fresnel Intensity", Range(0, 1)) = 1
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
            // make fog work
            #pragma multi_compile_fog

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
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
                float3 normalWorld : TEXCOORD1;
                float3 vertexWorld : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _FresnelPower;
            float _FresnelIntensity;

            void Unity_FresnelEffect_float(float3 Normal, float3 ViewDir, float Power, out float Out)
            {
                Out = pow((1.0 - saturate(dot(normalize(Normal), normalize(ViewDir)))), Power);
            }
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);

                o.normalWorld = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0))).xyz;
                o.vertexWorld = mul(unity_ObjectToWorld, v.vertex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                UNITY_APPLY_FOG(i.fogCoord, col);

                float3 viewDirection = normalize(_WorldSpaceCameraPos - i.vertexWorld);
                float fresnel = 0;
                Unity_FresnelEffect_float(i.normalWorld, viewDirection, _FresnelPower, fresnel);

                col += fresnel + _FresnelIntensity;
                return col;
            }
            ENDCG
        }
    }
}
