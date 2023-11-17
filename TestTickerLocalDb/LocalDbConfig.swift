import Foundation
import GRDB

// TODO: correct kDefaultSQLiteName file name
private let kDefaultSQLiteName = "tess-app.db"

public struct LocalDbConfig {
    public let sqlitePath: String

    public static let shared = LocalDbConfig()
    public init() {
        do {
            // Apply recommendations from
            // <https://swiftpackageindex.com/groue/grdb.swift/documentation/grdb/databaseconnections>
            //
            // Create the "Application Support/Database" directory if needed
            let fileManager = FileManager.default
            let appSupportURL = try fileManager.url(
                for: .applicationSupportDirectory, in: .userDomainMask,
                appropriateFor: nil, create: true
            )

            // TODO: correct `Database` name directory
            let directoryURL = appSupportURL.appendingPathComponent("Database", isDirectory: true)
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            // Open or create the database
            let databaseURL = directoryURL.appendingPathComponent(kDefaultSQLiteName)
            sqlitePath = databaseURL.path

            Logger.default.info("Database initialized at \(databaseURL.path)")
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate.
            //
            // Typical reasons for an error here include:
            // * The parent directory cannot be created, or disallows writing.
            // * The database is not accessible, due to permissions or data protection when the device is locked.
            // * The device is out of space.
            // * The database could not be migrated to its latest schema version.
            // Check the error message to determine what the actual problem was.
            fatalError("Unresolved error \(error)")
        }
    }
}
