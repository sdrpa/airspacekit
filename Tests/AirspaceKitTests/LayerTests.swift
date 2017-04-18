/**
 Created by Sinisa Drpa on 2/13/17.

 AirspaceKit is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License or any later version.

 AirspaceKit is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with AirspaceKit.  If not, see <http://www.gnu.org/licenses/>
 */

import XCTest
import ATCKit
import Measure

@testable import AirspaceKit

class LayerTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    var directory: URL {
        return URL(fileURLWithPath: "\(#file)").deletingLastPathComponent()
    }

    func testBoundary() {
        let fileURL = directory.appendingPathComponent("Boundary.txt")
        let coordinates = Layer.coordinates(contentsOf: fileURL)
        XCTAssertEqual(1011, coordinates.count)
    }

    static var allTests = [
        ("testBoundary", testBoundary)
    ]
}
