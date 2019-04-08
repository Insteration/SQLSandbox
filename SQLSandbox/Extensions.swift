//
//  Extensions.swift
//  SQLSandbox
//
//  Created by Artem Karmaz on 4/5/19.
//  Copyright © 2019 Artem Karmaz. All rights reserved.
//

import UIKit

func printTimestamp() -> String {
    let timestamp = DateFormatter.localizedString(from: NSDate() as Date, dateStyle: .medium, timeStyle: .medium)
    return timestamp
}

func getNameByUrl(_ url: URL) -> String {
    var subStr = String()
    for j in 0..<url.path.count {
        if url.path[url.path.index(url.path.startIndex, offsetBy: url.path.count - 1 - j)] == "/" {
            subStr = String(url.path[url.path.index(url.path.startIndex, offsetBy: url.path.count - j)..<url.path.endIndex])
            break
        }
    }
    return subStr
}

extension UIAlertController {
    func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }
    
}
