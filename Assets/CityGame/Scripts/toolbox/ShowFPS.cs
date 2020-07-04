
using UnityEngine;
using System.Collections;

namespace LuaFramework
{
    public class ShowFPS : MonoBehaviour
    {

        public float fpsMeasuringDelta = 2.0f;  //time interval
        public string version = "v0.0.6";  //time interval
        public int disfontSize = 20;             //font size
        public int offset = 0;                  //Right offset

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
            bb.normal.background = null;    //This is set to fill the background
            bb.normal.textColor = new Color(1.0f, 0.5f, 0.0f);   //Set font color
            bb.fontSize = disfontSize;       //Of course, this is the font size

            //Center FPS
            //GUI.Label(new Rect((Screen.width / 2) - 40, 0, 200, 200), "FPS: " + m_FPS, bb);
            GUI.Label(new Rect(Screen.width - 320 - offset , 0, 400, 200), version + " FPS: " + m_FPS , bb);
        }
    }

}


