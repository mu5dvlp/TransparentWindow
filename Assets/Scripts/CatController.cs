using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CatController : MonoBehaviour
{
    void Update()
    {
        Vector3 screen_point = Input.mousePosition;
        screen_point.z = 10;

        Vector3 targetPosition = Camera.main.ScreenToWorldPoint(screen_point);
        targetPosition.z = 0;
        transform.position = targetPosition;
    }
}
