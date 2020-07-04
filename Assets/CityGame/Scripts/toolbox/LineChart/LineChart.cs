using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

namespace City
{
    public class LineChart : MaskableGraphic
    {        
        public Transform parent;

        public enum LineChartType
        {
            //Polyline
            LineChart
        }
        [Header("线图表类型设置")]
        [SerializeField]
        public LineChartType lineChartType = LineChartType.LineChart;

        private ILineChart LineChartCreator
        {
            get
            {
                //Instance corresponding factory drawing according to type
                switch (lineChartType)
                {
                    case LineChartType.LineChart:
                        return new LineChartCurve();
                    default:
                        return new LineChartCurve();
                }
            }
        }
        [Header("线基础数据设置")]
        [SerializeField]
        public LineChartData LineChartBasis = null;
        private LineChartDataMediator m_dataMediator = null;
        protected override void OnPopulateMesh(VertexHelper vh)
        {
            vh.Clear();
            if (LineChartBasis.Lines.Count.Equals(0))
                return;
            var rect = base.GetPixelAdjustedRect();//!!!!!!!!!!!!!!!!!!!!!Get the width and height of the screen!!!!!!!!!!!!!!!!!!!!!!!!!
            if (LineChartBasis.Lines.Count == 11)
            {
                rect.width = 500;
            }
            //Call factory drawing
            LineChartCreator.DrawLineChart(vh, rect, LineChartBasis);
            //Debug.Log("!!!!!!!!!!!The length is" + LineChartBasis.Lines.Count);
            //Debug.Log("!!!!!!!!!!!rect" + rect);
        }
        public void Refresh()
        {
            OnEnable();
        }
        private List<GameObject> m_units = new List<GameObject>();
        private void ClearUnit()
        {
            foreach (GameObject mUnit in m_units)
            {
                GameObject.Destroy(mUnit);
            }
        }
        public void ShowUnit()
        {
            LineChartBasis.XUnitTemplate.gameObject.SetActive(false);
            LineChartBasis.YUnitTemplate.gameObject.SetActive(false);
            if (!LineChartBasis.IsShowUnit)
            {
                return;
            }
            ClearUnit();
            Vector2 size = GetPixelAdjustedRect().size;
            Vector2 origin = new Vector2(-size.x / 2.0f, -size.y / 2.0f);
            //Y-axis text position
            if (LineChartBasis.XUnitTemplate != null)
            {
                for (float y = 0, count = 0; y < size.y; y += LineChartBasis.MeshCellYSize, count++)
                {
                    float value = count * LineChartBasis.MeshCellYSize;
                    GeneratorUnitY(LineChartBasis.XUnitTemplate,
                            origin + new Vector2(0, count * LineChartBasis.MeshCellYSize) + new Vector2(-35, 0)).text = value.ToString();
                }
            }
            //X-axis text position
            if (LineChartBasis.YUnitTemplate != null)
            {
                for (float x = 0, count = 0; x < size.x; x += LineChartBasis.MeshCellXSize, count++)
                {
                    float value = count * LineChartBasis.MeshCellXSize;
                    GeneratorUnit(LineChartBasis.YUnitTemplate,
                            origin + new Vector2(count * LineChartBasis.MeshCellXSize, size.y) + new Vector2(10, -224)).text = GetWeek((int)count);
                }
            }
        }
        /// <summary>
        /// Create text
        /// </summary>
        /// <param name="prefab"></param>
        /// <param name="position"></param>
        /// <returns></returns>
        public Text GeneratorUnit(Text prefab, Vector3 position)
        {
            Text go = GameObject.Instantiate(prefab);
            go.gameObject.SetActive(true);
            go.transform.SetParent(transform);
            go.transform.localPosition = position;
            go.transform.localScale = Vector3.one;
            m_units.Add(go.gameObject);
            return go;
        }
        public Text GeneratorUnitY(Text prefab, Vector3 position)
        {
            Text go = GameObject.Instantiate(prefab);
            go.gameObject.SetActive(true);
            go.transform.SetParent(parent);
            go.transform.localPosition = position;
            go.transform.localScale = Vector3.one;
            m_units.Add(go.gameObject);
            return go;
        }
        //X-axis text
        string GetWeek(int day)
        {
            string week = null;
            switch (day)
            {
                case 0:
                    return "周一";
                case 1:
                    return "周二";
                case 2:
                    return "周三";
                case 3:
                    return "周四";
                case 4:
                    return "周五";
                case 5:
                    return "周六";
                case 6:
                    return "周日";
                default:
                    return week;
            }
        }
        #region 数据接口
        public void Inject<T>(IList<T> vertexs)
        {
            if (m_dataMediator == null)
                m_dataMediator = new LineChartDataMediator();
            LineChartBasis.AddLine(m_dataMediator.Inject(vertexs), Color.white);
        }

