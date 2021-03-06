﻿using Battle;
using UnityEngine;

/// <summary>
/// Description: small map
/// </summary>

public class MiniMapFOWRender
{
    private MeshRenderer m_renderer = null;
    private RenderTexture m_renderTexture = null;

    public MiniMapFOWRender(Transform mapParent, Camera fowCamera)
    {
        FOWRender render = FOWLogic.instance.CreateRender(mapParent);
        if (render != null)
        {
            //m_transform = render.transform.parent;
            render.transform.localPosition = Vector3.zero;
            render.transform.localEulerAngles = new Vector3(0f, 180f, 0f);
            render.transform.localScale = Vector3.one;
            render.gameObject.layer = mapParent.gameObject.layer;
            m_renderer = render.GetComponent<MeshRenderer>();
        }
       // m_renderTexture = RenderTexture.GetTemporary(fowRenderTex.width, fowRenderTex.height);
        fowCamera.transform.parent = null;
        fowCamera.transform.localScale = Vector3.one;
        fowCamera.transform.localPosition = new Vector3(-10000, 0, 0);
        fowCamera.targetTexture = m_renderTexture;

       // m_fowRenderTex = fowRenderTex;
      //  m_fowRenderTex.mainTexture = m_renderTexture;
    }
    
   
    public void OnDestroy()
    {
        m_renderer = null;
        if (m_renderTexture != null)
        {
            RenderTexture.ReleaseTemporary(m_renderTexture);
            m_renderTexture = null;
        }
    }

    public void SetSortingLayerName(string soringName)
    {
        if (m_renderer != null)
        {
            m_renderer.sortingLayerName = soringName;
        }
    }
}
