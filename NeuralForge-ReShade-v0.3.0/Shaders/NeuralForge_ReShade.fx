#include "ReShade.fxh"

texture2D NF_BackBufferTex : COLOR;
sampler2D NF_BackBufferSampler { Texture = NF_BackBufferTex; };

uniform float NF_Detail < ui_label = "Fine Detail"; ui_type = "slider"; ui_min = 0.0; ui_max = 1.5; ui_step = 0.01; > = 0.30;
uniform float NF_EdgeClarity < ui_label = "Edge Clarity"; ui_type = "slider"; ui_min = 0.0; ui_max = 1.0; ui_step = 0.01; > = 0.20;
uniform float NF_LocalContrast < ui_label = "Local Contrast"; ui_type = "slider"; ui_min = 0.0; ui_max = 1.0; ui_step = 0.01; > = 0.15;
uniform float NF_SoftLighting < ui_label = "Soft Lighting"; ui_type = "slider"; ui_min = 0.0; ui_max = 0.5; ui_step = 0.01; > = 0.05;
uniform float NF_FabricSheen < ui_label = "Fabric Sheen"; ui_type = "slider"; ui_min = 0.0; ui_max = 0.5; ui_step = 0.01; > = 0.04;
uniform float NF_ColorRichness < ui_label = "Color Richness"; ui_type = "slider"; ui_min = 0.0; ui_max = 1.0; ui_step = 0.01; > = 0.08;
uniform float NF_Blend < ui_label = "Overall Blend"; ui_type = "slider"; ui_min = 0.0; ui_max = 1.0; ui_step = 0.01; > = 0.80;
uniform float NF_ProtectHighlights < ui_label = "Protect Bright Highlights"; ui_type = "slider"; ui_min = 0.0; ui_max = 1.0; ui_step = 1.0; > = 1.0;

float NF_Luma(float3 c)
{
    return dot(c, float3(0.2126, 0.7152, 0.0722));
}

float4 PS_NeuralForge(float4 pos : SV_Position, float2 uv : TEXCOORD) : SV_Target
{
    float2 px = BUFFER_PIXEL_SIZE;
    float3 c = tex2D(NF_BackBufferSampler, uv).rgb;
    float3 n = tex2D(NF_BackBufferSampler, uv + float2(0.0, -px.y)).rgb;
    float3 s = tex2D(NF_BackBufferSampler, uv + float2(0.0, px.y)).rgb;
    float3 e = tex2D(NF_BackBufferSampler, uv + float2(px.x, 0.0)).rgb;
    float3 w = tex2D(NF_BackBufferSampler, uv + float2(-px.x, 0.0)).rgb;

    float lum = NF_Luma(c);
    float wn = rcp(1.0 + abs(lum - NF_Luma(n)) * 8.0);
    float ws = rcp(1.0 + abs(lum - NF_Luma(s)) * 8.0);
    float we = rcp(1.0 + abs(lum - NF_Luma(e)) * 8.0);
    float ww = rcp(1.0 + abs(lum - NF_Luma(w)) * 8.0);
    float total = max(wn + ws + we + ww, 0.0001);
    float3 avg = (n * wn + s * ws + e * we + w * ww) / total;

    float3 detail = clamp(c - avg, -0.10, 0.10);
    float3 result = c + detail * NF_Detail;
    float3 crossAvg = (n + s + e + w) * 0.25;
    float guard = lerp(1.0, 1.0 - smoothstep(0.70, 1.0, lum), NF_ProtectHighlights);
    result += clamp(c - crossAvg, -0.08, 0.08) * NF_EdgeClarity * guard;
    result += detail * NF_LocalContrast;
    result += NF_SoftLighting * (1.0 - smoothstep(0.25, 0.95, lum)) * 0.08;

    // Screen-space highlight approximation; this does not detect materials.
    float highlight = smoothstep(0.45, 0.90, lum) * (1.0 - smoothstep(0.94, 1.0, lum));
    result += highlight * NF_FabricSheen * 0.05;
    float resultLum = NF_Luma(result);
    result = lerp(resultLum.xxx, result, 1.0 + NF_ColorRichness * 0.18);
    result = saturate(result);
    return float4(lerp(c, result, NF_Blend), 1.0);
}

technique NeuralForge
{
    pass
    {
        VertexShader = PostProcessVS;
        PixelShader = PS_NeuralForge;
    }
}
