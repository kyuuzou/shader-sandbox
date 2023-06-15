using System;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class ShaderCollection : MonoBehaviour {

    public event EventHandler<int> CategoryChanged;

    public List<string> Categories { get; private set; }

    public int CurrentCategoryIndex { get; private set; }
    public string CurrentCategory => this.Categories[this.CurrentCategoryIndex];

    [SerializeField]
    private DefaultAsset shaderPrefabFolder;

    [SerializeField]
    private string firstCategory = "Originals";

    [SerializeField]
    private string undefinedCategory = "Uncategorised";

    private Dictionary<string, List<Transform>> shaderPrefabsPerCategory;

    private void Awake() {
        this.Categories = new List<string>();
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
            
            if (string.IsNullOrWhiteSpace(category)) {
                category = this.undefinedCategory;
                Debug.LogWarning($"Shader has no category: {frame.name}");
            }

            if (!this.Categories.Contains(category)) {
                this.Categories.Add(category);
                this.shaderPrefabsPerCategory[category] = new List<Transform>();
            }

            this.shaderPrefabsPerCategory[category].Add(asset);
        }

        this.Categories.Sort();

        // force a privileged category to go first
        this.Categories.Remove(this.firstCategory);
        this.Categories.Insert(0, this.firstCategory);
    }

    public bool IsValidIndex(int index) {
        return index >= 0 && index < this.shaderPrefabsPerCategory[this.CurrentCategory].Count;
    }

    public bool TrySetCategory(int increment) {
        int categoryIndex = this.CurrentCategoryIndex + increment;

        if (categoryIndex < 0 || this.Categories.Count <= categoryIndex) {
            return false;
        }

        this.CurrentCategoryIndex = categoryIndex;
        this.CategoryChanged?.Invoke(this, categoryIndex);

        return true;
    }
}
