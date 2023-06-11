    Shader "Unity Shaders Bible/USB_Simple_Color_URP"
{
    Properties
    {
        [Header(Settings)]
        [Space(5)]
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1, 1, 1, 1)
        
        [KeywordEnum(Off, Red, Blue)]
        _Options ("Color Options", Float) = 0
        
        [Enum(Off, 0, Front, 1, Back, 2)]
        _FaceCulling ("Face Culling", Float) = 0
        
        [PowerSlider(3.0)]
        _Brightness ("Brightness", Range(0.01, 1)) = 0.08
        
        [IntRange]
        _Samples ("Samples", Range (0, 255)) = 100
        
        [Space(20)]
        [Header(Conditions)]
        [Space(5)]
        [Toggle]
        _Enable ("Enable", Float) = 0
    }
    SubShader
    {
        Tags { 
            "Queue"="Geometry"
            "RenderType"="Opaque"
            "RenderPipeline"="UniversalRenderPipeline"
        }
        
        Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Cull [_FaceCulling]
        
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature _ENABLE_ON
            #pragma multi_compile _OPTIONS_OFF _OPTIONS_RED _OPTIONS_BLUE

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

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
            float _Brightness;
            int _Samples;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = TransformObjectToHClip(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half4 col = tex2D(_MainTex, i.uv);

                #if _ENABLE_ON
                    #if _OPTIONS_RED
                        return col * float4(1, 0, 0, 1);
                    #elif _OPTIONS_BLUE
                        return col * float4(0, 0, 1, 1);
                    #else
                        return col * _Color;
                    #endif
                #else
                    return col;
                #endif
            }
            ENDHLSL
        }
    }
}
