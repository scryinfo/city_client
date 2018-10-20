

using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class InputModule : MonoBehaviour
{

    public static InputModule m_Instance;

    public static InputModule Instance
    {
        get
        {
            if (m_Instance == null)
            {
                m_Instance = new GameObject("[InputModule]").AddComponent<InputModule>();
            }
            return m_Instance;
        }
    }

    public IInputTools inputTools;

    public void Awake()
    {
#if UNITY_EDITOR
        inputTools = new WindowsInput();
#else
        inputTools = new MobileInput();
#endif
    }


    public bool Dragging
    {
        get
        {
            return inputTools.GetIsDragging;
        }
    }


    public bool AnyPress
    {
        get
        {
            return inputTools.AnyPress;
        }
    }

    public bool Zooming
    {
        get
        {
            return inputTools.GetIsZoom;
        }
    }

    public Vector2 DragDeltaPosition
    {
        get
        {
            return inputTools.GetMoveV2;
        }
    }

    public float ZoomDeltaValue
    {
        get
        {
            return inputTools.GetZoomValue;
        }
    }

    public Vector3 ZoomCenter
    {
        get
        {
            return inputTools.GetZoomFocusPoint;
        }
    }

    private void Update()
    {
        inputTools.Update();
    }
}

