using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class InfiniteMapGenerator : MonoBehaviour {

	public Transform mapPrefab;
	public Transform player;
	public float mapChunkDistance;
	public float maxViewDistance;
	public Vector3 offset;

	Queue<Transform> mapChunks;
	Vector3 currentChunkPos;



	void Start () {
		mapChunks = new Queue<Transform> ();
		GenerateMapAndFillQueue ();
		StartCoroutine (GenerateMaps ());
	}



	void GenerateMapAndFillQueue () {
		while (true) {
			Transform mapChunk = Instantiate (mapPrefab, currentChunkPos + offset, Quaternion.identity) as Transform;
			float distance =  currentChunkPos.z + mapChunkDistance - player.position.z;
			mapChunks.Enqueue (mapChunk);
			if (distance > maxViewDistance + 2 * mapChunkDistance) {
				break; 
			} else {
				currentChunkPos += Vector3.forward * mapChunkDistance;
			}
		}
	}
	
	IEnumerator GenerateMaps () {
		while (true) {

			if ((currentChunkPos.z + mapChunkDistance - player.position.z) < maxViewDistance) {
				Transform chunk = mapChunks.Dequeue ();
				currentChunkPos += Vector3.forward * mapChunkDistance;
				chunk.position = currentChunkPos + offset; 
				mapChunks.Enqueue (chunk);
			}


			yield return null;
		}
	}
}
