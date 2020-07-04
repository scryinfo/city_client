

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
using LuaFramework;
using UnityEngine.EventSystems;

public class CameraScripts : MonoBehaviour
{
    //It should be noted that the maximum and minimum distances here are not actually the Y value of the parent object of the camera, but the forward depth of the camera itself
    public float minDistance = -5.0f;  //Camera zoom in, minimum distance to target
    public float maxDistance = 30.0f;  //Camera zooms out, maximum distance to target

    public float m_smoothStopMaxSpeed = 30;  //Maximum speed when buffering
    public float m_sutoScrollDamp = 100;  //The larger the value, the greater the resistance
    public float dragFactor = 1f;  //Drag speed
    public float scaleFactor = 100;  //Zoom speed

    public Vector2 dragRange = new Vector2(0.1f, 1f); // Distance scaling factor from lowest distance to highest distance

    public Vector2 m_camMoveLimiteLRV = new Vector2(0, 500);
    public Vector2 m_camMoveLimiteUDV = new Vector2(0, 500);  //Camera movement range

    public Vector2 m_camMoveLimiteY = new Vector2(5, 15);  //The highest and lowest position of camera Y
    private Camera m_mainCamera;
    private Vector3 finalPosition = Vector3.zero; //The final position of the camera (ignoring the superimposed position of the camera zoom).
    private float finalDistance = 0; //The final distance of the camera
    private Vector3 cameraZoomVector = Vector3.zero; //Camera's forward overlay
    private Vector3 m_smoothStopVelocity;  //The speed of the camera buffer movement --- only need to get once
    private float m_timeRealDragStop;  //Record the time after the end of the slide
    private Vector2 lastMoveVector; //Record the amplitude of the last mouse movement, simple version, complex points can be made into multi-frame sampling
    private Vector2 screenCenter;

    private void Start()
    {
        m_mainCamera = Camera.main;
        finalPosition = transform.localPosition;
        m_smoothStopVelocity = Vector3.zero;
        screenCenter = new Vector2(Screen.width / 2, Screen.height / 2);
    }

    private void Update()
    {
        //Detect click UI and ray conflict - temporary
        if (IsClickDownOverUI())
        {
            m_canHandleCam = false;
            return;
        }
        if (IsUpInUI())
        {
            m_canHandleCam = true;
            return;
        }
        if(IsUpNotInUI())
        {
            m_canHandleCam = true;
        }
        //
        if (!m_canHandleCam)
        {
            return;
        }
        
        if (InputModule.Instance.Zooming)
        {
            ScaleCamera();
        }
        else if (InputModule.Instance.Dragging)
        {
            UpdateMove();
        }
        else if (InputModule.Instance.Stationary)
        {
            Debug.Log("点击");
            Util.CallMethod("TerrainManager", "TouchBuild", InputModule.Instance.ZoomCenter);
        }
        else if (!InputModule.Instance.AnyPress)
        {
            SmoothStopFunc();
        }
    }

    bool IsClickDownOverUI()
    {
#if UNITY_EDITOR
        if (Input.GetMouseButtonDown(0))
#else
    if (Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Began)
#endif
        {
#if UNITY_EDITOR
            if (EventSystem.current.IsPointerOverGameObject())
#else
        if (EventSystem.current.IsPointerOverGameObject(Input.GetTouch(0).fingerId))
#endif
            {
                return true;
            }
        }
        return false;
    }

    bool IsUpInUI()
    { 
    #if UNITY_EDITOR
        if (Input.GetMouseButtonDown(0))
#else
    if (Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Began)
#endif
        {
#if UNITY_EDITOR
            if (EventSystem.current.IsPointerOverGameObject())
#else
            if (EventSystem.current.IsPointerOverGameObject(Input.GetTouch(0).fingerId))
#endif
            {
                return true;
            }
        }
        return false;
    }


    bool IsUpNotInUI()
    {
#if UNITY_EDITOR
        if (Input.GetMouseButtonDown(0))
#else
    if (Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Began)
#endif
        {
#if UNITY_EDITOR
            if (!EventSystem.current.IsPointerOverGameObject())
#else
            if (!EventSystem.current.IsPointerOverGameObject(Input.GetTouch(0).fingerId))
#endif
            {
                return true;
            }
        }
        return false;
    }



    bool CheckGuiRaycastObjects()
    {
#if UNITY_EDITOR
        if (Input.GetMouseButtonUp(0))
#else
    if (Input.touchCount == 1 && Input.GetTouch(0).phase == TouchPhase.Ended)
#endif
        {
#if UNITY_EDITOR
            if (EventSystem.current.IsPointerOverGameObject())
#else
        if (EventSystem.current.IsPointerOverGameObject(Input.GetTouch(0).fingerId))
#endif
            {
                return true;
            }
        }

        return false;
    }


