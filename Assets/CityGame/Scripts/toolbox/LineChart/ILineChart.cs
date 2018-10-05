using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public interface ILineChart
{
    //顶点  矩形  折线数据
    VertexHelper DrawLineChart(VertexHelper vh, Rect rect, LineChartData basis);
    VertexHelper DrawMesh(VertexHelper vh);
    VertexHelper DrawAxis(VertexHelper vh);
}
public class VertexStream
{
    public IList<Vector2> vertexs = null;
    public Color color;

    public VertexStream(IList<Vector2> vertexs, Color color0)
    {
        this.vertexs = vertexs;
        color = color0;
    }
}

[Serializable]
public class LineChartData
{
    [Header("折线图轴设置")]
    public bool IsDrawAxis = true;          //是否画出轴线
    public float AxisWidth = 2.0f;          //轴线的宽度
    public Color AxisColor = Color.white;   //轴线的颜色
    public bool ShowArrow = false;          //是否显示箭头

    [Header("折线图网设置")]
    public bool IsDrawMeshX = true;         //是否网格X线
    public bool IsDrawMeshY = true;         //是否网格Y线
    public float MeshWidth = 2.0f;          //网格虚线宽度
    public Color MeshColor = Color.gray;    //网格虚线颜色
    [Range(5, 1000)]
    public float MeshCellXSize = 25.0f;     //网格X单元尺寸
    [Range(5, 1000)]
    public float MeshCellYSize = 10f;     //网格Y单元尺寸
    public bool IsImaginaryLine = false;   //是否是虚线

    [HideInInspector]
    public Vector2 MeshCellSize { get { return new Vector2(MeshCellXSize, MeshCellYSize); } }//网格单元尺寸
    [Header("折线设置")]
    public Color[] LineColors = new Color[] { };    //线的颜色
    public bool IsShowUnit = false;                 //是否文本
    //public float XUint = 1;                       //X
    //public float YUint = 10;                      //Y
    public Text XUnitTemplate = null;               //X轴文本框
    public Text YUnitTemplate = null;               //Y轴文本框
    public GameObject Lineobj = null;               //空物体的大小
    [HideInInspector]
    public Dictionary<int, VertexStream> Lines = new Dictionary<int, VertexStream>(); //排成一行；画线于（line的三单形式）

    public void AddLine(IList<Vector2> vertexs)
    {
        Color color = Color.black;
        if (LineColors.Length >= Lines.Count)
            color = LineColors[Lines.Count];
        Lines.Add(Lines.Count, new VertexStream(vertexs, color));

        Debug.Log("!!!!!!!Lines.Count的长度是" + vertexs.Count);
    }
    public IList<Vector2> GetLine(int id)
    {
        return Lines[id].vertexs;
    }
    //更换线
    public void ReplaceLines(int[] ids, IList<Vector2>[] vertexs)
    {
        for (int i = 0; i < ids.Length; i++)
            Lines[ids[i]] = new VertexStream(vertexs[i], LineColors[ids[i]]);
    }
    //删除行
    //public void RemoveLine(int[] ids)
    //{
    //    foreach (int id in ids)
    //        Lines.Remove(id);
    //}
    //public void ClearLines()
    //{
    //    Lines.Clear();
    //}
}
