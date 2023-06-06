using UnityEngine;

public class MousePositionUpdater : MonoBehaviour {

    private new Camera camera;
    private new Renderer renderer;
    private Material sharedMaterial;
    private new Transform transform;
    
    private void Awake() {
        this.renderer = this.GetComponent<Renderer>();
        this.sharedMaterial = this.renderer.sharedMaterial;
        this.transform = this.GetComponent<Transform>();
    }

    private void Start() {
        this.camera = Camera.main;
    }
    
    private void Update() {
        Vector3 mousePosition = Input.mousePosition;
        mousePosition.z = this.transform.position.z - this.camera.transform.position.z;
        mousePosition = this.camera.ScreenToWorldPoint(mousePosition);
        mousePosition = this.transform.InverseTransformPoint(mousePosition);

        Vector3 localScale = this.transform.localScale; 
        mousePosition.x *= localScale.x;
        mousePosition.y *= localScale.y;
 
        this.sharedMaterial.SetVector("_MousePosition", mousePosition);
    }
}
