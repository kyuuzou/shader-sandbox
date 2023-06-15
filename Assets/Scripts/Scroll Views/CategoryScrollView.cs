using System.Collections.Generic;
using TMPro;
using UnityEngine;

public class CategoryScrollView : MonoBehaviour {

    [SerializeField]
    private TMP_Text categoryPrefab;

    [SerializeField]
    private Transform contentRoot;

    [SerializeField]
    private ShaderCollection shadercollection;

    [SerializeField]
    private Color selectedColor = Color.green;

    [SerializeField]
    private Color unselectedColor = Color.white;

    private TMP_Text selectedMesh;
    private List<TMP_Text> textMeshes;

    private void OnCategoryChanged(object sender, int category) {
        if (this.selectedMesh != null) {
            this.selectedMesh.color = this.unselectedColor;
        }

        this.selectedMesh = this.textMeshes[category];
        this.selectedMesh.color = this.selectedColor;
    }

    private void OnDestroy() {
        this.shadercollection.CategoryChanged -= this.OnCategoryChanged;
    }

    private void SpawnCategories() {
        this.textMeshes = new List<TMP_Text>();

        float lastY = 0;

        foreach (string category in this.shadercollection.Categories) {
            TMP_Text textMesh = Object.Instantiate<TMP_Text>(
                this.categoryPrefab,
                contentRoot.position,
                this.categoryPrefab.transform.rotation,
                contentRoot
            );

            textMesh.color = this.unselectedColor;
            textMesh.text = category;

            Vector3 localPosition = textMesh.transform.localPosition;
            localPosition.y = lastY;
            textMesh.transform.localPosition = localPosition;
            
            lastY -= textMesh.preferredWidth;

            this.textMeshes.Add(textMesh);
        }
    }

    private void Start() {
        this.SpawnCategories();

        this.shadercollection.CategoryChanged += this.OnCategoryChanged;
        this.OnCategoryChanged(this, 0);
    }

    private void Update() {
        if (Input.GetKeyUp(KeyCode.UpArrow)) {
            this.shadercollection.TrySetCategory(-1);
        } else if (Input.GetKeyUp(KeyCode.DownArrow)) {
            this.shadercollection.TrySetCategory(1);
        }
    }
}