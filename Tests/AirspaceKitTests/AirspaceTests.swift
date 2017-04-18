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
@testable import AirspaceKit

class AirspaceTests: XCTestCase {
    
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

    func filenameComponents(filename: String) -> (name: String, ext: String) {
        let components = filename.components(separatedBy: ".")
        return (name: components[0], ext: components[1])
    }
    
    func testVORs() {
        let file = self.filenameComponents(filename: Airspace.filename(for: .vor))
        let fileURL = directory.appendingPathComponent(file.name + "." + file.ext)
        let vors = Airspace.vors(contentsOf: fileURL)
        let found = vors.first { $0.title == "BEO" }

        XCTAssertNotNil(found)
    }

    func testNDBs() {
        let file = self.filenameComponents(filename: Airspace.filename(for: .ndb))
        let fileURL = directory.appendingPathComponent(file.name + "." + file.ext)
        let ndbs = Airspace.ndbs(contentsOf: fileURL)
        let found = ndbs.first { $0.title == "OSJ" }

        XCTAssertNotNil(found)
    }

    func testPoints() {
        let file = self.filenameComponents(filename: Airspace.filename(for: .point))
        let fileURL = directory.appendingPathComponent(file.name + "." + file.ext)
        let points = Airspace.points(contentsOf: fileURL)
        let found = points.first { $0.title == "XOMBA" }

        XCTAssertNotNil(found)
    }

    static var allTests = [
        ("testVORs", testVORs),
        ("testNDBs", testNDBs),
        ("testPoints", testPoints),
    ]
}
