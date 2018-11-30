using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace UnityEngine
{
    [Serializable]
    public class GridSort : MonoBehaviour
    {
        [Header("设置宽度,默认自适应")]
        public float[] cellWidth;   //设置宽度
        private Transform[] childObj;
        private int widthCount;
        private float width;
        private float height;
        [Header("宽度间隙")]
        public float spaceWidth; //宽度间隙

        public void _initData(float[] width)
        {
            for (int i = 0; i < width.Length; i++)
            {
                cellWidth[i] = width[i];
            }
        }
        private void Start()
        {
            widthCount = this.transform.childCount;
            width = this.transform.GetComponent<RectTransform>().rect.width;
            height = this.transform.GetComponent<RectTransform>().rect.height;
            childObj = new Transform[widthCount];
            for (int i = 0; i < widthCount; i++)
            {
                childObj[i] = this.transform.GetChild(i);
            }
            if (widthCount > childObj.Length)
                return;
            Stro(childObj, widthCount, cellWidth, spaceWidth);
        }
        private void Stro(Transform[] childObj, int row, float[] cellWidth, float spaceWidth)
        {
            float lenght = 0;
            int count = 0;
            if (childObj == null)
                return;
            for (int i = 0; i < row; i++)
            {
                if (cellWidth[i] != 0)
                {
                    lenght = lenght + cellWidth[i];
                    count++;
                }
            }
            float x = 0;
            float y = 0;
            for (int i = 0; i < row; i++)
            {
                if (cellWidth[i] == 0)
                    cellWidth[i] = (width - lenght - spaceWidth * widthCount) / (row - count);
                if (i == 0)
                {
                    x = 0;
                }
                else
                {
                    x = x + cellWidth[i - 1];

                }
                childObj[i].transform.GetComponent<RectTransform>().sizeDelta = new Vector2(cellWidth[i], height);
                childObj[i].transform.localPosition = new Vector3(x + spaceWidth * i, y, 0);
            }
        }
        public Sprite ResourcesImage(string path)
        {
            return Resources.Load<Sprite>(path);
        }
    }
}
