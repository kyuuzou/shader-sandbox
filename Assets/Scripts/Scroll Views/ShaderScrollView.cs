using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class ShaderScrollView : MonoBehaviour {

    [SerializeField]
    private TMP_Text title;

    [SerializeField]
    private TMP_Text description;

    [SerializeField]
    private ShaderCollection shaderCollection;

    private int cachedFocusIncrement;
    private Transform focusedShader;
    private IEnumerator focusEnumerator;
    private int focusIndex;
    private List<Transform> visibleShaders;

    private void Awake() {
        this.visibleShaders = new List<Transform>(5);
        this.shaderCollection.CategoryChanged += this.OnCategoryChanged;
    }

    private void ChangeFocusedShader(int focusIndex, int focusIncrement) {
        this.focusIndex = focusIndex;

        if (this.focusedShader != null) {
            this.focusedShader.GetComponent<ShaderFrame>()?.OnLostFocus();
        }

        this.focusedShader = this.visibleShaders[focusIncrement > 0 ? this.visibleShaders.Count - 1 : 0];
        this.title.text = this.focusedShader.name;

        ShaderFrame focusedShaderFrame = this.focusedShader.GetComponent<ShaderFrame>();

        if (focusedShaderFrame != null) {
            focusedShaderFrame.OnFocus();
            this.description.text = focusedShaderFrame.Description;
        } else {
            this.description.text = string.Empty;
        }
    }

    private void Focus(int focusIncrement) {
        if (focusIncrement == 0) {
            return;
        }
        
        if (this.focusEnumerator != null) {
            this.cachedFocusIncrement = focusIncrement;
            return;
        }

        this.cachedFocusIncrement = 0;

        this.focusEnumerator = this.FocusCoroutine(focusIncrement);
        this.StartCoroutine(this.focusEnumerator);
    }

    private IEnumerator FocusCoroutine(int focusIncrement) {
        int focusIndex = this.focusIndex + focusIncrement;

        if (! this.shaderCollection.IsValidIndex(focusIndex)) {
            this.focusEnumerator = null;
            yield break;
        }

        this.ChangeFocusedShader(focusIndex, focusIncrement);
        this.SpawnNewShader(focusIndex, focusIncrement);

        float smoothTime = 0.25f;
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

        this.RemoveOldShader(focusIndex, focusIncrement);

        this.focusEnumerator = null;
        this.Focus(this.cachedFocusIncrement);
    }

    private Transform Instantiate(int index, float x) {
        Transform prefab = this.shaderCollection.GetPrefab(index);

        if (prefab == null) {
            return null;
        }
        
        Transform shader = Transform.Instantiate(
            prefab, 
            new Vector3(x, 0.0f, 0.0f),
            prefab.rotation,
            this.transform
        );

        shader.name = prefab.name;
        return shader;
    }

    private void OnCategoryChanged(object sender, int categoryIndex) {
        if (this.focusEnumerator != null) {
            this.StopCoroutine(this.focusEnumerator);
            this.focusEnumerator = null;
        }

        this.visibleShaders.Clear();

        foreach (Transform child in this.transform) {
            GameObject.Destroy(child.gameObject);
        }

        for (int i = 0; i < 2; i++) {
            this.visibleShaders.Add(this.Instantiate(i, i * 3.0f));
        }

        this.ChangeFocusedShader(0, 0);
    }

    private void OnDestroy() {
        this.shaderCollection.CategoryChanged -= this.OnCategoryChanged;
    }

    private void RemoveOldShader(int focusIndex, int focusIncrement) {
        if (this.shaderCollection.IsValidIndex(focusIndex - focusIncrement * 2)) {
            int indexToRemove = focusIncrement > 0 ? 0 : this.visibleShaders.Count - 1;
            GameObject.Destroy(this.visibleShaders[indexToRemove].gameObject);
            this.visibleShaders.RemoveAt(indexToRemove);
        }
    }

    private void SpawnNewShader(int focusIndex, int focusIncrement) {
        if (this.shaderCollection.IsValidIndex(focusIndex + focusIncrement)) {
            Transform newShader = this.Instantiate(
                focusIndex + focusIncrement,
                focusIncrement * 3.0f * 2.0f
            );

            this.visibleShaders.Insert(focusIncrement > 0 ? this.visibleShaders.Count : 0, newShader);
        }
    }

    private void Start() {
        this.OnCategoryChanged(this, 0);
    }

    private void Update() {
        if (Input.GetKeyUp(KeyCode.RightArrow)) {
            this.Focus(1);
        } else if (Input.GetKeyUp(KeyCode.LeftArrow)) {
            this.Focus(-1);
        } else if (Input.GetMouseButtonUp(0)) {
            this.Focus((Input.mousePosition.x > Screen.width * 0.5f) ? 1 : -1);
        }
    }
}
