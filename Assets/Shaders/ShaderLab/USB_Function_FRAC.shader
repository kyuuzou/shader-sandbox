Shader "Unity Shaders Bible/USB_Function_FRAC"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Size ("Size", Range(0.0, 0.5)) = 0.3
        
        [IntRange]
        _Repetitions ("Repetitions", Range(0, 5)) = 2
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

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Size;
            int _Repetitions;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.uv *= _Repetitions;

                float2 fractionalUV = frac(i.uv);
                float circle = length(fractionalUV - 0.5);

                // invert colors so the texture is in the center
                circle = floor(_Size / circle);

                // avoid white circle in the center
                circle = min(circle, 0.9);
                
                return tex2D(_MainTex, fractionalUV) * float4(circle.xxx, 1);
                
            }
            ENDCG
        }
    }
}
