using UnityEngine;

/// <summary>
/// Description: Base class of view object
/// </summary>

public class FOWRevealer : PooledClassObject, IFOWRevealer
{
    // Share data
    protected bool m_isValid;
    protected Vector3 m_position;
    protected float m_radius;

    public FOWRevealer()
    {
    }

    static public FOWRevealer Get()
    {
        return ClassObjPool<FOWRevealer>.Get();
    }

    public override void OnInit()
    {
        m_position = Vector3.zero;
        m_radius = 0f;
        m_isValid = false;
    }

    public override void OnRelease()
    {
        m_isValid = false;
    }

    public virtual Vector3 GetPosition()
    {
        return m_position;
    }

    public virtual float GetRadius()
    {
        return m_radius;
    }
    public virtual void SetRadius(float newRadius)
    {
        m_radius = newRadius;
    }

    public virtual void SetPosition(Vector3 newPosition)
    {
        m_position = newPosition;
    }

    public bool IsValid()
    {
        return m_isValid;
    }

    public virtual void Update(int deltaMS)
    {
        // Update all shared data, m_isValid last update
    }
}
