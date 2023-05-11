Shader "Unlit/USB_Function_ABS"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Rotation ("Rotation", Range(0, 360)) = 0
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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Rotation;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            // https://docs.unity3d.com/Packages/com.unity.shadergraph@12.1/manual/Rotate-Node.html
            float2 Unity_Rotate_Degrees_float(float2 UV, float2 Center, float Rotation)
            {
                Rotation = Rotation * (3.1415926f/180.0f);
                UV -= Center;
                
                float s = sin(Rotation);
                float c = cos(Rotation);
                float2x2 rMatrix = float2x2(c, -s, s, c);
                
                rMatrix *= 0.5;
                rMatrix += 0.5;
                rMatrix = rMatrix * 2 - 1;
                
                UV.xy = mul(UV.xy, rMatrix);
                UV += Center;
                
                return UV;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                float u = abs(i.uv.x - 0.5);
                float v = abs(i.uv.y - 0.5);

                float rotation = _Rotation;
                float center = 0.5;
                float2 uv = Unity_Rotate_Degrees_float(float2(u,v), center, rotation);
                fixed4 col = tex2D(_MainTex, uv);
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;
            }
            ENDCG
        }
    }
}
