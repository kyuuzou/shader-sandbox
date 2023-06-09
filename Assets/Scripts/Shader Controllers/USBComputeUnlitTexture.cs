using System.Collections;
using UnityEngine;

public class USBComputeUnlitTexture : MonoBehaviour {

    [SerializeField]
    private ComputeShader shader;

    [SerializeField]
    private Texture2D colorTextureA;

    [SerializeField]
    private Texture2D colorTextureB;

    [SerializeField]
    private int textureSize = 256;

    [SerializeField]
    private RenderTexture mainTexture;

    [SerializeField]
    private bool demoMode = true;

    private IEnumerator DemoModeCoroutine(){
        do {
            yield return new WaitForSeconds(1.0f);
            this.SetTexture(this.colorTextureB);

            yield return new WaitForSeconds(1.0f);
            this.SetTexture(this.colorTextureA);
        } while (true);
    }

    private void SetTexture(Texture2D colorTexture) {
        shader.SetTexture(0, "ColorTexture", colorTexture);

        // generate the thread group to process the texture
        shader.Dispatch(0, textureSize / 8, textureSize / 8, 1);
    }

    private void Start() {
        mainTexture = new RenderTexture(textureSize, textureSize, 0, RenderTextureFormat.ARGB32);
        mainTexture.enableRandomWrite = true;
        mainTexture.Create();

        Renderer renderer = GetComponent<Renderer>();
        renderer.enabled = true;

        // 0 = index of the kernel, in this case CSMain
        shader.SetTexture(0, "Result", mainTexture);
        renderer.material.SetTexture("_MainTex", mainTexture);

        this.SetTexture(this.colorTextureA);

        if (this.demoMode) {
            this.StartCoroutine(this.DemoModeCoroutine());
        }
    }
}
