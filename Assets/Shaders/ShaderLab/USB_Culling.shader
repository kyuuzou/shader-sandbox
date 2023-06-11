Shader "Unity Shaders Bible/USB_Culling"
{
    Properties
    {
        [Header(Settings)]
        [Space(5)]
        _MainTex ("Texture", 2D) = "white" {}
        _FrontColor ("Front Color", Color) = (1, 1, 1, 1)
        _BackColor ("Back Color", Color) = (1, 0, 0, 1)
        
		[Enum(UnityEngine.Rendering.CullMode)] 
        _CullMode("Cull Mode", Int) = 0
    }
    SubShader
    {
        Tags { "Queue"="Geometry" "RenderType"="Opaque" }
        Cull [_CullMode]
        
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
            float4 _BackColor;
            float4 _FrontColor;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            fixed4 frag (v2f i, bool isFrontFace : SV_IsFrontFace) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col * isFrontFace ? _FrontColor : _BackColor;
            }
            ENDCG
        }
    }
}
