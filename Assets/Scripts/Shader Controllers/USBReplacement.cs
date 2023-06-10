using UnityEngine;

[ExecuteInEditMode]
public class USBReplacement : MonoBehaviour {

    [SerializeField]
    private Shader replacementShader;

    private void OnEnable() {
        if (!this.Validate()) {
            return;
        }

        Camera.main.SetReplacementShader(this.replacementShader, "RenderType");
    }

    private void OnDisable() {
        if (!this.Validate()) {
            return;
        }

        Camera.main.ResetReplacementShader();
    }

    private bool Validate() {
        if (this.replacementShader == null) {
            Debug.LogError("No replacement shader found!");
            return false;
        }

        return true;
    }
}
