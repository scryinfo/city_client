using System.Collections;
using System.Collections.Generic;
using UnityEngine;

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
        var data = new List<TestData>()
        {
                new TestData(0.0f,0.0f),
                new TestData(0.1f,0.4f),
                new TestData(0.2f,0.6f),
                new TestData(0.3f,0.4f),
                new TestData(0.4f,0.5f),
                new TestData(0.5f,0.1f),
                new TestData(0.6f,0.3f),
                new TestData(0.7f,0.7f),
                new TestData(0.8f,0.6f),
                new TestData(0.9f,0.2f),
                new TestData(1.0f,0.5f),
                //new TestData(1.1f,0.3f),
                //new TestData(1.2f,0.7f),
                //new TestData(1.3f,0.6f),
                //new TestData(1.4f,0.2f),
                //new TestData(1.5f,0.5f),
        };
        //插入值
        LineChart.Inject<TestData>(data);
        //显示单位
        LineChart.ShowUnit();
    }
}