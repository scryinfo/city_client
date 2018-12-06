using Battle;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 说明：角色视野
/// 
/// @by wsh 2017-05-20
/// </summary>

public class FOWCharactorRevealer : FOWRevealer
{
    protected static HashSet<int> m_allChara = new HashSet<int>();
    protected int m_charaID;

    public static Vector3 myPosition = Vector3.zero;
    public static float myRadius = 500f;

    public FOWCharactorRevealer()
    {
    }

    static public new FOWCharactorRevealer Get()
    {
        return ClassObjPool<FOWCharactorRevealer>.Get();
    }

    static public bool Contains(int charaID)
    {
        return m_allChara.Contains(charaID);
    }

    public override void OnInit()
    {
        base.OnInit();
        m_charaID = 0;
    }

    public override void OnRelease()
    {
        m_allChara.Remove(m_charaID);

        base.OnRelease();
    }

    public void InitInfo(int charaID)
    {
        m_charaID = charaID;
        m_allChara.Add(m_charaID);

        Update(0);
    }
    
    public override void Update(int deltaMS)
    {
        Vector3 position;
        float radius;
        if (!CheckIsValid(m_charaID, out position, out radius))
        {
            m_isValid = false;
        }
        else
        {
            m_position = position;
            m_radius = radius;
            m_isValid = true;
        }
    }

    static public bool CheckIsValid(int charaID)
    {
        Vector3 position;
        float radius;
        return CheckIsValid(charaID, out position, out radius);
    }

    static public bool CheckIsValid(int charaID, out Vector3 position, out float radius)
    {
        // TODO：实际项目中，根据角色管理系统和相关游戏逻辑，校验角色合法性
        // 这里为了简单，直接获取demo场景唯一的角色
        position = myPosition;
        radius = myRadius;
        return true;
    }
    public override void SetRadius(float newRadius)
    {
        myRadius = newRadius;
        m_radius = newRadius;
    }

    public override void SetPosition(Vector3 newPosition)
    {
        myPosition = newPosition;
        m_position = newPosition;
    }

}