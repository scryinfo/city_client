

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using DG.Tweening;


public class ScrollCenter : MonoBehaviour
{
    private RectTransform mContent;
    public GameObject item;
    private ScrollRect mScroll;

    private int mTotalCount;

    private void Start()
    {
        mScroll.onValueChanged.AddListener(OnScroll);
    }

    private void OnScroll(Vector2 v2)
    {
        int index = Mathf.Abs((int)Mathf.Round(mContent.localPosition.x / 300));
        ChangeScale(index);
    }

    private void InitData(int totalCount)
    {
        mTotalCount = totalCount;
    }

    private void ChangeScale(int index)
    {
        for (int i = 0; i < mTotalCount; i++)
        {
            if (i == index)
            {
                //content.GetChild(i).Find("Image").localScale = new Vector3(1f, 1f, 1f);
                //content.GetChild(i).Find("Image").DOScale(new Vector3(1f, 1f, 1f), 0.1f);
            }
            else
            {
                //content.GetChild(i).Find("Image").localScale = new Vector3(0.6f, 0.6f, 0.6f);
                //content.GetChild(i).Find("Image").DOScale(new Vector3(0.6f, 0.6f, 0.6f), 0.1f);
            }
        }
    }

    // Update is called once per frame
    private void Update()
    {
        if (Input.GetMouseButtonUp(0))
        {
            ////int index = Mathf.Abs((int)Mathf.Round(content.localPosition.x / 300));
            ////Vector3 v3 = content.localPosition;
            ////content.localPosition = new Vector3(-index * 300, v3.y, v3.z);
        }
    }
}
