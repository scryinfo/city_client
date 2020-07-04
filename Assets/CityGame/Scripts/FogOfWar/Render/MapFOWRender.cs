using UnityEngine;
using Battle;

public class MapFOWRender
{
    public MapFOWRender(Transform mapParent)
    {
        FOWRender render = FOWLogic.instance.CreateRender(mapParent);
        if (render != null)
        {
            // TODO: In the actual project, set the center point position according to the scene map
            // For simplicity, just center it here
            float fCenterX = 50.5f;
            float fCenterZ = 50.5f;
            float scale = FOWSystem.instance.worldSize / 128f * 2.56f;

            render.transform.position = new Vector3(fCenterX, 0f, fCenterZ);
            render.transform.eulerAngles = new Vector3(-90f, 180f, 0f);
            render.transform.localScale = new Vector3(scale, scale, 1f);
        }
    }
}
