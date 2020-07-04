using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public interface ILineChart
{
    //Vertex rectangle Polyline data
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
    public bool IsDrawAxis = true;          //Whether to draw the axis
    public float AxisWidth = 2.0f;          //Axis width
    public Color AxisColor = Color.white;   //Axis color
    public bool ShowArrow = false;          //Whether to show arrows

    [Header("折线图网设置")]
    public bool IsDrawMeshX = true;         //Whether grid X-ray
    public bool IsDrawMeshY = true;         //Whether grid Y line
    public float MeshWidth = 2.0f;          //Grid dotted width
    public Color MeshColor = Color.gray;    //Grid dotted color
    [Range(5, 1000)]
    public float MeshCellXSize = 25.0f;     //Grid X unit size
    [Range(5, 1000)]
    public float MeshCellYSize = 10f;     //Grid Y unit size
    public bool IsImaginaryLine = false;   //Whether it is a dotted line

    [HideInInspector]
    public Vector2 MeshCellSize { get { return new Vector2(MeshCellXSize, MeshCellYSize); } }//Grid cell size
    [Header("折线设置")]
    public Color[] LineColors = new Color[] { };    //Line color
    public bool IsShowUnit = false;                 //Whether text
    //public float XUint = 1;                       //X
    //public float YUint = 10;                      //Y
    public Text XUnitTemplate = null;               //X axis text box
    public Text YUnitTemplate = null;               //Y axis text box
    public GameObject Lineobj = null;               //Size of empty object
    [HideInInspector]
    public Dictionary<int, VertexStream> Lines = new Dictionary<int, VertexStream>(); //Lined up; draw line (three forms of line)

    public void AddLine(IList<Vector2> vertexs, Color color)
    {        
        Lines.Add(Lines.Count, new VertexStream(vertexs, color));

        //Debug.Log("!!!!!!!The length of Lines.Count is" + vertexs.Count);
    }
    public IList<Vector2> GetLine(int id)
    {
        return Lines[id].vertexs;
    }
    //Change the line
    public void ReplaceLines(int[] ids, IList<Vector2>[] vertexs)
    {
        for (int i = 0; i < ids.Length; i++)
            Lines[ids[i]] = new VertexStream(vertexs[i], LineColors[ids[i]]);
    }
    //Delete row
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
