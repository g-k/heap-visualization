# A port of Python [heapq module](http://docs.python.org/library/heapq.html)
# from its [source file](http://hg.python.org/cpython/file/2.7/Lib/heapq.py).
#
# Differences from Python:
#
# * camelCase names per Javascript Convention
# * Check on length since JS arrays can pop undefined
#

heapq =
  version: "0.0.0"

  getter: (heap, index) -> heap[index]
  setter: (heap, index, value) -> heap[index] = value
  compareLessThan: (x, y) -> x < y

  # Push item onto heap, maintaining the heap invariant.
  heapPush: (heap, item) ->
    heap.push item
    heapq._siftDown heap, 0, heap.length-1
    return heap

  # Pop the smallest item off the heap, maintaining the heap invariant.
  heapPop: (heap) ->
    lastElement = heap.pop()
    if lastElement == undefined
      throw new Error "Empty Heap"

    if heap.length
      returnItem = heapq.getter heap, 0
      heapq.setter heap, 0, lastElement
      heapq._siftUp heap, 0
    else
      returnItem = lastElement

    return returnItem

  _siftDown: (heap, startPos, pos) ->
    # 'heap' is a heap at all indices >= startpos, except possibly for pos.  pos
    # is the index of a leaf with a possibly out-of-order value.  Restore the
    # heap invariant.
    newItem = heapq.getter heap, pos
    # Follow the path to the root, moving parents down until finding a place
    # newitem fits.
    while pos > startPos
      parentPos = (pos - 1) >> 1  # (pos - 1) / 2
      parent = heapq.getter heap, parentPos
      if heapq.compareLessThan newItem, parent
        heapq.setter heap, pos, parent
        pos = parentPos
        continue
      break
    heapq.setter heap, pos, newItem
    return heap

  _siftUp: (heap, pos) ->
    endPos = heap.length
    startPos = pos
    newItem = heapq.getter heap, pos
    # Bubble up the smaller child until hitting a leaf.
    childPos = 2*pos + 1  # leftmost child position
    while childPos < endPos
      # Set childPos to index of smaller child.
      rightPos = childPos + 1
      if rightPos < endPos and not heapq.compareLessThan heapq.getter(heap, childPos), heapq.getter(heap, rightPos)
        childPos = rightPos
      # Move the smaller child up.
      heapq.setter heap, pos, heapq.getter(heap, childPos)
      pos = childPos
      childPos = 2*pos + 1
    # The leaf at pos is empty now.  Put newitem there, and bubble it up
    # to its final resting place (by sifting its parents down).
    heapq.setter heap, pos, newItem
    heapq._siftDown heap, startPos, pos
    return heap

module.exports = heapq
