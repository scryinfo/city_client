using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using City;

public class LineChartGraph : MonoBehaviour {    
    public LineChart LineChart = null;
    public GameObject XAixs = null;
    public GameObject YXixs = null;
    public void Awake()
    {
        XAixs.SetActive(true);
        YXixs.SetActive(true);        
        //显示单位
        LineChart.ShowUnit();
    }
}