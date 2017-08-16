Shader "Custom/Curvy"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_NearX ("NearX",Range(-0.15,0.15)) = 0
		_NearY ("NearY",Range(-0.15,0.15)) = 0
		_Far ("Far",Vector) = (0,0,0,0)
		_Color ("Color",Color) = (1,1,1,1)
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

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float _NearX;
			float _NearY;
			float4 _Far;

			struct appdata
			{
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
			};


			v2f vert (appdata v)
			{
				v2f o;
				float4 pos = mul(UNITY_MATRIX_MV,v.pos);
				float distanceSquare = pos.z * pos.z * pos.z ;
				pos.x += _NearX - max(1 - distanceSquare/_Far.x,0) * _NearX;
				pos.y += _NearY - max(1 - distanceSquare/_Far.y,0) * _NearY;

				o.pos = mul(UNITY_MATRIX_P,pos);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv) * _Color;
				return col;
			}
			ENDCG
		}
	}
}
