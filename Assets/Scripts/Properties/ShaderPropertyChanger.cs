using System;
using UnityEngine;

public class ShaderPropertyChanger<T> : MonoBehaviour {

    private new Renderer renderer;

    [SerializeField]
    private string[] propertyNames;

    private void Awake() {
        this.renderer = this.GetComponent<Renderer>();
    }

    protected void SetProperty(T value) {
        foreach (string propertyName in this.propertyNames) {
            this.renderer.sharedMaterial.SetProperty<T>(propertyName, value);
        }
    }

    private void Update() {
        
    }
}
