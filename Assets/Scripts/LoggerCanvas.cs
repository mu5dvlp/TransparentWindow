using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;

public class LoggerCanvas : MonoBehaviour
{
    [HideInInspector] public Canvas canvas;
    [SerializeField] TMP_Text log_tmpText;

    void Awake()
    {
        canvas = FindAnyObjectByType<Canvas>();
    }

    public void AddLog(string text)
    {
        log_tmpText.text += text + "\n\n";
    }
}
