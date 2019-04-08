//
//  SQL.swift
//  SQLSandbox
//
//  Created by Artem Karmaz on 4/5/19.
//  Copyright © 2019 Artem Karmaz. All rights reserved.
//

import Foundation
import SQLite3

protocol SQLProtocol {
    func createDataBase(url: URL) -> OpaquePointer
    func createTable(db: OpaquePointer, newTable: String)
    func insertInTable(db: OpaquePointer, inTable: String, name: String)
    func updateTable(db: OpaquePointer, inTable: String, name: String, id: String)
    func selectFromTable(db: OpaquePointer, inTable: String, name: String, withWhere: String) -> [String]
    func deleteInTable(db: OpaquePointer, inTable: String, id: String)
    func dropTable(db: OpaquePointer, inTable: String)
    func getListTable(db: OpaquePointer) -> [String]
    func anySelect(db: OpaquePointer, querry: String) -> [String]
    func closeDb(db: OpaquePointer)
}

extension SQLProtocol {
    
    func createDataBase(url: URL) -> OpaquePointer {
        var db: OpaquePointer?
        
        if sqlite3_open(url.path, &db) == SQLITE_OK {
            Storage.time = printTimestamp()
            Storage.console += Storage.time + " " + "\nSQL: Databse with url \(getNameByUrl(url)) created succesfull!" + "\n" + "\n"
        } else {
            Storage.console += Storage.time + " " + "\nSQL: Error creating databse with url \(getNameByUrl(url))" + "\n" + "\n"
        }
        
        return db!
        
    }
    
    func createTable(db: OpaquePointer, newTable: String) {
        var table: OpaquePointer?
        
        if sqlite3_prepare_v2(db, newTable, -1, &table, nil) == SQLITE_OK {
            if sqlite3_step(table) == SQLITE_DONE {
                Storage.time = printTimestamp()
                Storage.console += Storage.time + " " + "\nSQL: Creating table - \(newTable) successfull!" + "\n" + "\n"
            } else {
                Storage.console += Storage.time + " " + "\nSQL: Error creating new table - \(newTable)!" + "\n" + "\n"
            }
        } else {
            Storage.console += Storage.time + " " + "\nSQL: Prepare error!" + "\n" + "\n"
        }
        
        sqlite3_finalize(table)
    }
    
    func insertInTable(db: OpaquePointer, inTable: String, name: String) {
        
        var insert: OpaquePointer?
        let insertString = """
        INSERT INTO \(inTable) (name) VALUES ('\(name)');
        """
        if sqlite3_prepare_v2(db, insertString, -1, &insert, nil) == SQLITE_OK {
            if sqlite3_step(insert) == SQLITE_DONE {
                Storage.time = printTimestamp()
                Storage.console += Storage.time + "\nSQL: Insert in DB - \(db), in table - \(inTable), name - \(name) successfull" + " " + "\n" + "\n"
            } else {
                Storage.console += Storage.time + "\nSQL: Insert in DB - \(db), in table - \(inTable), name - \(name) error!" + " " + "\n" + "\n"
            }
        } else {
            Storage.console += Storage.time + "\nSQL: Prepare insert error!" + " " + "\n" + "\n"
        }
        sqlite3_finalize(insert)
        print(Storage.console)
    }
    
    func updateTable(db: OpaquePointer, inTable: String, name: String, id: String) {
        var update: OpaquePointer?
        
        let updateString = """
        UPDATE \(inTable) SET name = '\(name)' where ID = \(id)
        """
        //        guard sqlite3_prepare_v2(db, updateString, -1, &update, nil) == SQLITE_OK, sqlite3_step(update) == SQLITE_DONE else {
        //            return
        //        }
        if sqlite3_prepare_v2(db, updateString, -1, &update, nil) == SQLITE_OK {
            if sqlite3_step(update) == SQLITE_DONE {
                print("ok update")
            } else {
                print("error update")
            }
        } else {
            print("error prepare update")
        }
        
        sqlite3_finalize(update)
    }
    
    func selectFromTable(db: OpaquePointer, inTable: String, name: String, withWhere: String) -> [String] {
        var values = [String]()
        var select: OpaquePointer? = nil
        var query = "SELECT \(name) FROM \(inTable) "
        if withWhere != "" {
            query += "WHERE \(withWhere)"
        }
        
        if sqlite3_prepare_v2(db, query, -1, &select, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) incorrect")
        }
        
        while (sqlite3_step(select) == SQLITE_ROW) {
            let id = sqlite3_column_int(select, 0)
            let name = String(cString: sqlite3_column_text(select, 1))
            values.append(String(id) + " " + name)
        }
        
        return values
    }
    
    
    func deleteInTable(db: OpaquePointer, inTable: String, id: String) {
        var del: OpaquePointer? = nil
        let query = "DELETE FROM \(inTable) WHERE ID = \(id)"
        
        if sqlite3_prepare_v2(db, query, -1, &del, nil) == SQLITE_OK {
            print("DElete query success!")
            if sqlite3_step(del) == SQLITE_DONE {
                print("SQLITE DELETE DONE")
            }
        } else {
            print("error delete")
        }
        sqlite3_finalize(del)
    }
    
    func dropTable(db: OpaquePointer, inTable: String) {
        var del: OpaquePointer? = nil
        let query = "DROP TABLE \(inTable)"
        
        if sqlite3_prepare_v2(db, query, -1, &del, nil) == SQLITE_OK {
            print("table delete")
            if sqlite3_step(del) == SQLITE_DONE {
                print("okok ok")
            }
        }
        sqlite3_finalize(del)
    }
    
    func getListTable(db: OpaquePointer) -> [String] {
        var values = [String]()
        var select: OpaquePointer? = nil
        let query = "select name from sqlite_master where type = 'table' and name <> 'sqlite_squence'"
        
        if sqlite3_prepare_v2(db, query, -1, &select, nil) == SQLITE_OK {
            print("query \(query) is DONE")
        } else {
            print("query \(query) incorrect")
        }
        
        while (sqlite3_step(select) == SQLITE_ROW) {
            let name = String(cString: sqlite3_column_text(select, 0))
            values.append(name)
        }
        
        return values
    }
    
    func anySelect(db: OpaquePointer, querry: String) -> [String] {
        var values = [String]()
        var select: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, querry, -1, &select, nil) == SQLITE_OK {
            print("Any querry done!")
        } else {
            print("Any query incorrect")
        }
        
        while (sqlite3_step(select) == SQLITE_ROW) {
            var value = String()
            
            for i in 0..<sqlite3_column_count(select) {
                let name = String(cString: sqlite3_column_text(select, i))
                value += " " + name
            }
            values.append(value)
        }
        
        return values
    }
    
    func closeDb(db: OpaquePointer) {
        sqlite3_close(db)
    }
    
}
