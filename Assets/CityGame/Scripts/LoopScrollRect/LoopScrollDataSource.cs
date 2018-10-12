using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

namespace UnityEngine.UI
{
    public class LoopScrollDataSource
    {
        public delegate void DlgProvideData(Transform transform, int idx);
        public delegate void DlgClearData(Transform transform);

        public DlgProvideData mProvideData = null;
        public DlgClearData mClearData = null;

        ////public void ProvideData(Transform transform, int idx) { }

        ////public void ClearData(Transform transform) { }
    }
}