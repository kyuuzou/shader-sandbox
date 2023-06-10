using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class ShaderFrame : MonoBehaviour {

    [field: SerializeField]
    public string Description { get; private set; }

    [SerializeField]
    private bool showSkybox = false;

    [SerializeField]
    private bool toggleOtherBehaviours = false;

    [SerializeField]
    private RenderPipelineSwitcher.RenderPipeline renderPipeline;

    public void OnFocus() {
        if (showSkybox) {
            Camera.main.clearFlags = CameraClearFlags.Skybox;
        }

        if (toggleOtherBehaviours) {
            this.SetOtherBehavioursActive(true);
        }

        if (renderPipeline != RenderPipelineSwitcher.RenderPipeline.BuiltIn) {
            RenderPipelineSwitcher.Instance.SetPipeline(renderPipeline);
        }
    }

    public void OnLostFocus() {
        if (showSkybox) {
            Camera.main.clearFlags = CameraClearFlags.SolidColor;
        }

        if (toggleOtherBehaviours) {
            this.SetOtherBehavioursActive(false);
        }

        if (renderPipeline != RenderPipelineSwitcher.RenderPipeline.BuiltIn) {
            RenderPipelineSwitcher.Instance.SetPipeline(RenderPipelineSwitcher.RenderPipeline.BuiltIn);
        }
    }

    private void SetOtherBehavioursActive(bool active) {
        foreach (MonoBehaviour component in this.GetComponents<MonoBehaviour>()) {
            if (component != this) {
                component.enabled = active;
            }
        }
    }
}
