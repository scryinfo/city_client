using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
/// <summary>
/// Draw coordinate axis and grid according to the data information of the basic frame
/// </summary>
public class FunctionalGraph : MaskableGraphic
{
    public FunctionalGraphBase GraphBase;
    private RectTransform _myRect;
    private Vector2 _xPoint;
    private Vector2 _yPoint;
    private float[] boundary ;  //Dividing line
    private Dictionary<int, Dictionary<List<Vector2[]>, List<Color>>> dicLine = new Dictionary<int, Dictionary<List<Vector2[]>, List<Color>>>();//curve
    private Dictionary<int, Dictionary<List<Vector2[]>, List<Color>>> dicChart = new Dictionary<int, Dictionary<List<Vector2[]>, List<Color>>>();//Histogram
    private Slide slide;
    private void OnGUI()
    {
        if (GraphBase.ShowXAxisUnit)
        {
            Vector3 result = transform.localPosition;
            Vector3 realPosition = getScreenPosition(transform, ref result);
            GUIStyle guiStyleX = new GUIStyle();
            guiStyleX.normal.textColor = GraphBase.FontColor;
            guiStyleX.fontSize = GraphBase.FontSize;
            guiStyleX.fontStyle = FontStyle.Bold;
            guiStyleX.alignment = TextAnchor.MiddleLeft;
            GUI.Label(new Rect(local2Screen(realPosition, _xPoint) + new Vector2(20, 0), new Vector2(0, 0)), GraphBase.XAxisUnit, guiStyleX);  
        }
        if (GraphBase.ShowYAxisUnit)
        {
            Vector3 result = transform.localPosition;
            Vector3 realPosition = getScreenPosition(transform, ref result);
            GUIStyle guiStyleY = new GUIStyle();
            guiStyleY.normal.textColor = GraphBase.FontColor;
            guiStyleY.fontSize = GraphBase.FontSize;
            guiStyleY.fontStyle = FontStyle.Bold;
            guiStyleY.alignment = TextAnchor.MiddleCenter;
            GUI.Label(new Rect(local2Screen(realPosition, _yPoint) - new Vector2(0, 20), new Vector2(0, 0)), GraphBase.YAxisUnit, guiStyleY);
        }
    }

