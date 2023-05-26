using System;
using TMPro;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.Rendering;

[RequireComponent(typeof(TMP_Dropdown))]
public class RenderPipelineSwitcher : MonoBehaviour {

    private enum RenderPipeline {
        BuiltIn = 0,
        Universal = 1
    }
    
    [SerializeField]
    private RenderPipelineAsset universalRenderPipelineAsset;
    
    private TMP_Dropdown dropdown;

    private void Awake() {
        Assert.IsNotNull(this.universalRenderPipelineAsset);
        
        this.dropdown = this.GetComponent<TMP_Dropdown>();
    }

    private void OnDestroy() {
        this.dropdown.onValueChanged.RemoveListener(this.OnDropdownValueChanged);
    }

    private void OnDropdownValueChanged(int value) {
        RenderPipelineAsset asset = (value == (int) RenderPipeline.Universal) ? universalRenderPipelineAsset : null;
        GraphicsSettings.defaultRenderPipeline = asset;
        QualitySettings.renderPipeline = asset;
    }
    
    private void Start() {
        bool isBuiltInPipeline = GraphicsSettings.defaultRenderPipeline == null; 
        this.dropdown.value = (int)(isBuiltInPipeline ? RenderPipeline.BuiltIn : RenderPipeline.Universal);
        this.dropdown.onValueChanged.AddListener(this.OnDropdownValueChanged);
    }
}
