using UnityEngine;

public class KeywordShaderPropertyChanger : ShaderPropertyChanger<string> {

    [SerializeField]
    private float speed = 1.0f;

    private int currentIndex;

    private void Start() {
        this.DisableAllKeywords();
        this.Renderer.material.EnableKeyword(this.PropertyNames[this.currentIndex]);
    }

    protected override void Update() {
        // make each value stay on screen about the same time
        float maxValue = this.PropertyNames.Length - 0.01f;

        float value = Mathf.Abs(Mathf.Sin(Time.time * this.speed)) * maxValue;
        int index = Mathf.FloorToInt(value);

        if (index == this.currentIndex) {
            return;
        }

        this.Renderer.material.DisableKeyword(this.PropertyNames[this.currentIndex]);
        this.currentIndex = index;
        this.Renderer.material.EnableKeyword(this.PropertyNames[index]);
    }

    private void DisableAllKeywords() {
        foreach (string keyword in this.PropertyNames) {
            this.Renderer.material.DisableKeyword(keyword);
        }
    }
}
