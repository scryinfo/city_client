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
    /// Starting point index
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
    /// End index
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
    /// The number of points occupied by the line
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

        //Get text anchor
        TextAnchor tempAnchor = text.alignment;

        if (tempAnchor == TextAnchor.MiddleCenter || tempAnchor == TextAnchor.LowerCenter || tempAnchor == TextAnchor.UpperCenter)
        {
            isCenter = true;
        }
        

        string[] lineTexts = text.text.Split('\n');

        Line[] lines = new Line[lineTexts.Length];

        //Calculate the index of the first point in each line according to the length of each element in the lines array, each word, letter, and empty mother occupy 6 points
        for (int i = 0; i < lines.Length; i++)
        {
            //Except for the last line, vertexs have carriage returns for the first few lines and take up 6 points
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
            int charIndex; //The character index of the line corresponding to the current Vertexs point, starting with 1
            float center;//Midpoint of current line
            for (int i = 0; i < lines.Length; i++)
            {
                //Calculate the distance of the first anchor point of each line according to the word spacing, and offset the anchor point distance
                center = (lineTexts[i].Length + 1) / 2;
                for (int j = lines[i].StartVertexIndex; j <= lines[i].EndVertexIndex; j++)//The first point is avoided here
                {
                    if (j < 0 || j >= vertexs.Count)
                    {
                        continue;
                    }
                    charIndex = (j - lines[i].StartVertexIndex) / 6 + 1;
                    vt = vertexs[j];
                    vt.position += new Vector3(_textSpacing * (charIndex - center), 0, 0);
                    vertexs[j] = vt;
                    //The correspondence between the following points and indexes
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
                //TODO: Calculate the distance of the first anchor point of each line according to the word spacing, and offset the distance of the anchor point
                for (int j = lines[i].StartVertexIndex + 6; j <= lines[i].EndVertexIndex; j++)//The first point is avoided here
                {
                    if (j < 0 || j >= vertexs.Count)
                    {
                        continue;
                    }
                    vt = vertexs[j];
                    vt.position += new Vector3(_textSpacing * ((j - lines[i].StartVertexIndex) / 6), 0, 0);
                    vertexs[j] = vt;
                    //The correspondence between the following points and indexes
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
