using UnityEngine;

public class EditorSceneRepainter : MonoBehaviour {
    private void OnDrawGizmos() {
#if UNITY_EDITOR
        // Force shaders that rely on _Time will update in edit mode.
        if (!Application.isPlaying) {
            UnityEditor.EditorApplication.QueuePlayerLoopUpdate();
            UnityEditor.SceneView.RepaintAll();
        }
#endif
    }
    
}
