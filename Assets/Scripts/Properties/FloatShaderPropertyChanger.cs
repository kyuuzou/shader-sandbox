using UnityEngine;

public class FloatShaderPropertyChanger : ShaderPropertyChanger<float> {

    [SerializeField]
    private string propertyName;

    [SerializeField]
    private float minValue = 0.0f;

    [SerializeField]
    private float maxValue = 1.0f;

    [SerializeField]
    private float speed = 1.0f;

    private void Update() {
        float value = Mathf.Abs(Mathf.Sin(Time.time * this.speed)) * (maxValue - minValue) + minValue;
        this.SetProperty(this.propertyName, value);
    }
}
