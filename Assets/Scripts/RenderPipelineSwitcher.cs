using TMPro;
using UnityEngine;
using UnityEngine.Assertions;
using UnityEngine.Rendering;

[RequireComponent(typeof(TMP_Dropdown))]
public class RenderPipelineSwitcher : MonoBehaviour {

    public enum RenderPipeline {
        BuiltIn = 0,
        Universal = 1
    }
    
    [SerializeField]
    private RenderPipelineAsset universalRenderPipelineAsset;
    
    private TMP_Dropdown dropdown;

    public static RenderPipelineSwitcher Instance { get; private set; }

    private void Awake() {
        Assert.IsNotNull(universalRenderPipelineAsset);

        RenderPipelineSwitcher.Instance = this;
        this.dropdown = this.GetComponent<TMP_Dropdown>();
    }

    private void OnDestroy() {
        this.dropdown.onValueChanged.RemoveListener(this.OnDropdownValueChanged);
    }

    private void OnDropdownValueChanged(int value) {
        SetPipeline((RenderPipeline)value);
    }

    public void SetPipeline(RenderPipeline pipeline) {
        RenderPipelineAsset asset = (pipeline == RenderPipeline.Universal) ? universalRenderPipelineAsset : null;
        GraphicsSettings.defaultRenderPipeline = asset;
        QualitySettings.renderPipeline = asset;
        this.dropdown.SetValueWithoutNotify((int)pipeline);
    }

    private void Start() {
        bool isBuiltInPipeline = GraphicsSettings.defaultRenderPipeline == null; 
        this.dropdown.value = (int)(isBuiltInPipeline ? RenderPipeline.BuiltIn : RenderPipeline.Universal);
        this.dropdown.onValueChanged.AddListener(this.OnDropdownValueChanged);
    }
}
