// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/UvRotation" {
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Angle ("Angle", Range(-5.0,  5.0)) = 0.0
	}
	SubShader 
	{
		Tags { "RenderType"="Opaque"  }
		LOD 200

		pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma target 3.0

			sampler2D _MainTex;
			float _Angle;

			struct Interpolater {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

			v2f vert (Interpolater i)
			{
				v2f o;
				o.pos = UnityObjectToClipPos (i.pos);

				float2 pivot = float2(0.5,0.5);
				i.uv = i.uv - pivot;

				float cosAngle = cos(_Angle * _Time.y);
				float sinAngle = sin(_Angle * _Time.y);
				float2x2 rot = float2x2(cosAngle, -sinAngle, sinAngle, cosAngle);

				o.uv = mul(rot,i.uv);

				o.uv = o.uv + pivot;

				return o;
			}


			float4 frag (v2f i) : COLOR
			{
				return tex2D(_MainTex,i.uv);
			}

			
			ENDCG
		}
	}
	FallBack "Diffuse"
}
