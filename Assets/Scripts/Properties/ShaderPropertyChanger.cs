using System;
using UnityEngine;

public abstract class ShaderPropertyChanger<T> : MonoBehaviour {

    protected Renderer Renderer { get; private set; }

    [SerializeField]
    private string[] propertyNames;
    protected string[] PropertyNames => this.propertyNames;

    private void Awake() {
        this.Renderer = this.GetComponent<Renderer>();
    }

    protected void SetProperty(T value) {
        foreach (string propertyName in this.propertyNames) {
            this.Renderer.sharedMaterial.SetProperty<T>(propertyName, value);
        }
    }

    protected abstract void Update();
}
