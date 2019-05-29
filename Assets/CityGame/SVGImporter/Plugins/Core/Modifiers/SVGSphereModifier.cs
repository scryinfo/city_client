// Copyright (C) 2015 Jaroslav Stehlik - All Rights Reserved
// This code can only be used under the standard Unity Asset Store End User License Agreement
// A Copy of the EULA APPENDIX 1 is available at http://unity3d.com/company/legal/as_terms

using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace SVGImporter 
{
    [ExecuteInEditMode]
    [RequireComponent(typeof(ISVGRenderer))]
    [AddComponentMenu("Rendering/SVG Modifiers/Sphere Modifier", 22)]
    public class SVGSphereModifier : SVGModifier {

        public Transform center;
        public float radius;
        public float intensity;

        protected override void PrepareForRendering (SVGLayer[] layers, SVGAsset svgAsset, bool force) 
        {
            if(center == null) return;
            Vector2 position = center.position;
            Vector2 direction, directionNormalized;
            float distance;

            if(layers == null) return;
            int totalLayers = layers.Length;
            if(!useSelection)
            {
                for(int i = 0; i < totalLayers; i++)
                {
                    if(layers[i].shapes == null) continue;
                    int shapesLength = layers[i].shapes.Length;
                    for(int j = 0; j < shapesLength; j++)
                    {
                        int vertexCount = layers[i].shapes[j].vertexCount;
                        for(int k = 0; k < vertexCount; k++)
                        {
                            direction = position - layers[i].shapes[j].vertices[k];
                            distance = Mathf.Sqrt(direction.x * direction.x + direction.y * direction.y);
                            directionNormalized = Vector2.zero;
                            if(distance > 0f)
                            {
                                directionNormalized.x = direction.x / distance;
                                directionNormalized.y = direction.y / distance;
                            }

                            layers[i].shapes[j].vertices[k] += directionNormalized * (1f - Mathf.Clamp01(distance / radius)) * intensity;
                        }
                    }
                }
            } else {
                for(int i = 0; i < totalLayers; i++)
                {
                    if(layers[i].shapes == null) continue;
                    if(!layerSelection.Contains(i)) continue;

                    int shapesLength = layers[i].shapes.Length;
                    for(int j = 0; j < shapesLength; j++)
                    {
                        int vertexCount = layers[i].shapes[j].vertexCount;
                        for(int k = 0; k < vertexCount; k++)
                        {
                            direction = position - layers[i].shapes[j].vertices[k];
                            distance = Mathf.Sqrt(direction.x * direction.x + direction.y * direction.y);
                            directionNormalized = Vector2.zero;
                            if(distance > 0f)
                            {
                                directionNormalized.x = direction.x / distance;
                                directionNormalized.y = direction.y / distance;
                            }
                            
                            layers[i].shapes[j].vertices[k] += directionNormalized * (1f - Mathf.Clamp01(distance / radius)) * intensity;
                        }
                    }
                }
            }
        }
    }
}
