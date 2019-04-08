//
//  Alert.swift
//  SQLSandbox
//
//  Created by Artem Karmaz on 4/8/19.
//  Copyright © 2019 Artem Karmaz. All rights reserved.
//

import UIKit

class Alert {

//    var textField: UITextField?
    func sqlSandBoxMenu() {
        
        
        let alert = UIAlertController(title: "SQL sandbox menu", message: "Please choose what you need.", preferredStyle: .alert)
        let file = UIAlertAction(title: "Create database", style: .default, handler: nil)
//        {_ in self.createNewFileAlertController()} )
        let folder = UIAlertAction(title: "Create table", style: .default, handler: nil)
//        {_ in self.createNewFolderAlertController() })
        let copy = UIAlertAction(title: "Insert table", style: .default, handler: nil)
//        {_ in self.createCopy() })
        let copy2 = UIAlertAction(title: "Update table", style: .default, handler: nil)
//        {_ in self.createCopy() })
        let copy3 = UIAlertAction(title: "Remove database", style: .default, handler: nil)
//        {_ in self.createCopy() })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(file)
        alert.addAction(folder)
        alert.addAction(copy)
        alert.addAction(copy2)
        alert.addAction(copy3)
        alert.addAction(cancel)
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
    func refreshAlert() {
        let alert = UIAlertController(title: "Refresh successful!", message: "", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
}
