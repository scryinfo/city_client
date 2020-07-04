using UnityEngine;
using System.Collections;
using System.Collections.Generic;

namespace LuaFramework {
    public class TimerInfo {
        public long tick;
        public bool stop;
        public bool delete;
        public Object target;
        public string className;

        public TimerInfo(string className, Object target) {
            this.className = className;
            this.target = target;
            delete = false;
        }
    }


    public class TimerManager : Manager {
        private float interval = 0;
        private List<TimerInfo> objects = new List<TimerInfo>();

        public float Interval {
            get { return interval; }
            set { interval = value; }
        }

        // Use this for initialization
        void Start() {
            StartTimer(AppConst.TimerInterval);
        }

        /// <param name="interval"></param>
        public void StartTimer(float value) {
            interval = value;
            InvokeRepeating("Run", 0, interval);
        }

        public void StopTimer() {
            CancelInvoke("Run");
        }

        /// <param name="name"></param>
        /// <param name="o"></param>
        public void AddTimerEvent(TimerInfo info) {
            if (!objects.Contains(info)) {
                objects.Add(info);
            }
        }

        /// <param name="name"></param>
        public void RemoveTimerEvent(TimerInfo info) {
            if (objects.Contains(info) && info != null) {
                info.delete = true;
            }
        }

        /// <param name="info"></param>
        public void StopTimerEvent(TimerInfo info) {
            if (objects.Contains(info) && info != null) {
                info.stop = true;
            }
        }

        /// <param name="info"></param>
        public void ResumeTimerEvent(TimerInfo info) {
            if (objects.Contains(info) && info != null) {
                info.delete = false;
            }
        }

        void Run() {
            if (objects.Count == 0) return;
            for (int i = 0; i < objects.Count; i++) {
                TimerInfo o = objects[i];
                if (o.delete || o.stop) { continue; }
                ITimerBehaviour timer = o.target as ITimerBehaviour;
                timer.TimerUpdate();
                o.tick++;
            }
          
            for (int i = objects.Count - 1; i >= 0; i--) {
                if (objects[i].delete) { objects.Remove(objects[i]); }
            }
        }
    }
}