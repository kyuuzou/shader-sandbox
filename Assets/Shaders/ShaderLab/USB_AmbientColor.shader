Shader "Unlit/USB_AmbientColor"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Ambient ("Ambient Color", Range(0, 1)) = 1
        
        [Toggle]
        _DemoMode ("Demo Mode", float) = 1
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
            #pragma shader_feature _DEMOMODE_ON

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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Ambient;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
#if _DEMOMODE_ON
                _Ambient = abs(sin(_Time.x * 30));
#endif
                fixed4 col = tex2D(_MainTex, i.uv);
                float3 ambientColor = UNITY_LIGHTMODEL_AMBIENT * _Ambient;
                col.rgb += ambientColor;
                
                return col;
            }
            ENDCG
        }
    }
}
