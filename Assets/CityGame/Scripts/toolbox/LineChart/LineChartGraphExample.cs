using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using City;

public class LineChartGraphExample : MonoBehaviour {

    //自定义数据类型，会用于反射获取值
    public class TestData
    {
        public float xValue { get; set; }
        public float yValue { get; set; }
        public TestData(float x,float y)
        {
            xValue = x;
            yValue = y; 
        }
    }    
    
    public LineChart LineChart = null;
    public GameObject XAixs = null;
    public GameObject YXixs = null;
    public void Awake()
    {
        XAixs.SetActive(true);
        YXixs.SetActive(true);
        //生成模拟值
        //每个值X坐标一定是相隔固定距离
        //否则在传入动态数据流式会出现动画的偏差        
        var data = new List<Vector2>()
        {
                new Vector2(0.0f,0.0f),
                new Vector2(0.1f,0.4f),
                new Vector2(0.2f,0.6f),
                new Vector2(0.3f,0.4f),
                new Vector2(0.4f,0.5f),
                new Vector2(0.5f,0.1f),
                new Vector2(0.6f,0.3f),
                new Vector2(0.7f,0.7f),
                new Vector2(0.8f,0.6f),
                new Vector2(0.9f,0.2f),
                new Vector2(1.0f,0.5f),
                //new TestData(1.1f,0.3f),
                //new TestData(1.2f,0.7f),
                //new TestData(1.3f,0.6f),
                //new TestData(1.4f,0.2f),
                //new TestData(1.5f,0.5f),
        };

        var data1 = new List<Vector2>()
        {
                new Vector2(0.0f,0.2f),
                new Vector2(0.1f,0.1f),
                new Vector2(0.2f,0.5f),
                new Vector2(0.3f,0.8f),
                new Vector2(0.4f,0.2f),
                new Vector2(0.5f,0.7f),
                new Vector2(0.6f,0.5f),
                new Vector2(0.7f,0.4f),
                new Vector2(0.8f,0.3f),
                new Vector2(0.9f,0.6f),
                new Vector2(1.0f,0.9f),
               
                //new TestData(1.1f,0.3f),
                //new TestData(1.2f,0.7f),
                //new TestData(1.3f,0.6f),
                //new TestData(1.4f,0.2f),
                //new TestData(1.5f,0.5f),
        };
        var Color = new Color(1, 0, 0, 1);
        var Color1 = new Color(0, 1, 0, 1);
        //插入值
        LineChart.InjectDatas(data, Color);
        LineChart.InjectDatas(data1, Color1);
        //显示单位
        LineChart.ShowUnit();
    }
}