using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//[ExecuteInEditMode]
public class Composite : MonoBehaviour {

	public Material compositeMaterial;

	void OnRenderImage(RenderTexture src, RenderTexture dest) {

		Graphics.Blit (src, dest, compositeMaterial);

	}
}
