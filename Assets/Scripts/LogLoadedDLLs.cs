using System;
using System.Linq;
using UnityEngine;
using System.Reflection;

public class LogLoadedDLLs : MonoBehaviour
{
    void Start()
    {
        LogAllLoadedDLLs();
    }

    private void LogAllLoadedDLLs()
    {
        // 現在のアプリケーションドメインにロードされているすべてのアセンブリを取得
        var assemblies = AppDomain.CurrentDomain.GetAssemblies();

        // アセンブリごとにDLLの情報をログに記録
        foreach (var assembly in assemblies)
        {
            try
            {
                string location = assembly.Location;
                if (!string.IsNullOrEmpty(location))
                {
                    Debug.Log($"Loaded DLL: {location}");
                }
            }
            catch (NotSupportedException)
            {
                // アセンブリが動的に生成された場合や、ロケーションがサポートされていない場合に例外が発生します。
                Debug.Log($"Loaded DLL: {assembly.FullName} (location not supported)");
            }
        }


    }
}