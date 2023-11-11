using UnityEngine;

[RequireComponent(typeof(MeshRenderer))]
public class LineGraphWithGradient : MonoBehaviour
{
    [SerializeField]
    private float speed = 1.0f;

    [Range(2, 32)]
    [SerializeField]
    private int numberOfPoints = 4;
    
    private static readonly int CoordinatesProperty = Shader.PropertyToID("_Coordinates");
    private static readonly int NumberOfPointsProperty = Shader.PropertyToID("_NumberOfPoints");

    private Vector4[] coordinates;
    private Vector2[] initialCoordinates;
    private MeshRenderer meshRenderer;
    private MaterialPropertyBlock propertyBlock;

    private void Awake()
    {
        meshRenderer = GetComponent<MeshRenderer>();
        propertyBlock = new MaterialPropertyBlock();

        InitializeCoordinates();
    }

    private void Update()
    {
        AnimateCoordinates();
        UpdateCoordinates();
    }

    private void AnimateCoordinates()
    {
        for (int i = 0; i < coordinates.Length; i++)
        {
            coordinates[i].y = Mathf.PingPong(initialCoordinates[i].y + Time.time * speed, 1.0f);
        }
    }

    private void InitializeCoordinates()
    {
        coordinates = new Vector4[numberOfPoints];
        initialCoordinates = new Vector2[numberOfPoints];

        float segmentWidth = 1.0f / (numberOfPoints - 1);
        
        for (int i = 0; i < numberOfPoints; i++)
        {
            Vector2 coordinate = new Vector2(segmentWidth * i, Random.Range(0.0f, 1.0f));
            coordinates[i] = initialCoordinates[i] = coordinate;
        }
    }
    
    private void UpdateCoordinates()
    {
        propertyBlock.SetVectorArray(CoordinatesProperty, coordinates);
        propertyBlock.SetInt(NumberOfPointsProperty, coordinates.Length);
        meshRenderer.SetPropertyBlock(propertyBlock);
    }
}
