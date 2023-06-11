Shader "Unity Shaders Bible/USB_Function_LENGTH"
{
    Properties
    {
        _Radius ("Radius", Range(0.0, 0.5)) = 0.3
        _Center ("Center", Range(0, 1)) = 0.5
        _Smooth ("Smooth", Range(0.0, 0.5)) = 0.01
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

            float _Smooth;
            float _Radius;
            float _Center;

            float circle (float2 p, float center, float radius, float smooth)
            {
                float c = length(p - center) - radius;
                return smoothstep(c - smooth, c + smooth, radius);
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
                float c = circle(i.uv, _Center, _Radius, _Smooth);
                return float4(c.xxx, 1);
            }
            ENDCG
        }
    }
}
