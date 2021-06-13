Shader "Custom/SpecularBRDF"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _ColorTint("Color", Color) = (1,1,1,1)
        _SpecColor("Specular Color", Color) = (1,1,1,1)
        _BumpMap("Normal Map", 2D) = "bump" {}
        _Roughness ("Roughness", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf CookTorrance fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uv_MainTex;
        };

        #define PI 3.1415926535F
 
        sampler2D _MainTex;
        sampler2D _BumpMap;
        float _Roughness;
        fixed4 _ColorTint;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        // Calculate terms
        float ggxDistribution(float a, float nDoth)
        {
            float alpha = pow(a, 2);
            float rightElement = pow(nDoth, 2) * (alpha - 1) + 1;
            float bottomValue = PI * pow(rightElement, 2);
            return alpha / bottomValue;
        }
 
        float schlickFresnel(float4 specularColor, float lDoth)
        {
            return specularColor + (1 - specularColor) * pow(1 - lDoth, 5);
        }

        float implicitGeometry(float nDotl, float nDotv)
        {
            return nDotl * nDotv;
        }

        float kelemenGeometry(float nDotl, float nDotv, float vDoth)
        {
            return nDotl * nDotv / pow(vDoth, 2);
        }

        float neumannGeometry(float nDotl, float nDotv)
        {
            return nDotl * nDotv / max(nDotl, nDotv);
        }

        float g1 (float k, float x)
        {
            return x / (x * (1 - k) + k);
        }

        float smithGeometry(float nDotl, float nDotv, float roughness)
        {
            float r = roughness + 1;
            float k = pow(r, 2) / 8;
            float glL = g1(k, nDotl);
            float glV = g1(k, nDotv);

            return glL * glV;
        }

        // Implement Custom Lighting Model
        // For declaring custom lighting models, Its method name must be string that begin 'Lighting'.
        void LightingCookTorrance_GI(SurfaceOutput s, UnityGIInput data, inout UnityGI gi)
		{
			gi = UnityGlobalIllumination(data, 1.0, s.Normal);
		}

        float3 cookTorranceSpecular(float nDotl,float nDotv, float nDoth, float vDoth, float lDoth, float roughness, float specColor)
        {
            float alpha = pow(roughness, 2);
            float f, d, g;
            f = schlickFresnel(specColor, lDoth);
            d = ggxDistribution(alpha, nDoth);
            // g = implicitGeometry(nDotl, nDotv);
            // g = neumannGeometry(nDotl, nDotv);
            g = kelemenGeometry(nDotl, nDotv, vDoth);
            // g = smithGeometry(nDotl, nDotv, roughness);

            float bottomValue = 4 * nDotl * nDotv;
            return d * f * g / bottomValue;
        }

        float4 LightingCookTorrance(SurfaceOutput s, float3 viewDir, UnityGI gi)
        {
            float3 halfV = normalize(gi.light.dir + viewDir);
            float nDotl = dot(s.Normal, gi.light.dir);
            float nDotv = dot(s.Normal, halfV);
            float nDoth = dot(s.Normal, viewDir);
            float vDoth = dot(viewDir, halfV);
            float lDoth = dot(gi.light.dir, halfV);

            float3 specularBRDF = cookTorranceSpecular(nDotl, nDotv, nDoth, vDoth, lDoth, _Roughness, _SpecColor);

            float3 firstLayer = specularBRDF * _SpecColor * _LightColor0.rgb;
            float4 c = float4(firstLayer, s.Alpha);

        #ifdef UNITY_LIGHT_FUNCTION_APPLY_INDIRECT
            c.rgb += s.Albedo * gi.indirect.diffuse;
        #endif

            return c;
        }

        void surf (Input IN, inout SurfaceOutput o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _ColorTint;
            o.Albedo = c.rgb;
            o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_MainTex));
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
