_ = require 'underscore'
expect = require 'expect.js'

JSC = require './jscheck'

heapq = require '../heapq'


describe 'heapq', ->

  it 'should have a version', ->
    expect(heapq.version).to.be.ok()

  it 'should sort 10 integers', ->
    heap = []
    data = [1, 3, 5, 7, 9, 2, 4, 6, 8, 0]

    for item in data
      heapq.heapPush heap, item

    sort = []
    while heap.length
      sort.push heapq.heapPop heap

    expect(sort).to.eql data.sort()
