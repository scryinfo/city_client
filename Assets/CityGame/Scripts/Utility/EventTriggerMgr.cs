

using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;


public class EventTriggerMgr : EventTrigger
{
    public delegate void PointerEventDelegate(GameObject go, PointerEventData eventData);

    public delegate void BaseEventDelegate(GameObject go, BaseEventData eventData);

    public delegate void AxisEventDelegate(GameObject go, AxisEventData eventData);

    public PointerEventDelegate onPointerEnter;
    public PointerEventDelegate onPointerExit;
    public PointerEventDelegate onPointerDown;
    public PointerEventDelegate onPointerUp;
    public PointerEventDelegate onPointerClick;
    public PointerEventDelegate onInitializePotentialDrag;
    public PointerEventDelegate onBeginDrag;
    public PointerEventDelegate onDrag;
    public PointerEventDelegate onEndDrag;
    public PointerEventDelegate onDrop;
    public PointerEventDelegate onScroll;
    public BaseEventDelegate onUpdateSelected;
    public BaseEventDelegate onSelect;
    public BaseEventDelegate onDeselect;
    public AxisEventDelegate onMove;
    public BaseEventDelegate onSubmit;
    public BaseEventDelegate onCancel;


    public static EventTriggerMgr Get(GameObject go)
    {
        EventTriggerMgr listener = go.GetComponent<EventTriggerMgr>();
        if (listener == null) listener = go.AddComponent<EventTriggerMgr>();
        return listener;
    }

    public override void OnPointerEnter(PointerEventData eventData)
    {
        if (onPointerEnter != null) onPointerEnter(gameObject, eventData);
    }

    public override void OnPointerExit(PointerEventData eventData)
    {
        if (onPointerExit != null) onPointerExit(gameObject, eventData);
    }

    public override void OnPointerDown(PointerEventData eventData)
    {
        if (onPointerDown != null) onPointerDown(gameObject, eventData);
    }

    public override void OnPointerUp(PointerEventData eventData)
    {
        if (onPointerUp != null) onPointerUp(gameObject, eventData);
    }

    public override void OnPointerClick(PointerEventData eventData)
    {
        if (onPointerClick != null) onPointerClick(gameObject, eventData);
    }

    public override void OnInitializePotentialDrag(PointerEventData eventData)
    {
        if (onInitializePotentialDrag != null) onInitializePotentialDrag(gameObject, eventData);
    }

    public override void OnBeginDrag(PointerEventData eventData)
    {
        if (onBeginDrag != null) onBeginDrag(gameObject, eventData);
    }

    public override void OnDrag(PointerEventData eventData)
    {
        if (onDrag != null) onDrag(gameObject, eventData);
    }

    public override void OnEndDrag(PointerEventData eventData)
    {
        if (onEndDrag != null) onEndDrag(gameObject, eventData);
    }

    public override void OnDrop(PointerEventData eventData)
    {
        if (onDrop != null) onDrop(gameObject, eventData);
    }

    public override void OnScroll(PointerEventData eventData)
    {
        if (onScroll != null) onScroll(gameObject, eventData);
    }

    public override void OnUpdateSelected(BaseEventData eventData)
    {
        if (onUpdateSelected != null) onUpdateSelected(gameObject, eventData);
    }

    public override void OnSelect(BaseEventData eventData)
    {
        if (onSelect != null) onSelect(gameObject, eventData);
    }

    public override void OnDeselect(BaseEventData eventData)
    {
        if (onDeselect != null) onDeselect(gameObject, eventData);
    }

    public override void OnMove(AxisEventData eventData)
    {
        if (onMove != null) onMove(gameObject, eventData);
    }

    public override void OnSubmit(BaseEventData eventData)
    {
        if (onSubmit != null) onSubmit(gameObject, eventData);
    }

    public override void OnCancel(BaseEventData eventData)
    {
        if (onCancel != null) onCancel(gameObject, eventData);
    }
}
