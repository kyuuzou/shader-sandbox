using System.Collections;
using System.Collections.Generic;

using UnityEngine;

public class ScrollView : MonoBehaviour {

    [SerializeField]
    private Transform[] shaderPrefabs;

    private IEnumerator focusEnumerator;
    private int focusIndex;
    private List<Transform> visibleShaders;

    private void Awake() {
        this.visibleShaders = new List<Transform>(5);
    }
    
    private void Focus(int focusIncrement) {
        if (this.focusEnumerator != null) {
            return;
        }

        this.focusEnumerator = this.FocusCoroutine(focusIncrement);
        this.StartCoroutine(this.focusEnumerator);
    }

    private IEnumerator FocusCoroutine(int focusIncrement) {
        int focusIndex = this.focusIndex + focusIncrement;

        if (! IsValidIndex(focusIndex)) {
            this.focusEnumerator = null;
            yield break;
        }
            
        this.focusIndex = focusIndex;

        if (IsValidIndex(focusIndex + focusIncrement)) {
            Transform newShader = this.Instantiate(
                focusIndex + focusIncrement,
                focusIncrement * 3.0f * 2.0f
            );

            this.visibleShaders.Insert(focusIncrement > 0 ? this.visibleShaders.Count : 0, newShader);
        }

        float smoothTime = 0.5f;
        float currentVelocity = 0.0f;
        Vector3 position = this.transform.position;
        Vector3 targetPosition = position;
        targetPosition.x -= focusIncrement * 3.0f;
        
        do {
            position.x = Mathf.SmoothDamp(position.x, targetPosition.x, ref currentVelocity, smoothTime);
            smoothTime -= Time.deltaTime;

            this.transform.position = position;
            
            yield return null;
        } while (smoothTime > 0.0f);

        if (IsValidIndex(focusIndex - focusIncrement * 2)) {
            int indexToRemove = focusIncrement > 0 ? 0 : this.visibleShaders.Count - 1;
            GameObject.Destroy(this.visibleShaders[indexToRemove].gameObject);
            this.visibleShaders.RemoveAt(indexToRemove);
        }

        this.focusEnumerator = null;
    }

    private Transform Instantiate(int index, float x) {
        return Transform.Instantiate(
            shaderPrefabs[index], 
            new Vector3(x, 0.0f, 0.0f),
            Quaternion.identity,
            this.transform
        );
    }

    private bool IsValidIndex(int index) {
        return index >= 0 && index < this.shaderPrefabs.Length;
    }
    
    private void Start() {
        for (int i = 0; i < 2; i++) {
            visibleShaders.Add(this.Instantiate(i, i * 3.0f));
        }
    }

    private void Update() {
        if (Input.GetKeyUp(KeyCode.RightArrow)) {
            this.Focus(1);
        } else if (Input.GetKeyUp(KeyCode.LeftArrow)) {
            this.Focus(-1);
        }
    }
}