        public void InjectDatas(Vector2[]  vertexs, Color color)
        {
            if (m_dataMediator == null)
                m_dataMediator = new LineChartDataMediator();
            LineChartBasis.AddLine(vertexs, color);
        }

        public void InjectDatas(IList<Vector2> vertexs, Color color)
        {
            if (m_dataMediator == null)
                m_dataMediator = new LineChartDataMediator();
            LineChartBasis.AddLine(vertexs, color);
        }

        /// <summary>
        /// Replace polyline data
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="id"></param>
        /// <param name="vertexs"></param>
        //public void Replace<T>(int id, IList<T> vertexs)
        //{
        //    Replace(new int[] { id }, new IList<T>[] { vertexs });
        //}
        /// <summary>
        /// Replace polyline data
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="ids"></param>
        /// <param name="vertexs"></param>
        //public void Replace<T>(int[] ids,IList<T>[] vertexs)
        //{
        //    LineChartBasis.ReplaceLines(ids, m_dataMediator.Inject(vertexs));
        //    OnEnable();
        //}
        /// <summary>
        /// Streaming vertex data
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="id"></param>
        /// <param name="vertexs"></param>
        //public void InjectVertexStream<T>(int id,IList<T> vertexs)
        //{
        //    IList<Vector2> vertex = m_dataMediator.Inject(vertexs);
        //    StartCoroutine(StreamInject(id, vertex));
        //}

        //private IEnumerator StreamInject(int id, IList<Vector2> vertexs)
        //{
        //    for (int m = 0; m < vertexs.Count; m++)
        //    {
        //        IList<Vector2> oldVertexs = LineChartBasis.GetLine(id);
        //        var last = oldVertexs[oldVertexs.Count - 1];
        //        oldVertexs.Add(new Vector2(last.x + 0.1f, vertexs[m].y));
        //        var startOffset = oldVertexs[1].y - oldVertexs[0].y;
        //        var endOffset = oldVertexs[oldVertexs.Count - 1].y - oldVertexs[oldVertexs.Count - 2].y;
        //        for (int i = 0; i <= 10; i++)
        //        {
        //            IList<Vector2> newVertexs = new List<Vector2>();
        //            newVertexs.Add(new Vector2(0,oldVertexs[0].y + i * 0.1f * startOffset));
        //            for (int j = 0; j < oldVertexs.Count - 2; j++)
        //                newVertexs.Add(oldVertexs[j + 1] - new Vector2(0.01f * i, 0));
        //            newVertexs.Add(new Vector2(1, oldVertexs[oldVertexs.Count - 2].y + 0.1f * i * endOffset));
        //            LineChartBasis.ReplaceLines(new int[] { id},new IList<Vector2>[] { newVertexs});
        //            OnEnable();
        //            if (i.Equals(10))
        //            {
        //                newVertexs.RemoveAt(0);
        //                LineChartBasis.ReplaceLines(new int[] { id },new IList<Vector2>[] { newVertexs});
        //            }
        //            Debug.Log("Streaming vertex data");
        //            yield return new WaitForSeconds(0.05f);
        //        }
        //    }
        //}
        #endregion
    }
}
    
