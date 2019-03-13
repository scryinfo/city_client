using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.UI;

public class Slide : MonoBehaviour, IPointerDownHandler, IPointerUpHandler
{
    private bool isDown = false;
    Vector3 vo;
    Vector3 vn;
    float width;
    Vector2 size;
    Vector3 position;
    private FunctionalGraphBase GraphBase;
    private List<Vector2[]> coordinate = new List<Vector2[]>();
    public string path;

    private void Start()
    {
        GraphBase = transform.GetComponent<FunctionalGraphBase>();
        width = gameObject.GetComponent<RectTransform>().rect.width;
        size = gameObject.GetComponent<RectTransform>().sizeDelta;
        position = gameObject.GetComponent<RectTransform>().localPosition;
        //string[] str = { "1","2","3","4","5","6","7","8" };
        //SetXScaleValue(str);
        //List<Vector3[]> it = new List<Vector3[]>();
        //Vector3[] v1 = { new Vector2(300, 100), new Vector2(200, 0), new Vector2(100, 300), new Vector2(0, 200) };
        //Vector3[] v2 = { new Vector2(300, 200), new Vector2(200, 100), new Vector2(100, 250), new Vector2(0, 300) };
        //Vector3[] v3 = { new Vector2(300, 300), new Vector2(200, 50), new Vector2(100, 150), new Vector2(0, 100) };
        //it.Add(v1);
        //it.Add(v2);
        //it.Add(v3);

        //List<Color> ScaleColor = new List<Color>();
        //ScaleColor.Add(new Color(53 / 255f, 218 / 255f, 233 / 255f, 255 / 255f));
        //ScaleColor.Add(new Color(233 / 255f, 34 / 255f, 104 / 255f, 255 / 255f));
        //ScaleColor.Add(new Color(21 / 255f, 48 / 255f, 233 / 255f, 255 / 255f));
        //SetCoordinate(it, ScaleColor);
    }
    public void OnPointerDown(PointerEventData eventData)
    {
        vo = Input.mousePosition;
        isDown = true;
    }

    public void OnPointerUp(PointerEventData eventData)
    {
        isDown = false;
    }
    private void Update()
    {
        if (isDown)
        {
            vn = Input.mousePosition;
            float dis = (vn.x - vo.x);
            vo = vn;
            gameObject.GetComponent<RectTransform>().localPosition += new Vector3(dis, 0, 0);
            gameObject.GetComponent<RectTransform>().sizeDelta += new Vector2(-dis * 2.0f, 0);
            if (gameObject.GetComponent<RectTransform>().rect.width <= width - 10.0f)
            {
                isDown = false;
                gameObject.GetComponent<RectTransform>().sizeDelta = size;
                gameObject.GetComponent<RectTransform>().localPosition = position;
            }
        } 
    }
    public void SetXScaleValue(string[] str ,int value)
    {
        for (int i = 0; i < str.Length; i++)
        {
           GameObject obj = Resources.Load<GameObject>(path);
           GameObject gameObject = Instantiate(obj);
           RectTransform go = gameObject.GetComponent<RectTransform>();
           go.transform.parent = transform;
           go.localScale = Vector3.one;
           go.localPosition = new Vector3(value * i - 60, -60, 0);
           go.GetComponent<Text>().text = str[i];
        }
    }
    /// <summary>
    /// 将点的坐标显示出来
    /// </summary>
    public void SetCoordinate(Vector2[] str,Color color)
    {
        for (int i = 0; i < str.Length; i++)
        {
            GameObject obj = Resources.Load<GameObject>(path);
            GameObject gameObject = Instantiate(obj);
            RectTransform go = gameObject.GetComponent<RectTransform>();
            go.transform.parent = transform;
            go.localScale = Vector3.one;
            go.localPosition = str[i];
            go.GetComponent<Text>().color = color;
            go.GetComponent<Text>().text = str[i].y.ToString();
            go.GetComponent<Text>().alignment = TextAnchor.LowerLeft;
        }
    }

}
