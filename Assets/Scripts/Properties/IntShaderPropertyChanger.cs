using UnityEngine;

public class IntShaderPropertyChanger : ShaderPropertyChanger<int> {

    [SerializeField]
    private int minValue = 0;

    [SerializeField]
    private int maxValue = 1;

    [SerializeField]
    private float speed = 1.0f;

    private void Update() {
        float value = Mathf.Abs(Mathf.Sin(Time.time * this.speed)) * (maxValue - minValue) + minValue;
        this.SetProperty(Mathf.RoundToInt(value));
    }
}
