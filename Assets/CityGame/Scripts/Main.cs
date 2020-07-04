using UnityEngine;
using System.Collections;

namespace LuaFramework {

    /// <summary>
    /// </summary>
    public class Main : MonoBehaviour {

        void Start() {
            AppFacade.Instance.StartUp();   //Start the game
        }
    }
}