    /// <summary>
    /// Test test test
    /// </summary>
    private bool m_canHandleCam = true;  //Can the player move the camera
    private Vector3 m_moveTargetPos;  //Target moving position
    private void TestMoveCam()
    {
        m_canHandleCam = false;
    }

    private float m_moveTotalTime = 3.0f;  //Total time moved
    private float tempT = 0.0f;
    private void TestMoveTarget(Vector3 targetPos)
    {
        if (tempT < m_moveTotalTime)
        {
            tempT += Time.unscaledDeltaTime;
        }
        else
        {
            transform.localPosition = new Vector3(targetPos.x, transform.localPosition.y, targetPos.z);
            tempT = 0.0f;
            m_canHandleCam = true;
            finalPosition = transform.localPosition;
            return;
        }

        Vector3 moveV3 = new Vector3(transform.localPosition.x, targetPos.y, transform.localPosition.z);
        float t = tempT / m_moveTotalTime;
        Vector3 tempV3 = Vector3.Lerp(moveV3, targetPos, t * t * t);
        transform.localPosition = new Vector3(tempV3.x, transform.localPosition.y, tempV3.z);
        finalPosition = transform.localPosition;
    }

    //Update camera position
    private void UpdateMove()
    {
        if (EventSystem.current.IsPointerOverGameObject())
        {
            return;
        }

        ////float factor = Mathf.Lerp(dragRange.x, dragRange.y, (finalDistance - minDistance) / (maxDistance - minDistance));  //Set different factors according to the distance of the camera to make dragging more natural

        ////m_smoothStopVelocity = Vector3.zero;
        ////var dragDeltaPosition = InputModule.Instance.DragDeltaPosition;
        ////Vector3 v3 = new Vector3(dragDeltaPosition.x, 0, dragDeltaPosition.y);
        ////Vector3 newDeltaPositionV3 = (Quaternion.AngleAxis(m_mainCamera.transform.localEulerAngles.y, new Vector3(0, 1, 0)) * v3) * dragFactor * factor;
        ////finalPosition -= newDeltaPositionV3 * Time.deltaTime;

        //////Inertia related
        ////lastMoveVector = new Vector2(newDeltaPositionV3.x, newDeltaPositionV3.z);
        //////Limit maximum speed to prevent extreme inertia
        ////if (lastMoveVector.sqrMagnitude > m_smoothStopMaxSpeed * m_smoothStopMaxSpeed)
        ////{
        ////    lastMoveVector = lastMoveVector.normalized * m_smoothStopMaxSpeed;
        ////}
        ////m_smoothStopVelocity = lastMoveVector;
        ////m_timeRealDragStop = Time.realtimeSinceStartup;

        float factor = Mathf.Lerp(dragRange.x, dragRange.y, (finalDistance - minDistance) / (maxDistance - minDistance));  //Set different factors according to the distance of the camera to make dragging more natural

        m_smoothStopVelocity = Vector3.zero;
        var dragDeltaPosition = InputModule.Instance.DragDeltaPosition;
        Vector3 v3 = new Vector3(dragDeltaPosition.x, 0, dragDeltaPosition.y);
        Vector3 newDeltaPositionV3 = (Quaternion.AngleAxis(m_mainCamera.transform.localEulerAngles.y, new Vector3(0, 1, 0)) * v3) * dragFactor * factor;
        finalPosition -= newDeltaPositionV3 * Time.deltaTime;

        //Inertia related
        lastMoveVector = new Vector2(newDeltaPositionV3.x, newDeltaPositionV3.z);
        //Limit maximum speed to prevent extreme inertia
        if (lastMoveVector.sqrMagnitude > m_smoothStopMaxSpeed * m_smoothStopMaxSpeed)
        {
            lastMoveVector = lastMoveVector.normalized * m_smoothStopMaxSpeed;
        }
        m_smoothStopVelocity = lastMoveVector;
        m_timeRealDragStop = Time.realtimeSinceStartup;

        Util.CallMethod("TerrainManager", "Refresh", transform.Find("CameraCenter").position);
    }


    //End of sliding, start camera buffer and stop moving
    private void SmoothStopFunc()
    {
        if (m_smoothStopVelocity != Vector3.zero)
        {
            float timeSinceDragStop = Time.realtimeSinceStartup - m_timeRealDragStop;
            float dampFactor = Mathf.Clamp01(timeSinceDragStop);

            Vector3 camVelDamp = dampFactor * m_smoothStopVelocity.normalized * m_sutoScrollDamp * Time.deltaTime;
            if (camVelDamp.sqrMagnitude >= m_smoothStopVelocity.sqrMagnitude)
            {
                m_smoothStopVelocity = Vector3.zero;
            }
            else
            {
                m_smoothStopVelocity -= camVelDamp;
            }

            finalPosition += new Vector3(-m_smoothStopVelocity.x, 0, -m_smoothStopVelocity.y) * Time.deltaTime;
        }
    }

