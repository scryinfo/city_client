using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using System.Reflection;

public class LineChartCurve : BaseLineChart
{
    /// <summary>
    /// 画出折线图
    /// </summary>
    /// <param name="vh"></param>
    /// <param name="vRect"></param>
    /// <param name="vBasis"></param>
    /// <returns></returns>
    public override VertexHelper DrawLineChart(VertexHelper vh, Rect vRect, LineChartData vBasis)
    {
        vh = base.DrawLineChart(vh,vRect,vBasis);
        foreach (KeyValuePair<int,VertexStream>line in lines)
        {
            if (line.Value.vertexs.Count <= 1)
                continue;
            var startPos = GetPos(line.Value.vertexs[0]);
            UIVertex[] oldVertexs = new UIVertex[] { };
            for (int i = 0; i < line.Value.vertexs.Count; i++)
            {
                var endPos = GetPos(line.Value.vertexs[i]);
                var newVertexs = GetQuad(startPos,endPos,line.Value.color);
                if (oldVertexs.Length.Equals(0))
                {
                    oldVertexs = newVertexs;
                }
                else
                {
                    vh.AddUIVertexQuad(new UIVertex[]
                    {
                        oldVertexs[1],
                        newVertexs[1],
                        oldVertexs[2],
                        newVertexs[0]
                    });
                    vh.AddUIVertexQuad(new UIVertex[]
                    {
                        newVertexs[0],
                        oldVertexs[1],
                        newVertexs[3],
                        oldVertexs[2]
                    });
                    vh.AddUIVertexQuad(newVertexs);
                    startPos = endPos;
                }
            }
        }
        return vh;
    }
}
public class LineChartDataMediator
{
    /// <summary>
    /// 通过反射获得格式数据
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="vertexs"></param>
    /// <returns></returns>
    public IList<Vector2> Inject<T>(IList<T> vertexs)
    {
        IList<Vector2> result = new List<Vector2>();
        Type type = typeof(T);
        PropertyInfo[] PropertyInfo = type.GetProperties();
        //反射遍历属性获取顶点值
        foreach (T vertex in vertexs)
        {
            float x = 0.0f;
            float y = 0.0f;
            foreach (PropertyInfo info in PropertyInfo)
            {
                if (info.Name.Equals("xValue"))
                    x = (float)info.GetValue(vertex, null);
                if (info.Name.Equals("yValue"))
                    y = (float)info.GetValue(vertex, null);
            }
            result.Add(new Vector2(x, y));
            //Debug.Log("!!!!!!!!画出来的顶点X" + x + "!!!!!!!!画出来的顶点Y" + y);
        }
        return result;
    }
}
