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
    public string path;
    private List<GameObject> XScaleValue = new List<GameObject>();
    public  List<GameObject> Coordinate = new List<GameObject>();
    private int count = 0;        //生成线的次数
    private Dictionary<int, List<GameObject>> dicGo = new Dictionary<int, List<GameObject>>();

    private void Start()
    {
        GraphBase = transform.GetComponent<FunctionalGraphBase>();
        width = gameObject.GetComponent<RectTransform>().rect.width;
        size = gameObject.GetComponent<RectTransform>().sizeDelta;
        position = gameObject.GetComponent<RectTransform>().localPosition;
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
            gameObject.GetComponent<RectTransform>().sizeDelta += new Vector2(-dis, 0);
            if (gameObject.GetComponent<RectTransform>().rect.width <= GraphBase.MinWidth.x -10)
            {
                isDown = false;
                gameObject.GetComponent<RectTransform>().sizeDelta = GraphBase.MinWidth;
                gameObject.GetComponent<RectTransform>().anchoredPosition3D = GraphBase.MinPos;
            }
            if (gameObject.GetComponent<RectTransform>().rect.width >= GraphBase.MaxWidth.x + 10)
            {
                isDown = false;
                gameObject.GetComponent<RectTransform>().anchoredPosition3D = GraphBase.MaxPos;
                gameObject.GetComponent<RectTransform>().sizeDelta = GraphBase.MaxWidth;
                
            }
        } 
    }
    public void SetXScaleValue(string[] str ,int value )
    {
        if (str.Length > XScaleValue.Count)
        {
            if (XScaleValue.Count != 0)
            {
                for (int i = 1; i < XScaleValue.Count; i++)
                {
                    XScaleValue[i-1].transform.localPosition = new Vector3(value * i, -60, 0);
                    XScaleValue[i-1].GetComponent<Text>().text = str[i];
                }
            }
            for (int i = XScaleValue.Count + 1; i < str.Length; i++)
            {
                GameObject obj = Resources.Load<GameObject>(path);
                GameObject gameObject = Instantiate(obj);
                RectTransform go = gameObject.GetComponent<RectTransform>();
                go.transform.parent = transform;
                go.localScale = Vector3.one;
                go.localPosition = new Vector3(value * i, -60, 0);
                go.GetComponent<Text>().text = str[i];
                XScaleValue.Add(go.gameObject);
            }
        }
        else
        {
            for (int i = 1; i < str.Length; i++)
            {
                XScaleValue[i-1].transform.localPosition = new Vector3(value * i - 60, -60, 0);
                XScaleValue[i-1].GetComponent<Text>().text = str[i];
            }
        }      
    }
    /// <summary>
    /// 将点的坐标显示出来
    /// </summary>
    public void SetCoordinate(Vector2[] str,Vector2[] value, Color color,int id)
    {
        List<GameObject> temp = new List<GameObject>();
        count++;
        if (Coordinate.Count >= (str.Length -1) * GraphBase.MaxNum)
        {
          
            if (count % GraphBase.MaxNum == 0)
            { 
                if (!dicGo.ContainsKey(id))
                {
                    for (int i = 1; i < str.Length; i++)
                    {
                        Coordinate[i + (str.Length - 1) * (GraphBase.MaxNum - 1) - 1].transform.localPosition = str[i] + new Vector2(0, 10f);
                        Coordinate[i + (str.Length - 1) * (GraphBase.MaxNum - 1) - 1].transform.localScale = Vector3.one;
                        Coordinate[i + (str.Length - 1) * (GraphBase.MaxNum - 1) - 1].GetComponent<Text>().color = color;
                        Coordinate[i + (str.Length - 1) * (GraphBase.MaxNum - 1) - 1].GetComponent<Text>().text = value[i].y.ToString();
                        temp.Add(Coordinate[i + (str.Length - 1) * (GraphBase.MaxNum - 1) - 1]);
                    }
                    dicGo.Add(id, temp);
                }
                else
                {
                    foreach (var item in dicGo[id])
                    {
                        item.transform.localScale = Vector3.zero;
                    }
                    dicGo.Remove(id);
                }
            }
            else
            {
            
                if (!dicGo.ContainsKey(id))
                {
                    for (int i = 1; i < str.Length; i++)
                    {
                        Coordinate[i + (str.Length - 1) * (count % GraphBase.MaxNum - 1) - 1].transform.localPosition = str[i] + new Vector2(0, 10f);
                        Coordinate[i + (str.Length - 1) * (count % GraphBase.MaxNum - 1) - 1].transform.localScale = Vector3.one;
                        Coordinate[i + (str.Length - 1) * (count % GraphBase.MaxNum - 1) - 1].GetComponent<Text>().color = color;
                        Coordinate[i + (str.Length - 1) * (count % GraphBase.MaxNum - 1) - 1].GetComponent<Text>().text = value[i].y.ToString();
                        temp.Add(Coordinate[i + (str.Length - 1) * (count % GraphBase.MaxNum - 1) - 1]);
                    }
                    dicGo.Add(id, temp);
                }
                else
                {
                    foreach (var item in dicGo[id])
                    {
                        item.transform.localScale = Vector3.zero;
                    }
                    dicGo.Remove(id);
                }
            }           
        }
        else
        {
           
            if (!dicGo.ContainsKey(id))
            {
                for (int i = 1; i < str.Length; i++)
                {
                    GameObject obj = Resources.Load<GameObject>(path);
                    GameObject gameObject = Instantiate(obj);
                    RectTransform go = gameObject.GetComponent<RectTransform>();
                    go.transform.parent = transform;
                    go.localScale = Vector3.one;
                    go.GetComponent<Text>().alignment = TextAnchor.LowerCenter;
                    go.localPosition = str[i] + new Vector2(0,10f);
                    go.GetComponent<Text>().color = color;
                    go.GetComponent<Text>().text = value[i].y.ToString();
                    Coordinate.Add(go.gameObject);
                    temp.Add(go.gameObject);

                }
                dicGo.Add(id, temp);
            }
            else
            {
                foreach (var item in dicGo[id])
                {
                    item.transform.localScale = Vector3.zero;
                }
                dicGo.Remove(id);
            }
        }
        
    }
    public void Close()
    {
        foreach (var item in Coordinate)
        {
            item.transform.localScale = Vector3.zero;
        }
        dicGo.Clear();
    }

}
