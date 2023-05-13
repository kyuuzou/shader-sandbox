Shader "Unlit/USB_Function_SINCOS"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Rotation Speed", Range(0, 3)) = 1
        
        [KeywordEnum(x, y, z)]
        _Axis ("Axis", int) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it uses non-square matrices
#pragma exclude_renderers gles
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
            float _Speed;
            int _Axis;
            
            float3 rotate(float3 vertex)
            {
                // _TIME = Time since level load (t/20, t, t*2, t*3)
                float c = cos(_Time.y * _Speed);
                float s = sin(_Time.y * _Speed);

                float3x2 rotationMatrix;

                switch(_Axis)
                {
                    case 0: // x
                        rotationMatrix = float3x3(1, 0, 0, 0, c, s, 0, -s, c);
                        break;
                    case 1: // y
                        rotationMatrix = float3x3(c, 0, s, 0, 1, 0, -s, 0, c);
                        break;
                    default: // z
                        rotationMatrix = float3x3(c, s, 0, -s, c, 0, 0, 0, 1);
                        break;
                }

                return mul(rotationMatrix, vertex);
            }

            v2f vert (appdata v)
            {
                v2f o;
                float3 rotatedVertex = rotate(v.vertex);
                o.vertex = UnityObjectToClipPos(rotatedVertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
