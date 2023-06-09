using UnityEngine;

public class ShaderFrame : MonoBehaviour {

    [SerializeField]
    private bool showSkybox = false;

    [field: SerializeField]
    public string Description { get; private set; }

    public void OnFocus() {
        if (showSkybox) {
            Camera.main.clearFlags = CameraClearFlags.Skybox;
        }
    }

    public void OnLostFocus() {
        if (showSkybox) {
            Camera.main.clearFlags = CameraClearFlags.SolidColor;
        }
    }
}
