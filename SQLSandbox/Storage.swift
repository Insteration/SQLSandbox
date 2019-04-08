//
//  Storage.swift
//  SQLSandbox
//
//  Created by Artem Karmaz on 4/5/19.
//  Copyright © 2019 Artem Karmaz. All rights reserved.
//

import Foundation

struct Storage {
    static var time = String()
    static var console = String()
    static var url: URL?
    static var db: OpaquePointer!
}
