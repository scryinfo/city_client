

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using LuaInterface;
using LuaFramework;
using UnityEngine.EventSystems;

public class CameraScripts : MonoBehaviour
{
    //要注意的是,这里的最大最小距离实际上并非摄像机父物体的Y值,而是相机本身的forward深度
    public float minDistance = -5.0f;  //相机放大，与目标最小的距离
    public float maxDistance = 30.0f;  //相机缩小，与目标最大的距离

    public float m_smoothStopMaxSpeed = 30;  //缓冲时的最大速度
    public float m_sutoScrollDamp = 100;  //数值越大，阻碍力越大
    public float dragFactor = 1f;  //拖拽速度
    public float scaleFactor = 100;  //缩放速度

    public Vector2 dragRange = new Vector2(0.1f, 1f); // 从最低距离到最高距离的距离缩放因子

    public Vector2 m_camMoveLimiteLRV = new Vector2(0, 500);
    public Vector2 m_camMoveLimiteUDV = new Vector2(0, 500);  //相机的移动范围

    public Vector2 m_camMoveLimiteY = new Vector2(5, 15);  //相机Y的最高最低位置
    private Camera m_mainCamera;
    private Vector3 finalPosition = Vector3.zero; //相机的最终位置(忽略相机缩放的位置叠加的).
    private float finalDistance = 0; //摄像机最终的距离
    private Vector3 cameraZoomVector = Vector3.zero; //相机的forward叠加
    private Vector3 m_smoothStopVelocity;  //相机缓冲移动的速度 --- 只需要获取一次
    private float m_timeRealDragStop;  //记录滑动结束之后的时间
    private Vector2 lastMoveVector; //记录鼠标最后移动的幅度,简单版本,复杂点可以做成多帧取样
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
        
        if (Input.GetKeyDown(KeyCode.A))
        {
            TestMoveCam();
        }
    }


    /// <summary>
    /// 测试测试测试
    /// </summary>
    private bool m_canHandleCam = true;  //玩家是否可以移动相机
    private Vector3 m_moveTargetPos;  //目标移动位置
    private void TestMoveCam()
    {
        m_canHandleCam = false;
    }

    private float m_moveTotalTime = 3.0f;  //移动的总时间
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

    //更新相机位置
    private void UpdateMove()
    {
        if (EventSystem.current.IsPointerOverGameObject())
        {
            return;
        }

        float factor = Mathf.Lerp(dragRange.x, dragRange.y, (finalDistance - minDistance) / (maxDistance - minDistance));  //根据相机的距离设置不同的因子,使拖动更自然

        m_smoothStopVelocity = Vector3.zero;
        var dragDeltaPosition = InputModule.Instance.DragDeltaPosition;
        Vector3 v3 = new Vector3(dragDeltaPosition.x, 0, dragDeltaPosition.y);
        Vector3 newDeltaPositionV3 = (Quaternion.AngleAxis(m_mainCamera.transform.localEulerAngles.y, new Vector3(0, 1, 0)) * v3) * dragFactor * factor;
        finalPosition -= newDeltaPositionV3 * Time.deltaTime;

        //惯性处理相关
        lastMoveVector = new Vector2(newDeltaPositionV3.x, newDeltaPositionV3.z);
        //限制最大速度,防止出现极大的惯性
        if (lastMoveVector.sqrMagnitude > m_smoothStopMaxSpeed * m_smoothStopMaxSpeed)
        {
            lastMoveVector = lastMoveVector.normalized * m_smoothStopMaxSpeed;
        }
        m_smoothStopVelocity = lastMoveVector;
        m_timeRealDragStop = Time.realtimeSinceStartup;
        Util.CallMethod("TerrainManager", "Refresh", transform.Find("CameraCenter").position);
    }


    //滑动结束，开始相机缓冲停止移动
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


    //////    //相机缩放中心点的偏移,直接应用到finalPosition中
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

    ////////限制相机在2维的位置
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

        //相机缩放中心点的偏移,直接应用到finalPosition中
        Ray ray = m_mainCamera.ScreenPointToRay(InputModule.Instance.ZoomCenter);
        Vector3 hV3 = ray.direction - m_mainCamera.transform.forward;

        Vector3 tempZoomVector = (m_mainCamera.transform.forward) * -finalDistance;
        Vector3 tempV3 = finalPosition + hV3 * (tempDistance - finalDistance) + tempZoomVector;
        if (tempV3.y > m_camMoveLimiteY.y || tempV3.y < m_camMoveLimiteY.x)  //限制因为缩放引起的y的变化
        {
            ////Debug.Log("aaaaaaaaaaaaaaaaaaa");
            return;
        }

        cameraZoomVector = (m_mainCamera.transform.forward) * -finalDistance;
        finalPosition += hV3 * (tempDistance - finalDistance);
    }

    private void LateUpdate()
    {
        if (!m_canHandleCam)
        {
            m_moveTargetPos = Vector3.zero;
            TestMoveTarget(m_moveTargetPos);
            return;
        }
        
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

    //限制相机在2维的位置
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
