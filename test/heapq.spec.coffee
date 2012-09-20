_ = require 'underscore'
expect = require 'expect.js'

JSC = require './jscheck'

# Breaks if browser is built because js file is preferred
heapq = require '../heapq'
eventArray = require '../eventarray'

describe 'heapq', ->

  it 'should have a version', ->
    expect(heapq.version).to.be.ok()

  it 'should sort 10 integers', ->
    heap = []
    data = [1, 3, 5, 7, 9, 2, 4, 6, 8, 0]

    for item in data
      heapq.heapPush heap, item

    console.log heap

    sort = []
    while heap.length
      sort.push heapq.heapPop heap

    expect(sort).to.eql data.sort()

  it 'should throw error popping from empty heap', ->
    expect(-> heapq.heapPop([])).to.throwError()