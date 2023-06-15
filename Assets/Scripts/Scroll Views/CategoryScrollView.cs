using UnityEngine;

public class CategoryScrollView : MonoBehaviour {

    [SerializeField]
    private Transform categoryPrefab;

    [SerializeField]
    private Transform contentRoot;

    [SerializeField]
    private ShaderCollection shadercollection;

    private void Update() {
        if (Input.GetKeyUp(KeyCode.UpArrow)) {
            this.shadercollection.TrySetCategory(-1);
        } else if (Input.GetKeyUp(KeyCode.DownArrow)) {
            this.shadercollection.TrySetCategory(1);
        }
    }
}