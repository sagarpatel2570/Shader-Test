
Shader "Custom/Composite" {
	Properties {
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque"  }
		LOD 200

		pass{


			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma target 3.0

			sampler2D _MainTex;
			float2 _MainTex_TexelSize;

			struct Interpolater {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
			};

			v2f vert (Interpolater i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(i.pos);
				o.uv0 = i.uv;
				o.uv1 = i.uv;


				#if UNITY_UV_STARTS_AT_TOP
				if (_MainTex_TexelSize.y < 0)
					o.uv1.y = 1 - o.uv1.y;
				#endif

				return o;
			}

			uniform sampler2D _BlurTex;
			uniform sampler2D _NormalTex;

			float4 frag (v2f i) : COLOR
			{
				fixed4 col = tex2D(_MainTex, i.uv0);
				fixed4 glow = max(0,  tex2D(_BlurTex, i.uv1) - tex2D(_NormalTex, i.uv1));
				return col + glow;
			}

			
			ENDCG
		}
	}
	FallBack "Diffuse"
}
