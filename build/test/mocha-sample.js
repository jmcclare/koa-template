"use strict";

require("should");

describe("feature", function () {
  it("should add two numbers", function () {
    return (2 + 2).should.equal(4);
  });
  return it("should add two numbers again", function (done) {
    (2 + 2).should.equal(4);
    return done();
  });
});