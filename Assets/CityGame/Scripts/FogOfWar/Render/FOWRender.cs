using UnityEngine;

/// <summary>
/// Description: FOW rendering layer rendering script
/// </summary>

public class FOWRender : MonoBehaviour
{
    
    public Color unexploredColor = new Color(0f, 0f, 0f, 250f / 255f);
    public Color exploredColor = new Color(0f, 0f, 0f, 200f / 255f);
    Material mMat;
    Texture2D oldTexture;

    void Start()
    {
        if (mMat == null)
        {
            MeshRenderer render = GetComponentInChildren<MeshRenderer>();
            if (render != null)
            {
                mMat = render.sharedMaterial;
            }
        }

        if (mMat == null)
        {
            enabled = false;
            return;
        }
    }

    public void Activate(bool active)
    {
        gameObject.SetActive(active);
    }

    public bool IsActive
    {
        get
        {
            return gameObject.activeSelf;
        }
    }

    void OnWillRenderObject()
    {
        if (mMat != null && FOWSystem.instance.texture != null)
        {
            mMat.SetTexture("_MainTex", FOWSystem.instance.texture);
            mMat.SetFloat("_BlendFactor", FOWSystem.instance.blendFactor);
            if (FOWSystem.instance.enableFog)
            {
                mMat.SetColor("_Unexplored", unexploredColor);
            }
            else
            {
                mMat.SetColor("_Unexplored", exploredColor);
            }
            mMat.SetColor("_Explored", exploredColor);
            /*
            if(null != oldTexture && FOWSystem.instance.texture == oldTexture)
            {
                FOWSystem.instance.enableSystem = false;
            }
            oldTexture = FOWSystem.instance.texture;
            */
        }
    }
}
