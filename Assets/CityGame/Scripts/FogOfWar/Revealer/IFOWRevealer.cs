using UnityEngine;

/// <summary>
/// Description: The interface that the view object needs to implement, providing shared data and operations on the main thread and sub-thread
///
/// Note: In multi-thread synchronization and mutual exclusion issues:
/// 1) Due to the game performance, there is no need to consider the game frame synchronization when the child thread is refreshed
/// 2) Similarly, for all data of a view object, there is no need to guarantee the consistency of data when reading and writing
/// 3) Only simple value types are used for shared data (very important: you cannot fetch data on the game logic body in a child thread, such as Charactor)
/// Following the above principles can ignore all locking operations due to consideration of synchronization and mutual exclusion
/// </summary>

public interface IFOWRevealer
{
    // Interface for FOWSystem
    bool IsValid();
    Vector3 GetPosition();
    float GetRadius();

    // Interface for FOWLogic to maintain data and its validity
    void Update(int deltaMS);
    void Release();

    void SetRadius(float newRadius);

    void SetPosition(Vector3 newPosition);

}
