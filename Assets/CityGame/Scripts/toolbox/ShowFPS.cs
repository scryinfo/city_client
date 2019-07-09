
using UnityEngine;
using System.Collections;

namespace LuaFramework
{
    public class ShowFPS : MonoBehaviour
    {

        public float fpsMeasuringDelta = 2.0f;  //时间间隔
        public string version = "v0.0.5";  //时间间隔
        public int disfontSize = 20;             //字体大小
        public int offset = 0;                  //向右的偏移量

        private float timePassed;
        private int m_FrameCount = 0;
        private float m_FPS = 0.0f;

        private void Start()
        {
            timePassed = 0.0f;
        }

        private void Update()
        {
            m_FrameCount = m_FrameCount + 1;
            timePassed = timePassed + Time.deltaTime;

            if (timePassed > fpsMeasuringDelta)
            {
                m_FPS = m_FrameCount / timePassed;

                timePassed = 0.0f;
                m_FrameCount = 0;
            }
        }

        private void OnGUI()
        {
            GUIStyle bb = new GUIStyle();
            bb.normal.background = null;    //这是设置背景填充的
            bb.normal.textColor = new Color(1.0f, 0.5f, 0.0f);   //设置字体颜色的
            bb.fontSize = disfontSize;       //当然，这是字体大小

            //居中显示FPS
            //GUI.Label(new Rect((Screen.width / 2) - 40, 0, 200, 200), "FPS: " + m_FPS, bb);
            GUI.Label(new Rect(Screen.width - 320 - offset , 0, 400, 200), version + " FPS: " + m_FPS , bb);
        }
    }

}