    #region old
    //////private void ScaleCamera()
    //////{
    //////    float tempDistance = finalDistance;
    //////    float deltaValue = (InputModule.Instance.ZoomDeltaValue) * scaleFactor * Time.deltaTime;
    //////    finalDistance -= deltaValue;
    //////    finalDistance = Mathf.Clamp(finalDistance, minDistance, maxDistance);
    //////    cameraZoomVector = (m_mainCamera.transform.forward) * -finalDistance;


    //////    //The offset of the camera zoom center point is directly applied to finalPosition
    //////    ////Ray ray = m_mainCamera.ScreenPointToRay(InputModule.Instance.ZoomCenter);
    //////    ////Vector3 hV3 = ray.direction - m_mainCamera.transform.forward;
    //////    ////finalPosition += hV3 * (tempDistance - finalDistance);
    //////}

    //////private void LateUpdate()
    //////{
    //////    SmoothStopFunc();
    //////    finalPosition = ClampPosition(finalPosition);
    //////    transform.localPosition = finalPosition + cameraZoomVector;
    //////    //TestShowLog();
    //////}

    ////////Limit camera position in 2 dimensions
    //////private Vector3 ClampPosition(Vector3 newPos)
    //////{
    //////    newPos.x = Mathf.Clamp(newPos.x, m_camMoveLimiteLRV.x, m_camMoveLimiteLRV.y);
    //////    newPos.z = Mathf.Clamp(newPos.z, m_camMoveLimiteUDV.x, m_camMoveLimiteUDV.y);
    //////    return newPos;
    //////}

    #endregion

    private void ScaleCamera()
    {
        float tempDistance = finalDistance;

        float deltaValue = (InputModule.Instance.ZoomDeltaValue) * scaleFactor * Time.deltaTime;
        finalDistance -= deltaValue;
        finalDistance = Mathf.Clamp(finalDistance, minDistance, maxDistance);

        //The offset of the camera zoom center point is directly applied to finalPosition
        Ray ray = m_mainCamera.ScreenPointToRay(InputModule.Instance.ZoomCenter);
        Vector3 hV3 = ray.direction - m_mainCamera.transform.forward;

        Vector3 tempZoomVector = (m_mainCamera.transform.forward) * -finalDistance;
        Vector3 tempV3 = finalPosition + hV3 * (tempDistance - finalDistance) + tempZoomVector;
        if (tempV3.y > m_camMoveLimiteY.y || tempV3.y < m_camMoveLimiteY.x)  //Limit changes in y due to scaling
        {
            ////Debug.Log("aaaaaaaaaaaaaaaaaaa");
            return;
        }

        cameraZoomVector = (m_mainCamera.transform.forward) * -finalDistance;
        finalPosition += hV3 * (tempDistance - finalDistance);
    }

    private void LateUpdate()
    {
        /*
        if (!m_canHandleCam)
        {
            m_moveTargetPos = Vector3.zero;
            TestMoveTarget(m_moveTargetPos);
            return;
        }
        */
        
        SmoothStopFunc();
        ////finalPosition = ClampPosition(finalPosition);
        ////Debug.Log("----finalpos：" + finalPosition);
        ////transform.localPosition = finalPosition + cameraZoomVector;
        ////Debug.Log("---- cam pos：" + transform.localPosition);


        finalPosition = ClampPosition(finalPosition);
        //Debug.Log("----finalpos：" + finalPosition);
        Vector3 tempV3 = finalPosition + cameraZoomVector;
        tempV3 = ClampPosition(tempV3);
        transform.localPosition = tempV3;
        //Debug.Log("---- cam pos：" + transform.localPosition);
        Util.CallMethod("TerrainManager", "MoveTempConstructObj");
        Util.CallMethod("UIBubbleCtrl", "static.RefreshLateUpdate");
    }

    //Limit camera position in 2 dimensions
    private Vector3 ClampPosition(Vector3 newPos)
    {
        newPos.x = Mathf.Clamp(newPos.x, m_camMoveLimiteLRV.x, m_camMoveLimiteLRV.y);
        newPos.z = Mathf.Clamp(newPos.z, m_camMoveLimiteUDV.x, m_camMoveLimiteUDV.y);
        newPos.y = Mathf.Clamp(newPos.y, m_camMoveLimiteY.x, m_camMoveLimiteY.y);
        return newPos;
    }

    public UnityEngine.UI.Text m_showfinalDisText = null;
    public UnityEngine.UI.Text m_showfinalPosYText = null;
    private void TestShowLog()
    {
        m_showfinalDisText.text = finalDistance.ToString();
        m_showfinalPosYText.text = transform.localPosition.y.ToString();
    }
}
