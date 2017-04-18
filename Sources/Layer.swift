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

import ATCKit
import Foundation
import FoundationKit
import Measure

public struct Layer {

    public let title: String
    public let coordinates: [Coordinate]

    public init(fileURL: URL) {
        self.title = fileURL.lastPathComponent

        self.coordinates = Layer.coordinates(contentsOf: fileURL)
    }
    
    static func coordinates(contentsOf fileURL: URL) -> [Coordinate] {
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            let rows = CSVParser(with: contents).rows
            let coordinate = rows.reduce([Coordinate]()) { acc, row in
                guard let latitude = Double(row[0]),
                    let longitude = Double(row[1]) else {
                        return acc
                }
                return acc + [Coordinate(latitude: Degree(latitude), longitude: Degree(longitude))]
            }
            return coordinate
        }
        catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
