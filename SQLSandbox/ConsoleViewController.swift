//
//  ConsoleViewController.swift
//  SQLSandbox
//
//  Created by Artem Karmaz on 4/5/19.
//  Copyright © 2019 Artem Karmaz. All rights reserved.
//

import UIKit

class ConsoleViewController: UIViewController, SQLProtocol, FileManagerProtocol, TimeProtocol {
    
    @IBOutlet weak var consoleLogTextView: UITextView!
    @IBOutlet weak var consoleInputTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    
    let alert = Alert()
    var timer = Timer()
    
    let createMyTable = #"""
        CREATE TABLE "MyTableFromXCodeGuard" (
        "ID"    INTEGER PRIMARY KEY AUTOINCREMENT,
        "Name"    TEXT NOT NULL UNIQUE
        );
        """#
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        consoleLogTextView.text = Storage.console
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKeyboardDismissRecognizer()
        runTimer()
        
        Storage.url = createURL("Database.db")
        removeDb(url: Storage.url!)
        
        Storage.db = createDataBase(url: Storage.url!)
        createTable(db: Storage.db, newTable: createMyTable)
        
        consoleInputTextField.delegate = self
        consoleLogTextView.text = Storage.console
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        //        url = createURL(nameDB: nameDB, fm: fm)
        //        removeDB(url: url!, fm: fm)
        //        db = createDataBase(url: url!)
        //        createTableInDB(db: db!, newTable: createMyTable)
        insertInTable(db: Storage.db, inTable: "MyTableFromXCodeGuard", name: "Holodov")
        //        insertInTable(db: db!, inTable: "MyTableFromXCodeGuard", name: "Holodov")
        //
        //        updateTableWithGuard(db: db!, inTable: "MyTableFromXCodeGuard", name: "Hi Holodov", id: "2")
        //
        //        sqlite3_close(db)
        
        closeDb(db: Storage.db)
        

    }
    
    
    @IBAction func refreshConsole(_ sender: UIBarButtonItem) {
        alert.refreshAlert()
        Storage.time = printTimestamp()
        Storage.console += Storage.time + "\nRefresh successful!" + " " + "\n" + "\n"
        consoleLogTextView.text = Storage.console
    }
    
    @IBAction func menuConsole(_ sender: UIBarButtonItem) {
        alert.sqlSandBoxMenu()
        Storage.time = printTimestamp()
        Storage.console += Storage.time + "\nMenu calling!" + " " + "\n" + "\n"
        consoleLogTextView.text = Storage.console
    }
    
    
    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    

    
    //MARK: - Selectors
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func updateTimer() {
        timeLabel.text = getCurrentTime()
    }
}

extension ConsoleViewController: UITextFieldDelegate {
    
    //MARK: - TextField Delegates
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == consoleInputTextField {
            textField.resignFirstResponder()
        }
        switch consoleInputTextField.text {
        case "status":
            Storage.time = printTimestamp()
            Storage.console += Storage.time + "\nStatus OK" + " " + "\n" + "\n"
            consoleLogTextView.text = Storage.console
        case "clear":
            Storage.time = printTimestamp()
            consoleLogTextView.text = Storage.time + "\nClear successful!" + " " + "\n" + "\n"
        case "help":
            ()
        case "menu":
            Storage.time = printTimestamp()
            Storage.console += Storage.time + "\nMenu calling" + " " + "\n" + "\n"
            consoleLogTextView.text = Storage.console
            alert.sqlSandBoxMenu()
        case "create db":
            ()
        case "reload":
            Storage.time = printTimestamp()
            Storage.console += Storage.time + "\nReload successful!" + " " + "\n" + "\n"
            consoleLogTextView.text = Storage.console
        default:
            ()
        }
        
        //        if sqlConsoleInput.text == "cdb with" {
        //            createDB()
        //            consoleLog += "SQL Data Base succesfully created!"
        //            insertInTable(db: Storage.dataBasePointer!, inTable: "MyTableFromXCode", name: "Ignat")
        //        } else if sqlConsoleInput.text == "sft" {
        //            array = []
        //            array = (selectFromTable(db: Storage.dataBasePointer!, inTable: "MyTableFromXCode", name: "*", withWhere: ""))
        //            consoleLog += "\nSQL Data Base select from table!"
        //            sqlTableView.reloadData()
        //        } else if sqlConsoleInput.text == "ut" {
        //
        //        }
        //        print(sqlConsoleInput.text as Any)
        //        sqlConsole.text = consoleLog
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
}

extension ConsoleViewController {
    
    //MARK: - Hide Keyboard on tap
    
    func setupKeyboardDismissRecognizer() {
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
