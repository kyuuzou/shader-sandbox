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

    public void OnFocus() {
        if (showSkybox) {
            Camera.main.clearFlags = CameraClearFlags.Skybox;
        }

        if (toggleOtherBehaviours) {
            this.SetOtherBehavioursActive(true);
        }
    }

    public void OnLostFocus() {
        if (showSkybox) {
            Camera.main.clearFlags = CameraClearFlags.SolidColor;
        }

        if (toggleOtherBehaviours) {
            this.SetOtherBehavioursActive(false);
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
