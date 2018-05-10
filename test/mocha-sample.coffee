import 'should'

describe "feature", ->
   it "should add two numbers", ->
       (2+2).should.equal 4

   it "should add two numbers again", (done) ->
       (2+2).should.equal 4
       done()
