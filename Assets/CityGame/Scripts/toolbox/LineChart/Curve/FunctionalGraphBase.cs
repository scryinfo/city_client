using System.Collections;
using System.Collections.Generic;
using UnityEngine;
/// <summary>
/// x,y coordinate axis data
/// </summary>
public class FunctionalGraphBase:MonoBehaviour
{
    /// 
    /// Whether to display the scale
    ///
    public bool ShowScale = false;
    /// 
    /// Whether to display X-axis units
    /// 
    public bool ShowXAxisUnit = false;
    /// 
    /// Whether to display Y-axis units
    ///
    public bool ShowYAxisUnit = false;  
    /// 
    /// Whether to draw the Y axis
    ///
    public bool ShowYScale = false;
    /// 
    /// X axis unit
    /// 
    public string XAxisUnit = "XUnit";
    ///
    /// Y-axis unit
    /// 
    public string YAxisUnit = "YUnit";
    ///
    /// Unit font size
    /// 
    [Range(12, 30)] public int FontSize = 16;
    ///
    /// X.Y axis scale font size
    /// 
    [Range(20, 50)] public int XYFontSize = 24;
    ///
    /// X.Y axis scale font color
    /// 
    public Color XYFontColor = Color.black;
    /// 
    /// font color
    /// 
    public Color FontColor = Color.black;
    /// 
    /// X axis scale
    /// 
    [Range(20f, 250)] public float XScaleValue = 100f;
    /// 
    /// Y axis scale
    /// s
    [Range(20f, 150)] public float YScaleValue = 100f;
    /// 
    /// The length of the scale
    /// 
    [Range(2, 10)] public float ScaleLenght = 5.0f;
    /// 
    /// XY axis width
    ///
    [Range(2f, 20f)] public float XYAxisWidth = 2.0f;
    /// 
    /// XY axis color
    /// 
    public Color XYAxisColor = Color.gray;
    ///
    /// Mesh Enum
    /// 
    public enum E_MeshType
    {
        None,          //No grid
        FullLine,      //Solid grid
        //ImaglinaryLine //Dotted grid
    } 
    /// 
    /// Grid type
    /// 
    public E_MeshType MeshType = E_MeshType.None;
    ///
    /// Grid line width
    /// 
    [Range(1.0f, 10f)] public float MeshLineWidth = 2.0f;
    /// 
    /// Grid color
    /// 
    public Color MeshColor = Color.gray;
    ///
    /// The length of the dotted line
    ///
    [Range(0.5f, 20)] public float ImaglinaryLineWidth = 8.0f;
    ///
    /// Dotted space length
    ///
    [Range(0.5f, 10f)] public float SpaceingWidth = 5.0f;
    ///
    /// Line width
    ///
    [Range(2f, 20f)] public float LineWidth = 2.0f;
    ///Divider color
    ///
    public Color BoundaryColor = Color.gray;
    ///
    ///Maximum number of generated lines
    ///
    public int MaxNum = 2;
    ///
    ///Minimum sliding position
    ///
    public Vector2 MinPos = Vector2.one;
    ///
    ///Sliding position
    ///
    public Vector2 MaxPos = Vector2.one;
    ///
    ///Minimum width and height
    ///
    public Vector2 MinWidth = Vector2.one;
    ///
    ///Maximum width and height
    ///
    public Vector2 MaxWidth = Vector2.one;
    ///
    ///Histogram width
    ///
    [Range(2f, 100f)] public float ChartWidth = 10f;
}
