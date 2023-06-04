Shader "Unlit/MouseFocus"
{
    Properties
    {
        _MousePosition ("Mouse Position", Vector) = (0, 0, 0)
        
        [Toggle]
        _ShowBaseColor ("Show Base Color", int) = 0
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
            #pragma shader_feature _SHOWBASECOLOR_ON

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
                float3 worldPosition : TEXCOORD1;
            };

            float2 _MousePosition;
            
            v2f vert (appdata v)
            {
                v2f o;
                o.uv = v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPosition = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1.0)).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float2 fragNormalizedPosition = i.uv.xy/_ScreenParams.w;
                float distanceFromMouse = distance(i.worldPosition, _MousePosition.xy);
                float focus = lerp(1.0, 0.0, distanceFromMouse * 5.0);

                #if _SHOWBASECOLOR_ON
    	            return float4(fragNormalizedPosition.xy + focus, focus, 1.0);
                #else
    	            return float4(fragNormalizedPosition.xy + focus, focus, 1.0);
                #endif
            }

            ENDCG
        }
    }
}
