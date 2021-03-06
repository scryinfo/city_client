﻿/*
 * @Author: chiuan wei 
 * @Date: 2017-05-27 18:14:53 
 * @Last Modified by: chiuan wei
 * @Last Modified time: 2017-05-27 18:33:48
 */
namespace City
{
    using System.Collections;
    using UnityEngine.EventSystems;
    using UnityEngine.UI;
    using UnityEngine;

    /// <summary>
    /// Init The UI Root
    /// 
    /// UIRoot
    /// -Canvas
    /// --FixedRoot
    /// --NormalRoot
    /// --PopupRoot
    /// -Camera
    /// </summary>
    public class UIRoot : MonoBehaviour
    {
        private static UIRoot m_Instance = null;
        public static UIRoot Instance
        {
            get
            {
                if (m_Instance == null)
                {
                    InitRoot();
                }
                return m_Instance;
            }
        }

        public Transform root;
        public Transform fixedRoot;
        public Transform bubbleRoot;
        public Transform normalRoot;
        public Transform popupRoot;
        public Camera uiCamera;
        private static int CanvasOrderLayer = 0;

        static void InitRoot()
        {
            CanvasOrderLayer = 0;
            GameObject go = new GameObject("UIRoot");
            go.layer = LayerMask.NameToLayer("UI");
            m_Instance = go.AddComponent<UIRoot>();
            go.AddComponent<RectTransform>();
           
            //Canvas can = go.AddComponent<Canvas>();
            //can.renderMode = RenderMode.ScreenSpaceCamera;
            //can.pixelPerfect = true;
            //go.AddComponent<GraphicRaycaster>();
           
            m_Instance.root = go.transform;

            GameObject camObj = new GameObject("UICamera");
            camObj.layer = LayerMask.NameToLayer("UI");
            camObj.transform.parent = go.transform;
            camObj.transform.localPosition = new Vector3(0, 0, 0);
            Camera cam = camObj.AddComponent<Camera>();
            cam.clearFlags = CameraClearFlags.Depth;
            cam.orthographic = true;
            cam.farClipPlane = 200f;
            //can.worldCamera = cam;
            cam.cullingMask = 1 << 5;
            cam.nearClipPlane = -50f;
            cam.farClipPlane = 50f;

            m_Instance.uiCamera = cam;

            //add audio listener
            camObj.AddComponent<AudioListener>();
            camObj.AddComponent<GUILayer>();

           
            //CanvasScaler cs = go.AddComponent<CanvasScaler>();
            //cs.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            //cs.referenceResolution = new Vector2(1920f, 1080f);
            //cs.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand;
     
            ////add auto scale camera fix size.
            //TTCameraScaler tcs = go.AddComponent<TTCameraScaler>();
            //tcs.scaler = cs;

            //set the raycaster
            //GraphicRaycaster gr = go.AddComponent<GraphicRaycaster>();

            GameObject subRoot;
            subRoot = CreateSubCanvasForRoot(go.transform, 0);
            subRoot.name = "BubbleRoot";
            m_Instance.bubbleRoot = subRoot.transform;
            m_Instance.bubbleRoot.transform.localScale = Vector3.one;
            //Add Bubble Canvas
            CreateCanvans(subRoot, cam);

            subRoot = CreateSubCanvasForRoot(go.transform, 0);
            subRoot.name = "NormalRoot";
            m_Instance.normalRoot = subRoot.transform;
            m_Instance.normalRoot.transform.localScale = Vector3.one;
            //Add NormalRoot canvas
            CreateCanvans(subRoot, cam);

            subRoot = CreateSubCanvasForRoot(go.transform, 0);
            subRoot.name = "PopupRoot";
            m_Instance.popupRoot = subRoot.transform;
            m_Instance.popupRoot.transform.localScale = Vector3.one;
            //Add PopupRoot canvas
            CreateCanvans(subRoot, cam);

            subRoot = CreateSubCanvasForRoot(go.transform, 0);
            subRoot.name = "FixedRoot";
            m_Instance.fixedRoot = subRoot.transform;
            m_Instance.fixedRoot.transform.localScale = Vector3.one;
            //Add FixedRoot canvas
            CreateCanvans(subRoot, cam);

            //add Event System
            GameObject esObj = GameObject.Find("EventSystem");
            if (esObj != null)
            {
                GameObject.DestroyImmediate(esObj);
            }

            GameObject eventObj = new GameObject("EventSystem");
            eventObj.layer = LayerMask.NameToLayer("UI");
            eventObj.transform.SetParent(go.transform);
            eventObj.AddComponent<EventSystem>();
            eventObj.AddComponent<UnityEngine.EventSystems.StandaloneInputModule>();

        }

        static GameObject CreateSubCanvasForRoot(Transform root, int sort)
        {
            GameObject go = new GameObject("canvas");
            go.transform.parent = root;
            go.layer = LayerMask.NameToLayer("UI");

            RectTransform rect = go.AddComponent<RectTransform>();
            rect.SetInsetAndSizeFromParentEdge(RectTransform.Edge.Left, 0, 0);
            rect.SetInsetAndSizeFromParentEdge(RectTransform.Edge.Top, 0, 0);
            rect.anchorMin = Vector2.zero;
            rect.anchorMax = Vector2.one;

            //  Canvas can = go.AddComponent<Canvas>();
            //  can.overrideSorting = true;
            //  can.sortingOrder = sort;
            //  go.AddComponent<GraphicRaycaster>();

            return go;
        }

        static void CreateCanvans(GameObject subRoot, Camera cam)
        {
            Canvas can_subRoot;
            CanvasScaler cs_subRoot;
            //subRoot.AddComponent<RectTransform>();
            subRoot.layer = LayerMask.NameToLayer("UI");
            can_subRoot = subRoot.AddComponent<Canvas>();
            can_subRoot.renderMode = RenderMode.ScreenSpaceCamera;
            can_subRoot.sortingOrder = CanvasOrderLayer++;
            can_subRoot.planeDistance = 0;
            can_subRoot.pixelPerfect = true;
            can_subRoot.worldCamera = cam;
            subRoot.AddComponent<GraphicRaycaster>();
            cs_subRoot = subRoot.AddComponent<CanvasScaler>();
            cs_subRoot.uiScaleMode = CanvasScaler.ScaleMode.ScaleWithScreenSize;
            cs_subRoot.referenceResolution = new Vector2(1920f, 1080f);
            cs_subRoot.screenMatchMode = CanvasScaler.ScreenMatchMode.Expand;

        }


        static Transform getRoot()
        {
            return m_Instance.root;
        }

        public static Camera getUiCamera()
        {
            return m_Instance.uiCamera;
        }
        public static Transform getNormalRoot()
        {
            return m_Instance.normalRoot;
        }

        public static Transform getBubbleRoot()
        {
            return m_Instance.bubbleRoot;
        }

        public static Transform getFixedRoot()
        {
            return m_Instance.fixedRoot;
        }

        public static Transform getPopupRoot()
        {
            return m_Instance.popupRoot;
        }
        void OnDestroy()
        {
            m_Instance = null;
        }
    }
}
 