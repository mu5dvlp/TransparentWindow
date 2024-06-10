using UnityEngine;
using System.Runtime.InteropServices;

public class SystemWindowManager : MonoBehaviour
{
#if UNITY_STANDALONE_OSX
    [DllImport("__Internal")] private static extern void MakeWindowTransparent();

    [RuntimeInitializeOnLoadMethod]
    static void Initialize()
    {
        MakeWindowTransparent();
    }
#endif
}
