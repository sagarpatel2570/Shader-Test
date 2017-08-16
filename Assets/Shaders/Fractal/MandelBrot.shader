// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MandelBrot" {
	Properties
	{
		_Zoom ("Zoom",Float) = 2.5
		_MoveX("Move X",Float) = 0
		_MoveY("Move Y",Float) = 0
		_BoundValue("BoundValue",Float) = 16
		_Iteration("Iteration",Float) = 100

		_CX("CX",Float) = 0
		_CY("CY",Float) = 0

	}
	SubShader
	{
		Tags { "RenderType"="Opaque"  }
		

		Pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#pragma target 3.0

			#include "UnityCG.cginc"

			float _Zoom;
			float _MoveX;
			float _MoveY;
			float _BoundValue;
			float _Iteration;
			float _CX;
			float _CY;

			struct interpolater {
				float4 pos : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};

		

			v2f vert(interpolater v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.pos);
				o.uv = v.uv * 2 - 1 ;


				o.uv = o.uv ;

				float cosAngle = cos( _Time.y);
				float sinAngle = sin( _Time.y);
				float2x2 rot = float2x2(cosAngle, -sinAngle, sinAngle, cosAngle);

				o.uv = mul(rot,o.uv);

				o.uv = o.uv ;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target 
			{
				float a = (i.uv.x ) * _Zoom - _MoveX;
				float b = (i.uv.y ) * _Zoom - _MoveY;

				float n = 0;
				float colVal = 1;

				float ca = a;
				float cb = b;

				float cx = cos(_Time.x * _CX);
				float cy = sin(_Time.x * _CY);

				while(n < _Iteration)
				{

					float aa = a*a - b*b;
					float bb = 2 * a * b;

					if(abs(a*a + b*b) > _BoundValue){
						break;
					}

					a = aa + cx;
					b = bb + cy;

				
					n++;
				}

				colVal = n/_Iteration;

				if(n == _Iteration)
				{
					colVal = 0;
				}

				return float4(sin(colVal/5 * 30),sin(colVal/6 * 50),sin(colVal/7 * 80) ,1) + 0.4 ;
			
			}

			ENDCG
		}


	}
}
