using UnityEngine;

public class IntShaderPropertyChanger : ShaderPropertyChanger<int> {

    [SerializeField]
    private int minValue = 0;

    [SerializeField]
    private int maxValue = 1;

    [SerializeField]
    private float speed = 1.0f;

    protected override void Update() {
        // make each value stay on screen about the same time
        float maxValue = this.maxValue + 0.99f;
        
        float value = Mathf.Abs(Mathf.Sin(Time.time * this.speed)) * (maxValue - minValue) + minValue;
        this.SetProperty(Mathf.FloorToInt(value));
    }
}
