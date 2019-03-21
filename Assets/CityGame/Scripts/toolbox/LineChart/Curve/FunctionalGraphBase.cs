using System.Collections;
using System.Collections.Generic;
using UnityEngine;
/// <summary>
/// x,y坐标轴数据
/// </summary>
public class FunctionalGraphBase:MonoBehaviour
{
    /// 
    /// 是否显示刻度
    ///
    public bool ShowScale = false;
    /// 
    /// 是否显示X轴单位
    /// 
    public bool ShowXAxisUnit = false;
    /// 
    /// 是否显示Y轴单位
    ///
    public bool ShowYAxisUnit = false;  
    /// 
    /// 是否绘制Y轴
    ///
    public bool ShowYScale = false;
    /// 
    /// X轴单位
    /// 
    public string XAxisUnit = "XUnit";
    ///
    /// Y轴单位
    /// 
    public string YAxisUnit = "YUnit";
    ///
    /// 单位字体大小
    /// 
    [Range(12, 30)] public int FontSize = 16;
    ///
    /// X.Y轴刻度字体大小
    /// 
    [Range(20, 50)] public int XYFontSize = 24;
    ///
    /// X.Y轴刻度字体颜色
    /// 
    public Color XYFontColor = Color.black;
    /// 
    /// 字体颜色
    /// 
    public Color FontColor = Color.black;
    /// 
    /// X轴刻度
    /// 
    [Range(20f, 120)] public float XScaleValue = 100f;
    /// 
    /// Y轴刻度
    /// s
    [Range(20f, 120)] public float YScaleValue = 100f;
    /// 
    /// 刻度的长度
    /// 
    [Range(2, 10)] public float ScaleLenght = 5.0f;
    /// 
    /// XY轴宽度
    ///
    [Range(2f, 20f)] public float XYAxisWidth = 2.0f;
    /// 
    /// XY轴颜色
    /// 
    public Color XYAxisColor = Color.gray;
    ///
    /// 网格Enum
    /// 
    public enum E_MeshType
    {
        None,          //没有网格
        FullLine,      //实线网格
        ImaglinaryLine //虚线网格
    } 
    /// 
    /// 网格类型
    /// 
    public E_MeshType MeshType = E_MeshType.None;
    ///
    /// 网格线段宽度
    /// 
    [Range(1.0f, 10f)] public float MeshLineWidth = 2.0f;
    /// 
    /// 网格颜色
    /// 
    public Color MeshColor = Color.gray;
    ///
    /// 虚线的长度
    ///
    [Range(0.5f, 20)] public float ImaglinaryLineWidth = 8.0f;
    ///
    /// 虚线空格长度
    ///
    [Range(0.5f, 10f)] public float SpaceingWidth = 5.0f;
    ///
    /// 线的宽度
    ///
    [Range(2f, 20f)] public float LineWidth = 2.0f;
    ///分隔线的颜色
    ///
    public Color BoundaryColor = Color.gray;
    ///
    ///最多生成线的数量
    ///
    public int MaxNum = 2;
    ///
    ///滑动最小的位置
    ///
    public Vector2 MinPos = Vector2.one;
    ///
    ///滑动最大的位置
    ///
    public Vector2 MaxPos = Vector2.one;
    ///
    ///最小的宽高
    ///
    public Vector2 MinWidth = Vector2.one;
    ///
    ///最大的宽高
    ///
    public Vector2 MaxWidth = Vector2.one;
}
