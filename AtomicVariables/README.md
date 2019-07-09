# AtomicVariables

## `AtomicVariables`
Attempt to create atomic variables by leveraging a queue.

[`FailingAtomic`](./AtomicVariables/AtomicVariables/AtomicVariables/FailingAtomic.swift) describes the issue of using the set accessors for mutability.

[`Atomic`](./AtomicVariables/AtomicVariables/AtomicVariables/Atomic.swift) provides a working approach to thread-safe mutability.

[`ConcurrentAtomic`](./AtomicVariables/AtomicVariables/AtomicVariables/ConcurrentAtomic.swift) provides a working approach to thread-safe mutability with concurrent reads and serialized writes.

## `ThreadSafeCollections`
Attempt to create thread-safe (synchronized and concurrent) collections by leveraging a queue.

[`FailingSynchronizedArrayWrapper`](./AtomicVariables/ThreadSafeCollections/ThreadSafeCollections/FailingSynchronizedArrayWrapper.swift) uses a serial queue to synchronize access to an array.

[`FailingConcurrentArrayWrapper`](./AtomicVariables/ThreadSafeCollections/ThreadSafeCollections/FailingConcurrentArrayWrapper.swift) uses a concurrent queue to provides access to an array with concurrent reads and serialized writes.

## References
* [Swift Tip: Atomic Variables](https://www.objc.io/blog/2018/12/18/atomic-variables/).
* [Creating Thread-Safe Arrays in Swift](http://basememara.com/creating-thread-safe-arrays-in-swift/).
