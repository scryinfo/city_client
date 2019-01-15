//饼图暴露给lua的方法
//徐雅芳


using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ChartAndGraph;


public class PieNeedData
{
    public float piePercent;  //显示的百分比
    public string pieName;  //显示的名字
    public Color showColor;  //显示的颜色
    public bool hideLine;  //是否需要隐藏线和信息
}

public static class PieChartGraph
{
    private static PieChart m_pieChart = null;
    private static GameObject m_piePrefab = null;  //预制

    /// <summary>
    /// 创建饼状图
    /// </summary>
    /// <param name="dataList">创建饼状图需要的信息</param>
    /// <param name="showArea">需要显示的父物体的宽高</param>
    public static void CratePieChartFunc(GameObject pieChartPrefab, PieNeedData[] dataList, RectTransform parentRect)
    {
        GameObject pieTest = null;
        if (m_piePrefab == null)
        {
            pieTest = GameObject.Instantiate(pieChartPrefab);
            m_piePrefab = pieTest;
        }

        pieTest.transform.SetParent(parentRect);
        pieTest.transform.localScale = Vector3.one;
        pieTest.transform.localPosition = Vector3.zero;
        PieChart pieChart = pieTest.GetComponent<PieChart>();
        if (pieChart != null)
        {
            m_pieChart = pieChart;
            int maxCount = (int)(parentRect.rect.size.y / 30);
            dataList = GetFixedList(dataList, maxCount);

            pieChart.Radius = parentRect.rect.size.y / 3.5f;
            pieChart.StraightLineLength = (parentRect.rect.size.x / 2 - pieChart.Radius) / 3;
            float length = Mathf.Clamp(pieChart.StraightLineLength, pieChart.Radius * 0.3f, pieChart.Radius);
            for (int i = 0; i < dataList.Length; i++)
            {
                pieChart.DataSource.AddCategory(dataList[i].pieName, null, dataList[i].showColor, dataList[i].hideLine);
                pieChart.DataSource.SetValue(dataList[i].pieName, dataList[i].piePercent);
            }
        }
    }

    //设置饼图的旋转量
    public static void SetStartAngle(float angle)
    {
        if (m_pieChart != null)
        {
            m_pieChart.StartAngle = angle;
        }
    }
    
    //设置块的偏移量
    public static void SetExtrusion(float value)
    {
        if (m_pieChart != null)
        {
            m_pieChart.Extrusion = value;
        }
    }

    //刷新饼图数据
    public static void RefreshPieChart(PieNeedData[] dataList, RectTransform parentRect)
    {
        m_pieChart.DataSource.Clear();

        int maxCount = (int)(parentRect.rect.size.y / 30);
        dataList = GetFixedList(dataList, maxCount);
        for (int i = 0; i < dataList.Length; i++)
        {
            m_pieChart.DataSource.AddCategory(dataList[i].pieName, null, dataList[i].showColor, dataList[i].hideLine);
            m_pieChart.DataSource.SetValue(dataList[i].pieName, dataList[i].piePercent);
        }
    }

    ////public static void TweeningPie(float time)
    ////{
    ////    float temp = Vector2.Lerp(Vector2.zero, new Vector2(360, 0), time).x;
    ////}

    //销毁饼状图
    public static void DestoryPieChart()
    {
        GameObject.Destroy(m_pieChart.gameObject);
    }

    //由整数得到对应颜色值
    public static Color GetColor(float r, float b, float g, float a = 1.0f)
    {
        float value1 = r / 255;
        float value2 = b / 255;
        float value3 = g / 255;
        return new Color(value1, value2, value3, a);
    }

    //获取已经排好的数据 --第二个参数是一个象限最多显示的个数
    private static PieNeedData[] GetFixedList(PieNeedData[] dataList, int maxShowCount)
    {
        List<PieNeedData> newDatas = new List<PieNeedData>();
        System.Array.Sort(dataList, SortByPiePercentLower);
        //设置最多显示多少数据
        float totalPercent = 0;
        int index = 0;
        for (int i = 0; i < dataList.Length; i++)
        {
            totalPercent += dataList[i].piePercent;
            if (totalPercent >= 50 && i > maxShowCount)
            {
                index = i;
                break;
            }
        }
        if (index > 0)
        {
            int value = (dataList.Length - index) / 2;
            for (int i = 0; i < value; i++)
            {
                dataList[i].hideLine = true;
            }
        }

        //将最小的排布在x正轴
        List<PieNeedData> tailList = new List<PieNeedData>();
        for (int i = 0; i < dataList.Length; i++)
        {
            if (tailList.Count < newDatas.Count)
            {
                tailList.Add(dataList[i]);
                continue;
            }
            newDatas.Add(dataList[i]);
        }
        tailList.Reverse();
        newDatas.AddRange(tailList);

        return newDatas.ToArray();
    }

    private static int SortByPiePercent(PieNeedData data1, PieNeedData data2)
    {
        return data2.piePercent.CompareTo(data1.piePercent);
    }
    private static int SortByPiePercentLower(PieNeedData data1, PieNeedData data2)
    {
        return data1.piePercent.CompareTo(data2.piePercent);
    }

    
}
