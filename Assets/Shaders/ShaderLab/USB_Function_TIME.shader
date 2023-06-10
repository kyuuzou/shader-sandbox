Shader "Unlit/USB_Function_TIME"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        
        [KeywordEnum(None, Scroll, Rotate)]
        _AnimationType ("Animation Type", int) = 1
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
            #pragma multi_compile _ANIMATIONTYPE_SCROLL _ANIMATIONTYPE_ROTATE
            
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
            int _AnimationType;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
#if _ANIMATIONTYPE_SCROLL                
                i.uv.x += _Time.y;
#elif _ANIMATIONTYPE_ROTATE                
                i.uv.x += _SinTime.w;
                i.uv.y += _CosTime.w;
#endif
                
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
