//
//  PriorityQueue.swift
//  TUITestApp
//
//  Created by Michael Bielodied on 01.04.2025.
//

struct PriorityQueue<Element> {
    private var heap: [Element] = []
    private let areInIncreasingOrder: (Element, Element) -> Bool

    init(_ areInIncreasingOrder: @escaping (Element, Element) -> Bool) {
        self.areInIncreasingOrder = areInIncreasingOrder
    }

    mutating func enqueue(_ element: Element) {
        heap.append(element)
        heap.sort(by: areInIncreasingOrder)
    }

    mutating func dequeue() -> Element? {
        guard !heap.isEmpty else { return nil }
        return heap.removeFirst()
    }

    var isEmpty: Bool {
        heap.isEmpty
    }
}
