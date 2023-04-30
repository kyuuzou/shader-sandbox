using UnityEngine;

[ExecuteInEditMode]
public class ShaderReplacer : MonoBehaviour {

    [SerializeField]
    private new Camera camera;

    [SerializeField]
    private Shader replacementShader;

    private void OnEnable() {
        if (!this.Validate()) {
            return;
        }

        this.camera.SetReplacementShader(this.replacementShader, "RenderType");
    }

    private void OnDisable() {
        if (!this.Validate()) {
            return;
        }

        this.camera.ResetReplacementShader();
    }

    private bool Validate() {
        if (this.camera == null || this.replacementShader == null) {
            return false;
        }

        return true;
    }
}
