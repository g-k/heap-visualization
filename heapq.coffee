# A port of Python [heapq module](http://docs.python.org/library/heapq.html)
# from its [source file](http://hg.python.org/cpython/file/2.7/Lib/heapq.py).
#
# Differences from Python:
#
# * camelCase names per Javascript Convention
# * Check on length since JS arrays can pop undefined
#

heapq =
  version: require('./package').version

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
      returnItem = heap[0]
      heap[0] = lastElement
      heapq._siftUp heap, 0
    else
      returnItem = lastElement

    return returnItem

  _siftDown: (heap, startPos, pos) ->
    # 'heap' is a heap at all indices >= startpos, except possibly for pos.  pos
    # is the index of a leaf with a possibly out-of-order value.  Restore the
    # heap invariant.
    newItem = heap[pos]
    # Follow the path to the root, moving parents down until finding a place
    # newitem fits.
    while pos > startPos
      parentPos = (pos - 1) >> 1  # (pos - 1) / 2
      parent = heap[parentPos]
      if heapq.compareLessThan newItem, parent
        heap[pos] = parent
        pos = parentPos
        continue
      break
    heap[pos] = newItem
    return heap

  _siftUp: (heap, pos) ->
    endPos = heap.length
    startPos = pos
    newItem = heap[pos]
    # Bubble up the smaller child until hitting a leaf.
    childPos = 2*pos + 1  # leftmost child position
    while childPos < endPos
      # Set childPos to index of smaller child.
      rightPos = childPos + 1
      if rightPos < endPos and not heapq.compareLessThan heap[childPos], heap[rightPos]
        childPos = rightPos
      # Move the smaller child up.
      heap[pos] = heap[childPos]
      pos = childPos
      childPos = 2*pos + 1
    # The leaf at pos is empty now.  Put newitem there, and bubble it up
    # to its final resting place (by sifting its parents down).
    heap[pos] = newItem
    heapq._siftDown heap, startPos, pos
    return heap



module.exports = heapq
