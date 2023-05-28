using UnityEngine;

public class UnlitTextureComputeShaderInitializer : MonoBehaviour {

    [SerializeField]
    private ComputeShader shader;

    [SerializeField]
    private Texture2D colorTexture;
    
    [SerializeField]
    private int textureSize = 256;

    [SerializeField]
    private RenderTexture mainTexture;

    private void Start() {
        mainTexture = new RenderTexture(textureSize, textureSize, 0, RenderTextureFormat.ARGB32);
        mainTexture.enableRandomWrite = true;
        mainTexture.Create();

        Renderer renderer = GetComponent<Renderer>();
        renderer.enabled = true;
        
        // 0 = index of the kernel, in this case CSMain
        shader.SetTexture(0, "Result", mainTexture);
        shader.SetTexture(0, "ColorTexture", colorTexture);
        renderer.material.SetTexture("_MainTex", mainTexture);
        
        // generate the thread group to process the texture
        shader.Dispatch(0, textureSize / 8, textureSize / 8, 1);
    }
}
