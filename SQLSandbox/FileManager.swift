//
//  FileManager.swift
//  SQLSandbox
//
//  Created by Artem Karmaz on 4/5/19.
//  Copyright © 2019 Artem Karmaz. All rights reserved.
//

import Foundation

protocol FileManagerProtocol {
    func createURL(_ databaseName: String) -> URL
    func removeDb(url: URL)
}

extension FileManagerProtocol {
    
    func createURL(_ databaseName: String) -> URL {
        
        let fm = FileManager.default
        var url = URL(fileURLWithPath: "")
        
        do {
            url = try fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent(databaseName)
            Storage.time = printTimestamp()
            Storage.console += Storage.time + " " + "\nFilemanager: Create URL with database name - \(databaseName) succesfull!" + "\n" + "\n"
        } catch {
            Storage.console += Storage.time + " " + "\nFilemanager: Error creating URL" + "\n" + "\n"
        }
        
        return url
    }
    
    func removeDb(url: URL) {
        let fm = FileManager.default
        do {
            try fm.removeItem(at: url)
            Storage.time = printTimestamp()
            Storage.console += Storage.time + "\nFilemanager: Remove database at \(getNameByUrl(url)) successfull!" + " " + "\n" + "\n"
        } catch {
            Storage.console += Storage.time + "\nFilemanager: Remove database at \(getNameByUrl(url)) error!" + " " + "\n" + "\n"
        }
    }

}
