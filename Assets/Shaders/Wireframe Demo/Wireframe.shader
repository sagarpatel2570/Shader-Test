

Shader "Custom/Geometry/Wireframe"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_WireframeVal ("Wireframe width", Range(0.000, 10)) =1
		_Color ("color", color) = (1,1,1,1)
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" "Glowable" = "True" }
		

		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			Cull Back

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma geometry geom
			#include "UnityCG.cginc"

			struct v2g {
				float4 pos : SV_POSITION;
			};

			struct g2f {
				float4 pos : SV_POSITION;
				float3 bary : TEXCOORD0;
			};

			v2g vert(appdata_base v) {
				v2g o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}


			[maxvertexcount(3)]
			void geom(triangle v2g IN[3], inout TriangleStream<g2f> triStream) {

				float2 p0 = _ScreenParams.xy * IN[0].pos.xy / IN[0].pos.w;
				float2 p1 = _ScreenParams.xy * IN[1].pos.xy / IN[1].pos.w;
				float2 p2 = _ScreenParams.xy * IN[2].pos.xy / IN[2].pos.w;

				float2 edge0 = p2 - p1;
				float2 edge1 = p2 - p0;
				float2 edge2 = p1 - p0;

				float l_edge0 = length(edge0);
				float l_edge1 = length(edge1);
				float l_edge2 = length(edge2);


				float area = abs(edge1.x * edge2.y - edge1.y * edge2.x);

				float3 params = float3(0,0,0);

//				if(l_edge0 > l_edge1 && l_edge0 > l_edge2 ){
//					params.x = area/l_edge0;
//				}else if(l_edge1 > l_edge2 && l_edge1 > l_edge0 ){
//					params.z = area/l_edge2;
//				} else{
//					params.y = area/l_edge1;
//				}
				
				g2f o;
				o.pos = IN[0].pos;
				o.bary = float3(area/l_edge0  , 0, 0) + params ;
				triStream.Append(o);
				o.pos = IN[1].pos;
				o.bary = float3(0, 0, area/l_edge1 ) + params;
				triStream.Append(o);
				o.pos = IN[2].pos;
				o.bary = float3(0, area/l_edge2, 0) + params;
				triStream.Append(o);
			}

			float _WireframeVal;
			fixed4 _Color;

			fixed4 frag(g2f i) : SV_Target 
			{
				float value = min(i.bary.x ,(min(i.bary.y,i.bary.z)));
				value = exp2(-1/_WireframeVal * value * value);
				return _Color * value;
			
			}

			ENDCG
		}


	}
}