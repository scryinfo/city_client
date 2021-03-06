﻿//Monitor input tools


using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public interface IInputTools
{
    bool GetIsDragging { get; }
    bool GetIsPoint { get; }
    bool GetIsZoom { get; }
    bool AnyPress { get; }

    Vector2 GetMoveV2 { get; }
    float GetZoomValue { get; }
    Vector3 GetZoomFocusPoint { get; }

    void Update();

}

public class WindowsInput : IInputTools
{
    private Vector2 m_moveV2 = Vector2.zero;  //mobile
    private float m_zoomValue = 0.0f;  //Zoom
    private Vector3 m_oldMousePos;  //Mouse recorded position
    private Vector3 m_startMousePos;  //Mouse recorded position

    #region 属性

    public bool GetIsDragging
    {
        get
        {
            return Input.GetMouseButton(0);
        }
    }

    public bool GetIsPoint
    {
        get
        {
            return Input.GetMouseButtonUp(0) && m_startMousePos == Input.mousePosition; 
        }
    }


    public bool GetIsZoom
    {
        get
        {
            return m_zoomValue != 0;
        }
    }

    public bool AnyPress
    {
        get
        {
            return Input.GetMouseButton(0) || Input.GetMouseButton(1) || Input.GetMouseButton(2);
        }
    }

    #endregion

    public Vector2 GetMoveV2
    {
        get
        {
            return m_moveV2;
        }
    }

    public float GetZoomValue
    {
        get
        {
            return m_zoomValue;
        }
    }

    public Vector3 GetZoomFocusPoint
    {
        get
        {
            return Input.mousePosition;
        }
    }

    public void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            m_startMousePos = Input.mousePosition;
        }
        m_moveV2 = Input.mousePosition - m_oldMousePos;
        m_oldMousePos = Input.mousePosition;
        m_zoomValue = Input.GetAxis("Mouse ScrollWheel");
    }
}

public class MobileInput : IInputTools
{
    private bool m_Zoomed = false;
    private float m_zoomValue = 0.0f;  //Zoom
    private Vector3 m_zoomCenter;  //Center point of zoom
    private Vector3 m_oldTouch0Pos;
    private Vector3 m_oldTouch1Pos;  //Two finger zoom to record finger position


    public bool GetIsDragging
    {
        get
        {
            return Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Moved;
        }
    }
    public bool GetIsPoint
    {
        get
        {
            return Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Stationary;
        }
    }


    public bool GetIsZoom
    {
        get
        {
            return Input.touchCount == 2 && (Input.GetTouch(0).phase == TouchPhase.Moved || Input.GetTouch(1).phase == TouchPhase.Moved);
        }
    }

    public bool AnyPress
    {
        get
        {
            return Input.touchCount > 0;
        }
    }


    public Vector2 GetMoveV2
    {
        get
        {
            if (Input.touchCount >= 1)
            {
                return Input.GetTouch(0).deltaPosition;
            }
            else
            {
                return Vector2.zero;

            }
        }
    }

    public float GetZoomValue
    {
        get
        {
            return m_zoomValue;
        }
    }

    public Vector3 GetZoomFocusPoint
    {
        get
        {
            return Input.GetTouch(0).position;
        }
    }

    public void Update()
    {
        if (GetIsZoom)
        {
            Vector3 currentPosition0 = Input.GetTouch(0).position;
            Vector3 currentPosition1 = Input.GetTouch(1).position;
            if (!m_Zoomed)
            {
                //Here is actually starting to zoom
                m_oldTouch0Pos = currentPosition0;
                m_oldTouch1Pos = currentPosition1;
                m_Zoomed = true;
            }
            float newDis = Vector3.Distance(currentPosition0, currentPosition1);
            float oldDis = Vector3.Distance(m_oldTouch0Pos, m_oldTouch1Pos);
            m_zoomValue = (newDis - oldDis) * Time.deltaTime;


            m_oldTouch0Pos = currentPosition0;
            m_oldTouch1Pos = currentPosition1;
            m_zoomCenter = (m_oldTouch0Pos + m_oldTouch1Pos) / 2;

        }
        else
        {
            m_zoomValue = 0;
            m_Zoomed = false;
        }
    }
}
