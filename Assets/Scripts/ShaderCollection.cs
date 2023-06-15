using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class ShaderCollection : MonoBehaviour {

    public event EventHandler<int> CategoryChanged;

    public int CurrentCategoryIndex { get; private set; }
    public string CurrentCategory => this.categories[this.CurrentCategoryIndex];

    [SerializeField]
    private DefaultAsset shaderPrefabFolder;

    private List<string> categories;
    private Dictionary<string, List<Transform>> shaderPrefabsPerCategory;

    private void Awake() {
        this.categories = new List<string>();
        this.shaderPrefabsPerCategory = new Dictionary<string, List<Transform>>();

        this.InitializePrefabs();
    }

    public Transform GetPrefab(int index) {
        if (this.shaderPrefabsPerCategory[CurrentCategory].Count <= index) {
            return null;
        }

        return this.shaderPrefabsPerCategory[CurrentCategory][index];
    }

    private void InitializePrefabs() {
        string rootPath = AssetDatabase.GetAssetPath(this.shaderPrefabFolder);
        string[] guids = AssetDatabase.FindAssets("t:Prefab", new[] { rootPath });

        foreach (string guid in guids) {
            string assetPath = AssetDatabase.GUIDToAssetPath(guid);
            Transform asset = AssetDatabase.LoadAssetAtPath<Transform>(assetPath);

            if (asset == null) {
                continue;
            }

            ShaderFrame frame = asset.GetComponent<ShaderFrame>();
            string category = frame.Category;

            if (!this.categories.Contains(category)) {
                this.categories.Add(category);
                this.shaderPrefabsPerCategory[category] = new List<Transform>();
            }

            this.shaderPrefabsPerCategory[category].Add(asset);
        }

        this.categories.Sort();
    }

    public bool IsValidIndex(int index) {
        return index >= 0 && index < this.shaderPrefabsPerCategory[this.CurrentCategory].Count;
    }

    public bool TrySetCategory(int increment) {
        int categoryIndex = this.CurrentCategoryIndex + increment;

        if (categoryIndex < 0 || this.categories.Count <= categoryIndex) {
            return false;
        }

        this.CurrentCategoryIndex = categoryIndex;
        this.CategoryChanged?.Invoke(this, categoryIndex);

        return true;
    }
}
