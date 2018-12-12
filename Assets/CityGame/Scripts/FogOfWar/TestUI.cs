using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using Battle;
public class TestUI : MonoBehaviour {

    Button m_btn;
    InputField m_inputfieldX;
    InputField m_inputfieldY;
    InputField m_inputFieldRadius;

    void Awake()
    {
        m_btn = GameObject.Find("Button").GetComponent<Button>();
        m_inputfieldX = GameObject.Find("InputFieldX").GetComponent<InputField>();
        m_inputfieldY = GameObject.Find("InputFieldY").GetComponent<InputField>();
        m_inputFieldRadius = GameObject.Find("InputFieldRadius").GetComponent<InputField>();
       
    }

    void Start () {
        m_btn.onClick.AddListener(delegate () { OnClickMyButton(m_btn.gameObject); });
        m_inputfieldX.text = "0";
        m_inputfieldY.text = "0";
        m_inputFieldRadius.text = "1000";
    }

    void OnClickMyButton(GameObject obj)
    {
        if (m_inputfieldX.text == "" || m_inputfieldY.text == "" || m_inputFieldRadius.text == "")
        {
            return;
        }
        var tempRadius = float.Parse(m_inputFieldRadius.text);
        var tempX = float.Parse(m_inputfieldX.text);
        var tempY = float.Parse(m_inputfieldY.text);
        var tempPos = new Vector3(tempX, 0, tempY);
        FOWLogic.instance.ChangeFogOfWarRange(tempPos, tempRadius);
        FOWSystem.instance.enableSystem = true;
    }
}
