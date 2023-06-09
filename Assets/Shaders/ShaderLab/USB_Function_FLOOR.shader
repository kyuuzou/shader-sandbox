Shader "Unity Shaders Bible/USB_Function_FLOOR"
{
    Properties
    {
        [IntRange]
        _Sections ("Sections", Range(2, 10)) = 5
        
        _Gamma ("Gamma", Range(0, 1)) = 0 
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

            float _Sections;
            float _Gamma;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float flooredV = floor(i.uv.y * _Sections) * (_Sections / 100);
                return float4(flooredV.xxx, 1) + _Gamma;
            }
            ENDCG
        }
    }
}
