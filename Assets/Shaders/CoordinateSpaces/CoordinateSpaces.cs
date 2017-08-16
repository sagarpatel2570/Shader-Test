using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CoordinateSpaces : MonoBehaviour {

	Vector3 model;
	Vector3 view;
	Vector4 projection;
	Vector3 ndcSpace;
	Vector2 textureSpace;
	Camera cam;

	void Start () {

		cam = Camera.main;


	}
	
	void Update () {

		Matrix4x4 modelM = transform.localToWorldMatrix;
		Matrix4x4 viewM = cam.worldToCameraMatrix;
		Matrix4x4 projectionM = cam.projectionMatrix;

		model = new Vector3 (modelM.m03, modelM.m13, modelM.m23);

		Matrix4x4 mv_M = viewM * modelM;

		view = new Vector3 (mv_M.m03, mv_M.m13, mv_M.m23);

		Matrix4x4 mvp_M = projectionM *  viewM * modelM;

		projection = new Vector4 (mvp_M.m03, mvp_M.m13, mvp_M.m23,mvp_M.m33);

		//projection = projection / 2;

		//projection = new Vector4 (projection.x + projection.z, projection.y + projection.z, projection.z * 2, projection.w * 2);

		ndcSpace = new Vector3 (mvp_M.m03 / mvp_M.m33, mvp_M.m13 / mvp_M.m33, mvp_M.m23 / mvp_M.m33);

		textureSpace.x = (ndcSpace.x + 1) * 0.5f;
		textureSpace.y = (ndcSpace.y + 1) * 0.5f;

		//Debug.Log (model + "   " + view + "   " + projection + "   " + ndcSpace + "   " + textureSpace);

		Debug.Log (projection.x / Screen.width + " " + projection.y / Screen.height);
	}
}
