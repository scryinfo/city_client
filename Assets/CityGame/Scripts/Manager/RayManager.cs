using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using UnityEngine.UI;
using LuaInterface;

namespace LuaFramework
{
    public class RayManager : Manager
    {
        private float _gridSize = 1f;
        private Transform TerrainTrans;
        Ray ray;
        RaycastHit hit;
        public Vector3 GetCoordinateByVector3(Vector3 RayPos)
        {
            if (null == TerrainTrans)
            {
                TerrainTrans = GameObject.Find("Terrain").transform;
            }
            
            //从鼠标位置发射一条射线
            ray = Camera.main.ScreenPointToRay(RayPos);
            if (Physics.Raycast(ray, out hit, Mathf.Infinity))
            {
                Debug.Log(TerrainTrans.name);
                //通过大小来判断行数和列数是奇数还是偶数
                float remainderX = GetWorldScale(TerrainTrans).x * 10 / _gridSize % 2;
                float remainderZ = GetWorldScale(TerrainTrans).z * 10 / _gridSize % 2;
                //获取射线碰撞点到ground的一个旋转量
                Quaternion rot = Quaternion.LookRotation(hit.point - TerrainTrans.position);
                //碰撞点到ground的距离
                float dist = Vector3.Distance(hit.point, TerrainTrans.position);
                //以ground为坐标原点为坐标系，通过三角函数计算出碰撞点在坐标系中的坐标
                float distX = Mathf.Sin((rot.eulerAngles.y - TerrainTrans.rotation.eulerAngles.y) * Mathf.Deg2Rad) * dist;
                float distZ = Mathf.Cos((rot.eulerAngles.y - TerrainTrans.rotation.eulerAngles.y) * Mathf.Deg2Rad) * dist;
                //判断碰撞点在ground为原点的坐标系中的哪一象限
                float signX = 1;
                float signZ = 1;
                if (distX != 0)
                {
                    signX = distX / Mathf.Abs(distX);
                }
                if (distZ != 0)
                {
                    signZ = distZ / Mathf.Abs(distZ);
                }
                //获取在ground为原点的坐标系中的单位坐标
                float numX = Mathf.Round((distX + (remainderX - 1) * (signX * _gridSize / 2)) / _gridSize);
                float numZ = Mathf.Round((distZ + (remainderZ - 1) * (signZ * _gridSize / 2)) / _gridSize);
                //计算出在坐标轴中的偏移量
                float offsetX = -(remainderX - 1) * signX * _gridSize;
                float offsetZ = -(remainderZ - 1) * signZ * _gridSize;
                //调整坐标系，
                Vector3 p = TerrainTrans.TransformDirection(new Vector3(numX, 0, numZ) * _gridSize);
                p += TerrainTrans.TransformDirection(new Vector3(offsetX, 0, offsetZ));
                return p + TerrainTrans.position;
            }
            return Vector3.zero;
        }

        private Vector3 GetWorldScale(Transform transform)
        {
            Vector3 worldScale = transform.localScale;
            Transform parent = transform.parent;

            while (parent != null)
            {
                worldScale = Vector3.Scale(worldScale, parent.localScale);
                parent = parent.parent;
            }
            return worldScale;
        }

    }
}