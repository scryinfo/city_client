using UnityEngine;
using LuaInterface;
using System.Collections.Generic;

//Lua components
public class LuaComponent : MonoBehaviour
{
    //Lua environment, you need to assign it before use
    public static LuaState s_luaState;

//Function name definition
protected static class FuncName
{
    public static readonly string Awake = "Awake";
    public static readonly string OnEnable = "OnEnable";
    public static readonly string Start = "Start";
    public static readonly string Update = "Update";
    public static readonly string LateUpdate = "LateUpdate";
    public static readonly string OnDisable = "OnDisable";
    public static readonly string OnDestroy = "OnDestroy";
};

//Lua path, no need to fill in the name, it can be a bundle
[Tooltip("script path")]
public string LuaPath;

    public void reAwake(string luaPath)
    {
        LuaPath = luaPath;
        if (Init())
            CallLuaFunction(FuncName.Awake, mSelfTable, gameObject);
    }

    //Pre-stored functions improve efficiency
    protected Dictionary<string, LuaFunction> mDictFunc = new Dictionary<string, LuaFunction>();

//Lua table, to be released when the gameObject is destroyed
private LuaTable mSelfTable = null;

//Initialization function, can be rewritten, other has been added
protected virtual bool Init()
{
    if (s_luaState == null)
    {
            return false;
    }

        if (string.IsNullOrEmpty(LuaPath))
        {
            return false;
        }


        //object[] luaRet = s_luaState.DoFile<object[]>(LuaPath);        
        //         if (luaRet == null || luaRet.Length < 1)
        //     {
        //         Debug.LogError("Lua must return a table " + LuaPath);
        //         return false;
        //     }
        // mSelfTable = luaRet[0] as LuaTable;
        object luaRet = s_luaState.DoFile<object>(LuaPath);
        if (luaRet == null )
        {
               Debug.LogError("Lua must return a table " + LuaPath);
               return false;
        }
        mSelfTable = luaRet as LuaTable;
    if (null == mSelfTable)
    {
        Debug.LogError("null == luaTable  " + LuaPath);
        return false;
    }

    AddFunc(FuncName.Awake);
    AddFunc(FuncName.OnEnable);
    AddFunc(FuncName.Start);
    AddFunc(FuncName.Update);
    AddFunc(FuncName.LateUpdate);
    AddFunc(FuncName.OnDisable);
    AddFunc(FuncName.OnDestroy);

    return true;
}

//Save function
protected bool AddFunc(string name)
{
    var func = mSelfTable.GetLuaFunction(name);
    if (null == func)
    {
        return false;
    }
    mDictFunc.Add(name, func);
    return true;
}

//Call functions
protected void CallLuaFunction(string name, params object[] args)
{
    LuaFunction func = null;
    if (mDictFunc.TryGetValue(name, out func))
    {
        func.BeginPCall();
        foreach (var o in args)
        {
            func.Push(o);
        }
        func.PCall();
        func.EndPCall();
    }
}

void Awake()
{
    /*if(Init())
        CallLuaFunction(FuncName.Awake, mSelfTable, gameObject);*/
}

void OnEnable()
{
    CallLuaFunction(FuncName.OnEnable, mSelfTable, gameObject);
}

void Start()
{
    CallLuaFunction(FuncName.Start, mSelfTable, gameObject);
}

void Update()
{
    CallLuaFunction(FuncName.Update, mSelfTable, gameObject);
}

void LateUpdate()
{
    CallLuaFunction(FuncName.LateUpdate, mSelfTable, gameObject);
}

    void OnDisable()
{
    if (mSelfTable == null) {
            return;
        }
    CallLuaFunction(FuncName.OnDisable, mSelfTable, gameObject);
}

void OnDestroy()
{
        if (mSelfTable == null) {
            return;
        }

    CallLuaFunction(FuncName.OnDestroy, mSelfTable, gameObject);

    //Remember to release resources
    foreach (var pair in mDictFunc)
    {
        pair.Value.Dispose();
    }
    mDictFunc.Clear();
    if (null != mSelfTable)
    {
        mSelfTable.Dispose();
        mSelfTable = null;
    }
}

}