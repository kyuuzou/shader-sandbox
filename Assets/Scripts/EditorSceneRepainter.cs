using UnityEngine;

public class EditorSceneRepainter : MonoBehaviour {

#if UNITY_EDITOR
    private void OnDrawGizmos() {
        // Force shaders that rely on _Time will update in edit mode.
        if (!Application.isPlaying) {
            UnityEditor.EditorApplication.QueuePlayerLoopUpdate();
            UnityEditor.SceneView.RepaintAll();
        }
    }
#endif
}
