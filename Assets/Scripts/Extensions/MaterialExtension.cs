using System;
using System.Collections.Generic;
using UnityEngine;

public static class MaterialExtension {

    private static Dictionary<Type, Action<Material, string, object>> propertySetters;

    static MaterialExtension() {
        propertySetters = new Dictionary<Type, Action<Material, string, object>> {
            { typeof(ComputeBuffer), (material, name, value) => material.SetBuffer(name, (ComputeBuffer)value) },
            { typeof(Color), (material, name, value) => material.SetColor(name, (Color)value) },
            { typeof(List<Color>), (material, name, value) => material.SetColorArray(name, (List<Color>)value) },
            { typeof(float), (material, name, value) => material.SetFloat(name, (float)value) },
            { typeof(List<float>), (material, name, value) => material.SetFloatArray(name, (List<float>)value) },
            { typeof(int), (material, name, value) => material.SetInt(name, (int)value) },
            { typeof(Matrix4x4), (material, name, value) => material.SetMatrix(name, (Matrix4x4)value) },
            { typeof(List<Matrix4x4>), (material, name, value) => material.SetMatrixArray(name, (List<Matrix4x4>)value) },
            { typeof(Texture), (material, name, value) => material.SetTexture(name, (Texture)value) },
            { typeof(Vector4), (material, name, value) => material.SetVector(name, (Vector4)value) },
            { typeof(List<Vector4>), (material, name, value) => material.SetVectorArray(name, (List<Vector4>)value) },
        };
    }

    public static void SetProperty<T>(this Material material, string name, T value) {
        if (! propertySetters.ContainsKey(typeof(T))) {
            Debug.LogError($"Unsupported property type: {typeof(T)}");
            return;
        }

        propertySetters[typeof(T)](material, name, value);
    }
}
