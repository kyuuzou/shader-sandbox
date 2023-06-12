using UnityEngine;

public class ColorShaderPropertyChanger : ShaderPropertyChanger<Color> {

    [SerializeField]
    private float minHue = 0.0f;

    [SerializeField]
    private float maxHue = 1.0f;

    [SerializeField]
    private float saturation = 1.0f;

    [SerializeField]
    private float brightness = 1.0f;

    [SerializeField]
    private float speed = 1.0f;

    protected override void Update() {
        float hue = Mathf.Abs(Mathf.Sin(Time.time * this.speed)) * (maxHue - minHue) + minHue;
        this.SetProperty(Color.HSVToRGB(hue, saturation, brightness));
    }
}
