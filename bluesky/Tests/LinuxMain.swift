import XCTest

import blueskyTests

var tests = [XCTestCaseEntry]()
tests += blueskyTests.allTests()
XCTMain(tests)