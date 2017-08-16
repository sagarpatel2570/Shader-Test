using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Diagnostics;

public class BattleTransiton : MonoBehaviour {

	public float battleTransitionTime = 1f;

	float currentTime;
	Material transitionMaterial;
	Vector2 offsetPlayer;
	float aspectRatio;

	const int size = 64;
	int width;

	void Start () {
		transitionMaterial = GameObject.FindObjectOfType<SimpleBlit> ().TransitionMaterial;
		aspectRatio = Camera.main.aspect;
	}

	void Update () {
		if (Input.GetMouseButtonDown(0)) {
			Vector3 pos =  Camera.main.WorldToViewportPoint (transform.position);
			offsetPlayer = pos;
			offsetPlayer.x *= aspectRatio;

			GenerateTexture (GetMaxDistance(pos));
			StartCoroutine (StartEndTransition ());
		}

		if (Input.GetMouseButtonDown(1) ) {
			Vector3 pos =  Camera.main.WorldToViewportPoint (transform.position);
			offsetPlayer = pos;
			offsetPlayer.x *= aspectRatio;

			GenerateTexture (GetMaxDistance(pos));
			StartCoroutine (StartOpenTransition ());
		}
	}

	IEnumerator StartOpenTransition () {

		currentTime = 0;
		float speed = 1 / battleTransitionTime;

		while (currentTime <= battleTransitionTime) {
			currentTime += Time.deltaTime;
			float value = Mathf.Lerp(0,1,currentTime * speed);
			transitionMaterial.SetFloat ("_Cutoff", 1-value);
			yield return null;
		}
	}

	IEnumerator StartEndTransition () {

		currentTime = 0;
		float speed = 1 / battleTransitionTime;

		while (currentTime <= battleTransitionTime) {
			currentTime += Time.deltaTime;
			float value = Mathf.Lerp(0,1,currentTime * speed);
			transitionMaterial.SetFloat ("_Cutoff",value);
			yield return null;
		}
	}

	float GetMaxDistance (Vector2 pos) {
		float max = 0;

		Vector2[] extents = new Vector2[] { new Vector2 (0, 0), new Vector2 (0, 1), new Vector2 (Camera.main.aspect , 1), new Vector2 (Camera.main.aspect, 0) };
		for (int i = 0; i < 4; i++) {
			float distance = Vector2.Distance (extents [i], pos);
			if (distance >= max) {
				max = distance;
			}
		}


		return max;
	}

	Texture2D transitionTex;
	Color[] color;

	void GenerateTexture (float maxSize) {
		width = (int)(size * aspectRatio);
		Stopwatch sw = new Stopwatch ();
		sw.Start ();
		transitionTex = new Texture2D (width, size);

		color = new Color[width * size];
		for (int y = 0; y < size; y++) {
			for (int x = 0; x < width; x++) {
				float distanceSqr = ((x / (float) size) - offsetPlayer.x) * ((x / (float)size) -offsetPlayer.x) + ((y / (float)size) - offsetPlayer.y) * ((y / (float)size) - offsetPlayer.y);
				float value = (Mathf.Sqrt(distanceSqr)/maxSize) ;
				value = 1 - value;
				color [y * width + x] = new Color (value, value, value, 1);

			}
		}



		transitionTex.SetPixels (color);
		transitionTex.Apply ();

		transitionMaterial.SetTexture("_TransitionTex",transitionTex);

		sw.Stop ();
		UnityEngine.Debug.Log (sw.Elapsed.TotalMilliseconds);
	}

//	void OnDrawGizmos () {
//
//		if (transitionTex != null && color != null) {
//			for (int y = 0; y < size; y++) {
//				for (int x = 0; x < width; x++) {
//					Gizmos.color = color [y * width + x];
//					Gizmos.DrawCube (new Vector3 (x, y, 0), Vector3.one);
//				}
//			}
//		}
//	}

}
