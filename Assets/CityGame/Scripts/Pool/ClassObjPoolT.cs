using System;
using System.Collections.Generic;

public class ClassObjPool<T> : ClassObjPoolBase where T : PooledClassObject, new()
{
    // Optimization description: using Queue or BetterList is more efficient than using List
    // Rule of thumb: Don't use List to simulate queues
    private static ClassObjPool<T> instance;
    protected uint reqSeq = 0;
    protected Queue<T> pool = new Queue<T>(32);

    public static T Get()
    {
        if (instance == null)
        {
            instance = new ClassObjPool<T>();
            AddInstance(instance);
        }
        T local;
        if (instance.pool.Count > 0)
        {
            local = instance.pool.Dequeue();
        }
        else
        {
            local = Activator.CreateInstance<T>();
        }
        instance.reqSeq++;
        local.usingSeq = instance.reqSeq;
        local.holder = instance;
        local.OnInit();
        return local;
    }

    public override void Release(PooledClassObject obj)
    {
        T item = obj as T;
        obj.usingSeq = 0;
        pool.Enqueue(item);
    }

    protected override void OnDispose()
    {
        while (pool.Count > 0)
        {
            pool.Dequeue().Dispose();
        }
    }
}