    /// 
    /// Initialization function information
    /// 
    private void Init()
    {
        GraphBase = transform.GetComponent<FunctionalGraphBase>();
        _myRect = this.rectTransform;
        slide = transform.GetComponent<Slide>();
    }
    /// 
    /// Override this class to draw UI
    ///
    /// 
    protected override void OnPopulateMesh(VertexHelper vh)
    {
        Init();
        vh.Clear();
        #region 基础框架的绘制
        // Plot the X axis
        float lenght = _myRect.sizeDelta.x;
        Vector2 leftPoint = new Vector2(0, 0);
        Vector2 rightPoint = new Vector2(lenght / 2.0f, 0);
        vh.AddUIVertexQuad(GetQuad(leftPoint, rightPoint, GraphBase.XYAxisColor, GraphBase.XYAxisWidth));
        // Draw an arrow on the X axis
        float arrowUnit = GraphBase.XYAxisWidth * 3;
        Vector2 firstPointX = rightPoint + new Vector2(0, arrowUnit);
        Vector2 secondPointX = rightPoint;
        Vector2 thirdPointX = rightPoint + new Vector2(0, -arrowUnit);
        Vector2 fourPointX = rightPoint + new Vector2(Mathf.Sqrt(3) * arrowUnit, 0);
        //vh.AddUIVertexQuad(GetQuad(firstPointX, secondPointX, thirdPointX, fourPointX, GraphBase.XYAxisColor));
        // Plot Y axis
        if (GraphBase.ShowYScale)
        {
            float height = _myRect.sizeDelta.y;
            Vector2 downPoint = new Vector2(0, 0);
            Vector2 upPoint = new Vector2(0, height / 2.0f);
            vh.AddUIVertexQuad(GetQuad(downPoint, upPoint, GraphBase.XYAxisColor, GraphBase.XYAxisWidth));
            // Draw Y-axis arrow
            Vector2 firstPointY = upPoint + new Vector2(arrowUnit, 0);
            Vector2 secondPointY = upPoint;
            Vector2 thirdPointY = upPoint + new Vector2(-arrowUnit, 0);
            Vector2 fourPointY = upPoint + new Vector2(0, Mathf.Sqrt(3) * arrowUnit);
            //vh.AddUIVertexQuad(GetQuad(firstPointY, secondPointY, thirdPointY, fourPointY, GraphBase.XYAxisColor));
            if (GraphBase.ShowYAxisUnit)
            {
                _yPoint = upPoint;
            }
        }

        #region 绘制折线
        if (dicLine.Count >= 1)
        {
            int index = 0;
            foreach (var item in dicLine.Values)
            {
                index++;
                foreach (var line in item)
                {
                    for (int i = 0; i < line.Key.Count; i++)
                    {
                        for (int v = 1; v < line.Key[i].Length - 1; v++)
                        {
                            vh.AddUIVertexQuad(GetQuad(line.Key[i][v], line.Key[i][v + 1], line.Value[i], GraphBase.LineWidth));
                            if (index == 1)
                            {
                                vh.AddUIVertexQuad(GetQuad(new Vector2(line.Key[i][v].x, 0), line.Key[i][v],
                               line.Key[i][v + 1], new Vector2(line.Key[i][v + 1].x, 0), new Color(56f / 255, 167f / 255, 202f / 255, 77f / 255)));
                            }
                        }
                    }
                }
            }
        }

        //Draw a histogram
        if(dicChart.Count >= 1)
        {
            foreach (var item in dicChart.Values)
            {
                foreach (var chart in item)
                {
                    for (int i = 0; i < chart.Key.Count; i++)
                    {
                        for (int k = 0; k < chart.Key[i].Length; k++)
                        {
                            vh.AddUIVertexQuad(GetQuad(new Vector2(chart.Key[i][k].x - GraphBase.ChartWidth / 2, 0),
                                new Vector2(chart.Key[i][k].x - GraphBase.ChartWidth / 2, chart.Key[i][k].y),
                                new Vector2(chart.Key[i][k].x + GraphBase.ChartWidth / 2, chart.Key[i][k].y),
                                new Vector2(chart.Key[i][k].x + GraphBase.ChartWidth / 2, 0),
                                chart.Value[i]));
                        }
                    }
                }
            }
        }
      
        #endregion
        if (GraphBase.ShowXAxisUnit)
        {
            _xPoint = rightPoint; 
        }
        #region 刻度的绘制
        if (GraphBase.ShowScale)
        {
            // Positive direction of X axis
            for (int i = 1; i * GraphBase.XScaleValue < _myRect.sizeDelta.x; i++)
            {
                Vector2 firstPoint = Vector2.zero + new Vector2(GraphBase.XScaleValue * i, 0);
                Vector2 secongPoint = firstPoint + new Vector2(0, GraphBase.ScaleLenght);
                vh.AddUIVertexQuad(GetQuad(firstPoint, secongPoint, GraphBase.XYAxisColor));
            }
            //// X axis negative direction
            //for (int i = 1; i * -GraphBase.XScaleValue > -_myRect.sizeDelta.x; i++ )
            //{
            //    Vector2 firstPoint = Vector2.zero + new Vector2(-GraphBase.XScaleValue * i, 0);
            //    Vector2 secongPoint = firstPoint + new Vector2(0, GraphBase.ScaleLenght);
            //    //vh.AddUIVertexQuad(GetQuad(firstPoint, secongPoint, GraphBase.XYAxisColor));
            //}
            //// Positive direction of Y axis
            //for (int y = 1; y * GraphBase.YScaleValue < _myRect.sizeDelta.y; y++ )
            //{
            //    Vector2 firstPoint = Vector2.zero + new Vector2(0, y * GraphBase.YScaleValue);
            //    Vector2 secongPoint = firstPoint + new Vector2(GraphBase.ScaleLenght, 0);
            //    vh.AddUIVertexQuad(GetQuad(firstPoint, secongPoint, GraphBase.XYAxisColor));
            //}
            //// Y axis negative direction
            //for (int y = 1; y * -GraphBase.YScaleValue > -_myRect.sizeDelta.y; y++ )
            //{
            //    Vector2 firstPoint = Vector2.zero + new Vector2(0, y * -GraphBase.YScaleValue);
            //    Vector2 secongPoint = firstPoint + new Vector2(GraphBase.ScaleLenght, 0);
            //    //vh.AddUIVertexQuad(GetQuad(firstPoint, secongPoint, GraphBase.XYAxisColor));
            //}
        }
        #endregion
        #region 根据网格类型绘制网格
        switch (GraphBase.MeshType)
        {
            case FunctionalGraphBase.E_MeshType.None:
                break;
            case FunctionalGraphBase.E_MeshType.FullLine:
                //// Positive direction of X axis
                //for (int i = 1; i * GraphBase.XScaleValue < _myRect.sizeDelta.x ; i++ )
                //{
                //    Vector2 firstPoint = Vector2.zero + new Vector2(GraphBase.XScaleValue * i, 0);
                //    Vector2 secongPoint = firstPoint + new Vector2(0, _myRect.sizeDelta.y);
                //    //vh.AddUIVertexQuad(GetQuad(firstPoint, secongPoint, GraphBase.MeshColor, GraphBase.MeshLineWidth));
                //}
                //// X axis negative direction
                //for (int i = 1; i * -GraphBase.XScaleValue> -_myRect.sizeDelta.x ; i++ )
                //{
                //    Vector2 firstPoint = Vector2.zero + new Vector2(-GraphBase.XScaleValue * i, -_myRect.sizeDelta.y);
                //    Vector2 secongPoint = firstPoint + new Vector2(0, _myRect.sizeDelta.y);
                //    //vh.AddUIVertexQuad(GetQuad(firstPoint, secongPoint, GraphBase.MeshColor, GraphBase.MeshLineWidth));
                //}
                // Positive direction of Y axis
                for (int y = 1; y * GraphBase.YScaleValue < _myRect.sizeDelta.y ; y++ )
                {
                    Vector2 firstPoint = Vector2.zero + new Vector2(0, y * GraphBase.YScaleValue);
                    Vector2 secongPoint = firstPoint + new Vector2(_myRect.sizeDelta.x, 0);
                    vh.AddUIVertexQuad(GetQuad(firstPoint, secongPoint, GraphBase.MeshColor, GraphBase.MeshLineWidth));
                }
                //// Y axis negative direction
                //for (int y = 1; y * -GraphBase.YScaleValue > -_myRect.sizeDelta.y ; y++ )
                //{
                //    Vector2 firstPoint = Vector2.zero + new Vector2(-_myRect.sizeDelta.x , -y * GraphBase.YScaleValue);
                //    Vector2 secongPoint = firstPoint + new Vector2(_myRect.sizeDelta.x, 0);
                //    //vh.AddUIVertexQuad(GetQuad(firstPoint, secongPoint, GraphBase.MeshColor, GraphBase.MeshLineWidth));
                //}
                break;
            //case FunctionalGraphBase.E_MeshType.ImaglinaryLine:
            //    // Positive direction of X axis
            //    for (int i = 1; i * GraphBase.XScaleValue< _myRect.sizeDelta.x; i++ )
            //    {
            //        Vector2 firstPoint = Vector2.zero + new Vector2(GraphBase.XScaleValue * i, 0);
            //        Vector2 secondPoint = firstPoint + new Vector2(0, _myRect.sizeDelta.y);
            //        //GetImaglinaryLine(ref vh, firstPoint, secondPoint, GraphBase.MeshColor, GraphBase.ImaglinaryLineWidth, GraphBase.SpaceingWidth);
            //    }
            //    // X axis negative direction
            //    for (int i = 1; i * -GraphBase.XScaleValue > -_myRect.sizeDelta.x ; i++ )
            //    {
            //        Vector2 firstPoint = Vector2.zero + new Vector2(-GraphBase.XScaleValue * i, -_myRect.sizeDelta.y);
            //        Vector2 secondPoint = firstPoint + new Vector2(0, _myRect.sizeDelta.y);
            //       // GetImaglinaryLine(ref vh, firstPoint, secondPoint, GraphBase.MeshColor, GraphBase.ImaglinaryLineWidth, GraphBase.SpaceingWidth);
            //    }
            //    // Positive direction of Y axis
            //    for (int y = 1; y * GraphBase.YScaleValue < _myRect.sizeDelta.y ; y++ )
            //    {
            //        Vector2 firstPoint = Vector2.zero + new Vector2(0, y * GraphBase.YScaleValue);
            //        Vector2 secondPoint = firstPoint + new Vector2(_myRect.sizeDelta.x, 0);
            //        GetImaglinaryLine(ref vh, firstPoint, secondPoint, GraphBase.MeshColor, GraphBase.ImaglinaryLineWidth, GraphBase.SpaceingWidth);
            //    }
            //    // Y axis negative direction
            //    for (int y = 1; y * -GraphBase.YScaleValue > -_myRect.sizeDelta.y ; y++ )
            //    {
            //        Vector2 firstPoint = Vector2.zero + new Vector2(-_myRect.sizeDelta.x , -y * GraphBase.YScaleValue);
            //        Vector2 secondPoint = firstPoint + new Vector2(_myRect.sizeDelta.x, 0);
            //       // GetImaglinaryLine(ref vh, firstPoint, secondPoint, GraphBase.MeshColor, GraphBase.ImaglinaryLineWidth, GraphBase.SpaceingWidth);
            //    }
            //    break;
        }
        // Dividing line
        if (boundary != null)
        {
            for (int i = 1; i < boundary.Length; i++)
            {
                Vector2 firstPoint = Vector2.zero + new Vector2(boundary[i], 0);
                Vector2 secondPoint = firstPoint + new Vector2(0, _myRect.sizeDelta.y);
                GetImaglinaryLine(ref vh, firstPoint, secondPoint, new Color(0, 138 / 255f, 283 / 255f, 1), GraphBase.ImaglinaryLineWidth, GraphBase.SpaceingWidth);
            }
        }
      
        #endregion
        #endregion
    }
    //Draw a rectangle through two endpoints
    private UIVertex[] GetQuad(Vector2 startPos, Vector2 endPos, Color color0, float lineWidth = 2.0f)
    {
        float dis = Vector2.Distance(startPos, endPos);
        float y = lineWidth * 0.5f * (endPos.x - startPos.x) / dis;
        float x = lineWidth * 0.5f * (endPos.y - startPos.y) / dis;
        if (y<= 0 ) y = -y;
        else x = -x;
        UIVertex[] vertex = new UIVertex[4];
        vertex[0].position = new Vector3(startPos.x + x, startPos.y + y);
        vertex[1].position = new Vector3(endPos.x + x, endPos.y + y);
        vertex[2].position = new Vector3(endPos.x - x, endPos.y - y);
        vertex[3].position = new Vector3(startPos.x - x, startPos.y - y);
        for (int i = 0; i < vertex.Length ; i++ ) vertex[i].color = color0;
        return vertex;
    }
    //Draw a rectangle through four vertices
    private UIVertex[] GetQuad(Vector2 first, Vector2 second, Vector2 third, Vector2 four, Color color0)
    {
        UIVertex[] vertexs = new UIVertex[4];
        vertexs[0] = GetUIVertex(first, color0);
        vertexs[1] = GetUIVertex(second, color0);
        vertexs[2] = GetUIVertex(third, color0);
        vertexs[3] = GetUIVertex(four, color0);
        return vertexs;
    }
    //Construct UIVertex
    private UIVertex GetUIVertex(Vector2 point, Color color0)
    {
        UIVertex vertex = new UIVertex
        {
            position = point,
            color = color0,
            uv0 = new Vector2(0, 0)
        };
        return vertex;
    }
    //Draw a dotted line
    private void GetImaglinaryLine(ref VertexHelper vh, Vector2 first, Vector2 second, Color color0, float imaginaryLenght, float spaceingWidth, float lineWidth = 2.0f)
    {
        if (first.y.Equals(second.y)) //  X axis
        {
            Vector2 indexSecond = first + new Vector2(imaginaryLenght, 0);
            while (indexSecond.x< second.x)
            {
                vh.AddUIVertexQuad(GetQuad(first, indexSecond, color0));
                first = indexSecond + new Vector2(spaceingWidth, 0);
                indexSecond = first + new Vector2(imaginaryLenght, 0);
                if (indexSecond.x> second.x )
                {
                    indexSecond = new Vector2(second.x, indexSecond.y);
                    vh.AddUIVertexQuad(GetQuad(first, indexSecond, color0));
                }
            }
        }
        if (first.x.Equals(second.x)) //  y axis
        {
            Vector2 indexSecond = first + new Vector2(0, imaginaryLenght);
            while (indexSecond.y< second.y)
            {
                vh.AddUIVertexQuad(GetQuad(first, indexSecond, color0));
                first = indexSecond + new Vector2(0, spaceingWidth);
                indexSecond = first + new Vector2(0, imaginaryLenght);
                if (indexSecond.y > second.y )
                {
                    indexSecond = new Vector2(indexSecond.x, second.y);
                    vh.AddUIVertexQuad(GetQuad(first, indexSecond, color0));
                }
            }
        }
    }
    //Convert local coordinates to screen coordinates to draw GUI text
    private Vector2 local2Screen(Vector2 parentPos, Vector2 localPosition)
    {
        Vector2 pos = localPosition + parentPos;
        float xValue, yValue = 0;
        if (pos.x > 0 )
            xValue = pos.x + Screen.width / 2.0f;
        else
            xValue = Screen.width / 2.0f - Mathf.Abs(pos.x);
        if (pos.y> 0 )
            yValue = Screen.height / 2.0f - pos.y;
        else
            yValue = Screen.height / 2.0f + Mathf.Abs(pos.y);
        return new Vector2(xValue, yValue);
    }
    //Recursively calculate position
    private Vector2 getScreenPosition(Transform trans, ref Vector3 result)
    {
        if (null != trans.parent && null != trans.parent.parent )
        {
            result += trans.parent.localPosition;
            getScreenPosition(trans.parent, ref result);
        }
        if (null != trans.parent && null == trans.parent.parent )
            return result;
        return result;
    }
    //Draw polyline
    public void DrawLine(Vector2[] lines,Color color,int id)
    {
        List<Vector2[]> line = new List<Vector2[]>();
        List<Color> lineColor = new List<Color>();
        if (lines.Length == 2)
        {
            Vector2[] temp = { lines[0], lines[1],new Vector2(lines[1].x + 10f, lines[1].y) };
            line.Add(temp);
        }
        else
        {
            line.Add(lines);
        }       
        lineColor.Add(color);
        Dictionary<List<Vector2[]>, List<Color>> dic = new Dictionary<List<Vector2[]>, List<Color>>();
        dic.Add(line, lineColor);
        if (!dicLine.ContainsKey(id))
        {
            dicLine.Add(id, dic);
        }
        else
        {
            dicLine.Remove(id);
        }
    }
    //Dividing line
    public void BoundaryLine(float[] f)
    {
        boundary = f;
    }
    //Clear data
    public void Close()
    {
        dicLine.Clear();
        dicChart.Clear();
    }
    //Histogram
    public void DrawHistogram(Vector2[] lines, Color color, int id)
    {
        List<Vector2[]> chart = new List<Vector2[]>();
        List<Color> chartColor = new List<Color>();
        chart.Add(lines);
        chartColor.Add(color);
        Dictionary<List<Vector2[]>, List<Color>> dic = new Dictionary<List<Vector2[]>, List<Color>>();
        dic.Add(chart, chartColor);
        if (!dicChart.ContainsKey(id))
        {
            dicChart.Add(id, dic);
        }
        else
        {
            dicChart.Remove(id);
        }
    }
}
