import GRDB

public class LocalDbManager {
    public class var shared: LocalDbManager {
        enum Static {
            static var instance = LocalDbManager()
        }
        return Static.instance
    }

    var migrator = DatabaseMigrator()

    @available(*, deprecated, message: "Don't use this variable directly")
    var dbPool: DatabasePool

    @available(*, deprecated, message: "Don't use this variable directly")
    var dbQueue: DatabaseQueue

    var version = "v0.0.1"

    func read<T>(callback: ((Database) throws -> T)) throws -> T {
        try dbQueue.read(callback)
    }

    func write<T>(callback: ((Database) throws -> T)) throws -> T {
        try dbQueue.write(callback)
    }

    init() {
        migrator.registerMigration(version, migrate: migrations_v001)

        do {
            try dbQueue = DatabaseQueue(path: LocalDbConfig.shared.sqlitePath)
            try dbPool = DatabasePool(path: LocalDbConfig.shared.sqlitePath)
            try migrate()
        } catch {
            fatalError("Error \(error)")
        }
    }

    func flushAllContent() throws {
        try dbQueue.writeWithoutTransaction { db in
            try db.execute(sql: "PRAGMA foreign_keys = OFF")
            do {
                try db.inTransaction {
                    let tableNames = try String.fetchAll(db, sql: """
                    select name from sqlite_master where type = 'table'
                    """)
                    for tableName in tableNames {
                        if Database.isSQLiteInternalTable(tableName) { continue }
                        if Database.isGRDBInternalTable(tableName) { continue }
                        try Table(tableName).deleteAll(db)
                    }
                    return .commit
                }
                try db.execute(sql: "PRAGMA foreign_keys = ON")
            } catch {
                try db.execute(sql: "PRAGMA foreign_keys = ON")
                throw error
            }
        }
    }

    func migrate() throws {
        #if DEBUG
            migrator.eraseDatabaseOnSchemaChange = true
        #endif

        try migrator.migrate(dbPool, upTo: version)
    }
}
