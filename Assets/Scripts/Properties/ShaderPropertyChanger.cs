using UnityEngine;

public class ShaderPropertyChanger<T> : MonoBehaviour {

    private new Renderer renderer;

    private void Awake() {
        this.renderer = this.GetComponent<Renderer>();
    }

    protected void SetProperty(string name, T value) {
        this.renderer.sharedMaterial.SetProperty<T>(name, value);
    }

    private void Update() {
        
    }
}
