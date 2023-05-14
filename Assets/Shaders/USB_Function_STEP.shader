Shader "Unlit/USB_Function_STEP"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        [Toggle]
        _SmoothStep ("Smooth Step", Int) = 0
        
        _Edge ("Edge", Range(0, 1)) = 0.5
        _Smooth ("Smooth", Range(0, 1)) = 0.1
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
            #pragma shader_feature _SMOOTHSTEP_ON

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
            float _Edge;
            float _Smooth;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
#if _SMOOTHSTEP_ON
                fixed3 stepCol = smoothstep((i.uv.y - _Smooth), (i.uv.y + _Smooth), _Edge);
#else
                fixed3 stepCol = step(i.uv.y, _Edge);
#endif
                return fixed4(stepCol, 1);
            }
            ENDCG
        }
    }
}
