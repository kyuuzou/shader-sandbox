Shader "Unity Shaders Bible/USB_Blending"
{
    Properties
    {
        [Header(Settings)]
        [Space(5)]
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        
        [Enum(UnityEngine.Rendering.BlendMode)]
        _SrcBlend ("Source Blend Factor", int) = 1
        
        [Enum(UnityEngine.Rendering.BlendMode)]
        _DstBlend ("Destination Blend Factor", int) = 1
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }
        Blend [_SrcBlend] [_DstBlend]
        
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

            // _MainTex_ST = _MainTex_Scale_Translation
            // For any texture property, Unity provides value for float4 with "_ST" suffix.
            // The x,y contains texture scale, and z,w contains translation (offset).
            float4 _MainTex_ST;
            float4 _Color;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col * _Color;
            }
            ENDCG
        }
    }
}
