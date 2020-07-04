using Battle;
using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// Description: Character Vision
/// </summary>

public class FOWCharactorRevealer : FOWRevealer
{
    protected static HashSet<int> m_allChara = new HashSet<int>();
    protected int m_charaID;

    public static Vector3 myPosition = Vector3.zero;
    public static float myRadius = 50.5f;

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
        // TODO: In the actual project, according to the character management system and related game logic, verify the legality of the character
        // For the sake of simplicity, directly get the only character in the demo scene
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