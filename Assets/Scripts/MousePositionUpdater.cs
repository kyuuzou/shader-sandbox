using UnityEngine;

public class MousePositionUpdater : MonoBehaviour {

    private Camera cachedCamera;
    private Renderer cachedRenderer;
    private Transform cachedTransform;
    private Material sharedMaterial;
    
    private void Awake() {
        this.cachedRenderer = this.GetComponent<Renderer>();
        this.sharedMaterial = this.cachedRenderer.sharedMaterial;
        this.cachedTransform = this.GetComponent<Transform>();
    }

    private void Start() {
        this.cachedCamera = Camera.main;
    }
    
    private void Update() {
        Vector3 mousePosition = Input.mousePosition;
        Vector3 transformPosition = this.cachedTransform.position;
        
        mousePosition.z = transformPosition.z - this.cachedCamera.transform.position.z;
        mousePosition = this.cachedCamera.ScreenToWorldPoint(mousePosition);
        mousePosition = this.cachedTransform.InverseTransformPoint(mousePosition);

        Vector3 localScale = this.cachedTransform.localScale; 
        mousePosition.x *= localScale.x;
        mousePosition.y *= localScale.y;

        mousePosition.x += transformPosition.x;
        mousePosition.y += transformPosition.y;
 
        this.sharedMaterial.SetVector("_MousePosition", mousePosition);
    }
}
