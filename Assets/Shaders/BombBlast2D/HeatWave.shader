Shader "Custom/HeatWave"
{
	Properties
	{
		_DisplaceTex("Displacement Texture", 2D) = "white" {}
		_Magnitude("Magnitude", Range(0,0.1)) = 1
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Queue" = "Transparent" }

		GrabPass
		{
			"_BehindTex"
		}

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _BehindTex;

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

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = ComputeGrabScreenPos(o.vertex);
				return o;
			}
			sampler2D _DisplaceTex;
			float _Magnitude;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 distuv = float2(i.uv.x + _Time.x * 2, i.uv.y + _Time.x * 2);

				float2 disp = tex2D(_DisplaceTex, distuv).xy;
				disp = ((disp * 2) - 1) * _Magnitude;

				fixed4 col = tex2D(_BehindTex, UNITY_PROJ_COORD(i.uv + disp));
				return col ;
			}
			ENDCG
		}
	}
}
