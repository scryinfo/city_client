

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;


public class CalendarPage : MonoBehaviour
{
    ////[SerializeField]
    ////private Transform mDayRootTran;  //dayItem parent object
    ////[SerializeField]
    ////private Text mYearAndMonthText;  //Text box showing year and month

    ////public Button subMonthBtn;
    ////public Button addMonthBtn;

    ////private Vector3Int mCurrentDate = Vector3Int.zero;
    ////private List<CalendarDayItem> mDayItems = new List<CalendarDayItem>();

    ////private void Start()
    ////{
    ////    for (int i = 0; i < mDayRootTran.childCount; i++)
    ////    {
    ////        GameObject go = mDayRootTran.GetChild(i).gameObject;
    ////        mDayItems.Add(go.GetComponent<CalendarDayItem>());
    ////    }

    ////    mCurrentDate = new Vector3Int(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day);
    ////    UpdateView();

    ////    subMonthBtn.onClick.AddListener(LastMonthFunc);
    ////    addMonthBtn.onClick.AddListener(NextMonthFunc);
    ////}

    //////Update interface display
    ////private void UpdateView()
    ////{
    ////    int days = GetDaysByMonth(mCurrentDate.x, mCurrentDate.y);
    ////    DayOfWeek week = GetWeekNumByDay(mCurrentDate.x, mCurrentDate.y);
    ////    int dayWeek = (int)week;

    ////    mYearAndMonthText.text = string.Format("{0}年{1}月", mCurrentDate.x, mCurrentDate.y);

    ////    //Item of the month
    ////    for (int i = 0; i < mDayItems.Count; i++)
    ////    {
    ////        if (i < dayWeek || i >= dayWeek + days)
    ////        {
    ////            mDayItems[i].Hide();
    ////        }

    ////        if (i >= dayWeek && i < dayWeek + days)
    ////        {
    ////            mDayItems[i].SetDay(new Vector3Int(mCurrentDate.x, mCurrentDate.y, i - dayWeek + 1));
    ////            mDayItems[i].NoSelect();

    ////            if (i - dayWeek + 1 == DateTime.Now.Day && mCurrentDate.x == DateTime.Now.Year && mCurrentDate.y == DateTime.Now.Month)
    ////                mDayItems[i].Selected();

    ////            mDayItems[i].Show();
    ////        }
    ////    }
    ////}

    ////////////////////////////////////////////////
    ////private void LastMonthFunc()
    ////{
    ////    mCurrentDate.y--;

    ////    if (mCurrentDate.y < 1)
    ////    {
    ////        mCurrentDate.y = 12;
    ////        mCurrentDate.x--;
    ////    }
    ////    UpdateView();
    ////}

    ////private void NextMonthFunc()
    ////{
    ////    mCurrentDate.y++;

    ////    if (mCurrentDate.y > 12)
    ////    {
    ////        mCurrentDate.y = 1;
    ////        mCurrentDate.x++;
    ////    }
    ////    UpdateView();
    ////}

    //////Get the number of days in a year and month
    ////private int GetDaysByMonth(int year, int month)
    ////{
    ////    return DateTime.DaysInMonth(year, month);
    ////}

    ////// Return to the week of month 1 according to the year and month
    ////private DayOfWeek GetWeekNumByDay(int year, int month)
    ////{
    ////    return DateTime.Parse(year + "/" + month + "/" + 1).DayOfWeek;
    ////}
}
