using UnityEngine;

public class SkyboxToggler : MonoBehaviour, IFocusable {

    public void OnFocus() {
        Camera.main.clearFlags = CameraClearFlags.Skybox;
    }

    public void OnLostFocus() {
        Camera.main.clearFlags = CameraClearFlags.SolidColor;
    }
}
