using UnityEngine;
using System.Collections;
using UnityEngine.UI;
using System;
using System.Collections.Generic;
//Allen
//2018.10.4
public class Line
{

    private int _startVertexIndex = 0;
    /// <summary>
    /// 起点索引
    /// </summary>
    public int StartVertexIndex
    {
        get
        {
            return _startVertexIndex;
        }
    }

    private int _endVertexIndex = 0;
    /// <summary>
    /// 终点索引
    /// </summary>
    public int EndVertexIndex
    {
        get
        {
            return _endVertexIndex;
        }
    }

    private int _vertexCount = 0;
    /// <summary>
    /// 该行占的点数目
    /// </summary>
    public int VertexCount
    {
        get
        {
            return _vertexCount;
        }
    }

    public Line(int startVertexIndex, int length)
    {
        _startVertexIndex = startVertexIndex;
        _endVertexIndex = length * 6 - 1 + startVertexIndex;
        _vertexCount = length * 6;
    }
}


[AddComponentMenu("UI/Effects/TextSpacing")]
public class TextSpacing : BaseMeshEffect
{
    public float _textSpacing = 1f;
    private bool isCenter = false;

    public override void ModifyMesh(VertexHelper vh)
    {
        if (!IsActive() || vh.currentVertCount == 0)
        {
            return;
        }

        Text text = GetComponent<Text>();
        if (text == null)
        {
            Debug.LogError("Missing Text component");
            return;
        }

        List<UIVertex> vertexs = new List<UIVertex>();
        vh.GetUIVertexStream(vertexs);
        int indexCount = vh.currentIndexCount;

        //获取文本锚点
        TextAnchor tempAnchor = text.alignment;

        if (tempAnchor == TextAnchor.MiddleCenter || tempAnchor == TextAnchor.LowerCenter || tempAnchor == TextAnchor.UpperCenter)
        {
            isCenter = true;
        }
        

        string[] lineTexts = text.text.Split('\n');

        Line[] lines = new Line[lineTexts.Length];

        //根据lines数组中各个元素的长度计算每一行中第一个点的索引，每个字、字母、空母均占6个点
        for (int i = 0; i < lines.Length; i++)
        {
            //除最后一行外，vertexs对于前面几行都有回车符占了6个点
            if (i == 0)
            {
                lines[i] = new Line(0, lineTexts[i].Length + 1);
            }
            else if (i > 0 && i < lines.Length - 1)
            {
                lines[i] = new Line(lines[i - 1].EndVertexIndex + 1, lineTexts[i].Length + 1);
            }
            else
            {
                lines[i] = new Line(lines[i - 1].EndVertexIndex + 1, lineTexts[i].Length);
            }
        }

        UIVertex vt;
        if (isCenter)
        {
            int charIndex; //当前Vertexs的点对应的所在行字符索引，1开始
            float center;//当前所在行中点
            for (int i = 0; i < lines.Length; i++)
            {
                //根据字间距计算每行第一个锚点的距离，对锚点距离进行偏移
                center = (lineTexts[i].Length + 1) / 2;
                for (int j = lines[i].StartVertexIndex; j <= lines[i].EndVertexIndex; j++)//此处避开了第一个点
                {
                    if (j < 0 || j >= vertexs.Count)
                    {
                        continue;
                    }
                    charIndex = (j - lines[i].StartVertexIndex) / 6 + 1;
                    vt = vertexs[j];
                    vt.position += new Vector3(_textSpacing * (charIndex - center), 0, 0);
                    vertexs[j] = vt;
                    //以下注意点与索引的对应关系
                    if (j % 6 <= 2)
                    {
                        vh.SetUIVertex(vt, (j / 6) * 4 + j % 6);
                    }
                    if (j % 6 == 4)
                    {
                        vh.SetUIVertex(vt, (j / 6) * 4 + j % 6 - 1);
                    }
                }
            }
        }
        else
        {
            for (int i = 0; i < lines.Length; i++)
            {
                //TODO:根据字间距计算每行第一个锚点的距离，对锚点距离进行偏移
                for (int j = lines[i].StartVertexIndex + 6; j <= lines[i].EndVertexIndex; j++)//此处避开了第一个点
                {
                    if (j < 0 || j >= vertexs.Count)
                    {
                        continue;
                    }
                    vt = vertexs[j];
                    vt.position += new Vector3(_textSpacing * ((j - lines[i].StartVertexIndex) / 6), 0, 0);
                    vertexs[j] = vt;
                    //以下注意点与索引的对应关系
                    if (j % 6 <= 2)
                    {
                        vh.SetUIVertex(vt, (j / 6) * 4 + j % 6);
                    }
                    if (j % 6 == 4)
                    {
                        vh.SetUIVertex(vt, (j / 6) * 4 + j % 6 - 1);
                    }
                }
            }
        }

    }
}
