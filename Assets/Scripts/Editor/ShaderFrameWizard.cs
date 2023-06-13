using System.IO;
using UnityEditor;
using UnityEngine;

public class ShaderFrameWizard : ScriptableWizard {

    [SerializeField]
    private string shaderFolder = "Shader Sandbox";

    [SerializeField]
    private string shaderName = "NewShader";

    private static readonly string ShaderFolderKey = "ShaderFolder";

    [MenuItem("Shader Sandbox/Create Shader Frame", priority = 'C')]
    static void CreateWizard() {
        ShaderFrameWizard wizard = ScriptableWizard.DisplayWizard<ShaderFrameWizard>("Create Shader Frame", "Create");

        if (PlayerPrefs.HasKey(ShaderFolderKey)) {
            wizard.shaderFolder = PlayerPrefs.GetString(ShaderFolderKey);
        }
    }
    
    private void OnWizardCreate() {
        string prefabPath = "Assets/Prefabs/Actors/Frame.prefab";
        string variantPath = $"Assets/Prefabs/Shaders/{shaderName}.prefab";
        string materialPath = $"Assets/Materials/Shaders/{shaderName}.mat";
        string shaderPath = $"Assets/Shaders/ShaderLab/{shaderName}.shader";
        string templateShaderPath = "Assets/Shaders/Templates/ShaderLab.shader";

        PlayerPrefs.SetString(ShaderFolderKey, shaderFolder);

        GameObject originalPrefab = AssetDatabase.LoadAssetAtPath<GameObject>(prefabPath);
        GameObject sceneObject = PrefabUtility.InstantiatePrefab(originalPrefab) as GameObject;
        sceneObject.name = shaderName;

        GameObject prefabVariant = PrefabUtility.SaveAsPrefabAsset(sceneObject, variantPath);
        GameObject.DestroyImmediate(sceneObject);

        string shaderCode = File.ReadAllText(templateShaderPath);
        string shaderShortcut = $"{shaderFolder}/{shaderName}";
        shaderCode = shaderCode.Replace("Shader Sandbox/Template", shaderShortcut);

        File.WriteAllText(shaderPath, shaderCode);
        AssetDatabase.ImportAsset(shaderPath, ImportAssetOptions.ForceUpdate);

        Shader shader = Shader.Find(shaderShortcut);

        Material material = new Material(shader);
        material.name = shaderName;
        AssetDatabase.CreateAsset(material, materialPath);
        prefabVariant.GetComponent<Renderer>().sharedMaterial = material;

        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        PrefabUtility.InstantiatePrefab(prefabVariant);
    }
}