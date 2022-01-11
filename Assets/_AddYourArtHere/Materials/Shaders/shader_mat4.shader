Shader "Legacy Shaders/Reflective/Bumped Diffuse" {
Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _ReflectColor ("Reflection Color", Color) = (1,1,1,0.5)
    _MainTex ("Base (RGB) RefStrength (A)", 2D) = "white" {}
    _Cube ("Reflection Cubemap", Cube) = "_Skybox" { }
    _BumpMap ("Normalmap", 2D) = "bump" {}
}

SubShader {
    Tags { "RenderType"="Opaque" }
    LOD 300

CGPROGRAM
#pragma surface surf Lambert

sampler2D _MainTex;
sampler2D _BumpMap;
samplerCUBE _Cube;

fixed4 _Color;
fixed4 _ReflectColor;

struct Input {
    float2 uv_MainTex;
    float2 uv_BumpMap;
    float3 worldRefl;
    INTERNAL_DATA
};

void surf (Input IN, inout SurfaceOutput o) {
    fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
    fixed4 c = tex * _Color;
    o.Albedo = sin(22.*IN.uv_MainTex.xyx * 3.14159265358979 + _Time.z) * 0.5 + 0.5;
    o.Albedo.r = sin(IN.uv_MainTex.x + _Time.z) * 0.5 + 0.5;
    o.Albedo.g = sin(5.*IN.uv_MainTex.x + _Time.z) * 0.5 + 0.5;
    o.Albedo.b = sin(10.*IN.uv_MainTex.x + _Time.z) * 0.5 + 0.5;

    o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));

    float3 worldRefl = WorldReflectionVector (IN, o.Normal);
    fixed4 reflcol = texCUBE (_Cube, worldRefl);
    reflcol *= tex.a;
    o.Emission = reflcol.rgb * _ReflectColor.rgb;
    o.Alpha = reflcol.a * _ReflectColor.a;
}
ENDCG
}

FallBack "Legacy Shaders/Reflective/VertexLit"
}