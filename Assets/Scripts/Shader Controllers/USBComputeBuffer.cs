using UnityEngine;

public class USBComputeBuffer : MonoBehaviour {

    [SerializeField]
    private ComputeShader shader;

    [Range(0.0f, 0.5f)]
    [SerializeField]
    private float radius = 0.5f;
    
    [Range(0.0f, 1.0f)]
    [SerializeField]
    private float center = 0.5f;

    [Range(0.0f, 0.5f)]
    [SerializeField]
    private float smooth = 0.01f;

    [SerializeField]
    private Color mainColor;
    
    private RenderTexture mainTexture;
    private int textureSize = 128;

    private struct Circle {
        public float radius;
        public float center;
        public float smooth;
    }

    private Circle[] circles;
    private ComputeBuffer buffer;
    private new Renderer renderer;

    private void Awake() {
        renderer = this.GetComponent<Renderer>();
        renderer.enabled = true;
    }

    private void Start() {
        this.CreateShaderTexture();
    }

    private void CreateShaderTexture() {
        mainTexture = new RenderTexture(textureSize, textureSize, 0, RenderTextureFormat.ARGB32);
        mainTexture.enableRandomWrite = true;
        mainTexture.Create();
    }

    private void SetShaderTexture() {
        shader.GetKernelThreadGroupSizes(0, out uint threadGroupSizeX, out _, out _);
        int size = (int) threadGroupSizeX;
        
        circles = new Circle[size];

        for (int i = 0; i < size; i++) {
            Circle circle = circles[i];
            circle.radius = this.radius;
            circle.center = this.center;
            circle.smooth = this.smooth;
            circles[i] = circle;
        }

        int stride = 12;
        buffer = new ComputeBuffer(size, stride, ComputeBufferType.Default);
        buffer.SetData(circles);
        shader.SetBuffer(0, "CircleBuffer", buffer);
        shader.SetTexture(0, "Result", mainTexture);
        shader.SetVector("MainColor", mainColor);
        
        renderer.material.SetTexture("_MainTex", mainTexture);
        
        shader.Dispatch(0, textureSize, textureSize, 1);
        buffer.Release();
    }
    
    private void Update() {
        this.SetShaderTexture();
    }
}
