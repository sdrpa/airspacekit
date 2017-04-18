/**
 Created by Sinisa Drpa on 1/29/17.

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

public struct Airspace: CustomStringConvertible {

    public let title: String

    public let vors: [VOR]
    public let ndbs: [NDB]
    public let points: [Point]

    public let layers: [Layer]

    public var description: String {
        return "VOR: \(self.vors.count), NDB: \(self.ndbs.count), Point: \(self.points.count)"
    }

    public init?(directoryURL: URL) {
        guard FileManager.default.fileExists(atPath: directoryURL.path) else {
            return nil
        }
        self.title = directoryURL.lastPathComponent

        self.vors = Airspace.vors(contentsOf: directoryURL.appendingPathComponent(Airspace.filename(for: .vor)))
        self.ndbs = Airspace.ndbs(contentsOf: directoryURL.appendingPathComponent(Airspace.filename(for: .ndb)))
        self.points = Airspace.points(contentsOf: directoryURL.appendingPathComponent(Airspace.filename(for: .point)))

        self.layers = [Layer(fileURL: directoryURL.appendingPathComponent("Boundary.txt"))]
    }

    public func navigationPoint(title: String) -> NavigationPoint? {
        if let vor = self.vors.first(where: { $0.title == title }) { return vor }
        if let point = self.points.first(where: { $0.title == title }) { return point }
        if let ndb = self.ndbs.first(where: { $0.title == title }) { return ndb }
        return nil
    }

    static func vors(contentsOf fileURL: URL) -> [VOR] {
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            let rows = CSVParser(with: contents).rows
            let vors = rows.reduce([VOR]()) { acc, row in
                guard let latitude = Double(row[1]),
                    let longitude = Double(row[2]),
                    let frequency = Double(row[3]) else {
                        return acc
                }
                return acc + [VOR(title: row[0],
                                  coordinate: Coordinate(latitude: Degree(latitude), longitude: Degree(longitude)),
                                  frequency: frequency)]
            }
            return vors
        }
        catch let error {
            fatalError(error.localizedDescription)
        }
    }

    static func ndbs(contentsOf fileURL: URL) -> [NDB] {
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            let rows = CSVParser(with: contents).rows
            let ndbs = rows.reduce([NDB]()) { acc, row in
                guard let latitude = Double(row[1]),
                    let longitude = Double(row[2]),
                    let frequency = Double(row[3]) else {
                        return acc
                }
                return acc + [NDB(title: row[0],
                                  coordinate: Coordinate(latitude: Degree(latitude), longitude: Degree(longitude)),
                                  frequency: frequency)]
            }
            return ndbs
        }
        catch let error {
            fatalError(error.localizedDescription)
        }
    }

    static func points(contentsOf fileURL: URL) -> [Point] {
        do {
            let contents = try String(contentsOf: fileURL, encoding: .utf8)
            let rows = CSVParser(with: contents).rows
            let points = rows.reduce([Point]()) { acc, row in
                guard let latitude = Double(row[1]),
                    let longitude = Double(row[2]) else {
                        return acc
                }
                return acc + [Point(title: row[0],
                                  coordinate: Coordinate(latitude: Degree(latitude), longitude: Degree(longitude)))]
            }
            return points
        }
        catch let error {
            fatalError(error.localizedDescription)
        }
    }
}

extension Airspace {

    enum File: String {
        case vor = "VOR"
        case point = "Point"
        case ndb = "NDB"
    }

    static let fileExtension = ".txt"

    static func filename(for file: File) -> String {
        return file.rawValue + Airspace.fileExtension
    }
}
