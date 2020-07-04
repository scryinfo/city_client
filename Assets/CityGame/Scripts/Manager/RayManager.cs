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
            
            //Emit a ray from the mouse position
            ray = Camera.main.ScreenPointToRay(RayPos);
            if (Physics.Raycast(ray, out hit, Mathf.Infinity))
            {
                Debug.Log(TerrainTrans.name);
                //Determine whether the number of rows and columns is odd or even by size
                float remainderX = GetWorldScale(TerrainTrans).x * 10 / _gridSize % 2;
                float remainderZ = GetWorldScale(TerrainTrans).z * 10 / _gridSize % 2;
                //Get a rotation of the ray collision point to the ground
                Quaternion rot = Quaternion.LookRotation(hit.point - TerrainTrans.position);
                //Distance from collision point to ground
                float dist = Vector3.Distance(hit.point, TerrainTrans.position);
                //Taking ground as the coordinate origin and using the trigonometric function to calculate the coordinates of the collision point in the coordinate system
                float distX = Mathf.Sin((rot.eulerAngles.y - TerrainTrans.rotation.eulerAngles.y) * Mathf.Deg2Rad) * dist;
                float distZ = Mathf.Cos((rot.eulerAngles.y - TerrainTrans.rotation.eulerAngles.y) * Mathf.Deg2Rad) * dist;
                //Determine which quadrant of the collision point in the coordinate system where ground is the origin
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
                //Get the unit coordinates in the coordinate system where ground is the origin
                float numX = Mathf.Round((distX + (remainderX - 1) * (signX * _gridSize / 2)) / _gridSize);
                float numZ = Mathf.Round((distZ + (remainderZ - 1) * (signZ * _gridSize / 2)) / _gridSize);
                //Calculate the offset in the coordinate axis
                float offsetX = -(remainderX - 1) * signX * _gridSize;
                float offsetZ = -(remainderZ - 1) * signZ * _gridSize;
                //Adjust the coordinate system
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