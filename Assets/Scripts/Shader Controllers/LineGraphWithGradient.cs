using System;
using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshRenderer))]
public class LineGraphWithGradient : MonoBehaviour
{
    [Header("Maximum number of supported coordinates: 32")]
    [SerializeField]
    private Vector4[] coordinates;

    private static readonly string coordinatesProperty = "_Coordinates";
    private static readonly string numberOfPointsProperty = "_NumberOfPoints";
    
    private void Start()
    {
        UpdateCoordinates();
    }

    private void OnValidate()
    {
        UpdateCoordinates();
    }

    private void UpdateCoordinates()
    {
        MaterialPropertyBlock materialBlock = new MaterialPropertyBlock();
        materialBlock.SetVectorArray(coordinatesProperty, coordinates);
        materialBlock.SetInt(numberOfPointsProperty, coordinates.Length);
        GetComponent<MeshRenderer>().SetPropertyBlock(materialBlock);
    }
}
