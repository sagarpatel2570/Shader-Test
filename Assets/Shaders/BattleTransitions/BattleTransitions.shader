// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/BattleTransitions"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {}
		_TransitionTex("Transition Texture", 2D) = "white" {}
		_Cutoff("Cutoff", Range(0, 1)) = 0
		_Color ("CuttOff Color",Color) = (0,0,0,1) 

	}

		SubShader
		{
			// No culling or depth
			Cull Off ZWrite Off ZTest Always

			Pass
			{
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag

				#include "UnityCG.cginc"

				sampler2D _TransitionTex;
				sampler2D _MainTex;
				float _Cutoff;
				float4 _Color;

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

				v2f vert(appdata v)
				{
					v2f o;
					o.vertex = UnityObjectToClipPos(v.vertex );
					o.uv = v.uv;
	
					return o;
				}

				fixed4 frag(v2f i) : SV_Target
				{
					fixed4 transit = tex2D(_TransitionTex, i.uv);

					if (transit.b < _Cutoff)
						return _Color;

					return tex2D(_MainTex, i.uv);
				}
								
				ENDCG
			}
		}
}
