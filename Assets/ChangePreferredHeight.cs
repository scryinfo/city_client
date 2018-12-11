using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
namespace UnityEngine
{
    public class ChangePreferredHeight : MonoBehaviour
    {

        //动态改变preferredHeight的值
        public void Change(LayoutElement LayoutElement, float value)
        {
            LayoutElement.preferredHeight = value;
        }
    }
}
