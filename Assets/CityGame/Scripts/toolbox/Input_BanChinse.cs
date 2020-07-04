using System.Collections;
using System.Collections.Generic;
using System.Text.RegularExpressions;
using UnityEngine;
using UnityEngine.UI;
namespace UnityEngine
{
    public class Input_BanChinse:MonoBehaviour
    {
        /// <summary>
        /// The input box prohibits the input of Chinese
        /// </summary>
        /// <param name="input"></param>
        public void BanChinese(InputField input)
        {
            var str = Regex.Replace(input.text, @"[\u4e00-\u9fa5]+", "");
            if (input.text == str)
                return;

            input.text = str;
        }
    }
}
