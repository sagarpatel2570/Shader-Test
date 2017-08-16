using System.Collections;
using System.Collections.Generic;
using UnityEngine;

//[ExecuteInEditMode]
public class GlowPrepass : MonoBehaviour {

	public Shader replacementShader;
	public Material blurMaterial;

	public int iteration;
	public int blurAmount;

	RenderTexture blurRT;
	RenderTexture normalRT;

	void OnEnable () {
		normalRT = new RenderTexture (Screen.width, Screen.height, 24);
		GetComponent<Camera> ().targetTexture = normalRT;
		GetComponent<Camera> ().SetReplacementShader (replacementShader, "Glowable");

		blurRT = new RenderTexture(normalRT.width >> blurAmount, normalRT.height >> blurAmount,0);
		Shader.SetGlobalTexture ("_NormalTex", normalRT);
		Shader.SetGlobalTexture ("_BlurTex", blurRT);
	}

	void OnRenderImage(RenderTexture src, RenderTexture dest) {
		Graphics.Blit(src, dest);
		Graphics.SetRenderTarget (blurRT);
		GL.Clear(false, true, Color.clear);

		Graphics.Blit (src, blurRT);

		for (int i = 0; i < iteration; i++) {
			RenderTexture rt = RenderTexture.GetTemporary (blurRT.width, blurRT.height);
			Graphics.Blit (blurRT, rt, blurMaterial);
			Graphics.Blit (rt, blurRT, blurMaterial);
			RenderTexture.ReleaseTemporary (rt);
		}
	}
}
