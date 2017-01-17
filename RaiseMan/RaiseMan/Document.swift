//
//  Document.swift
//  RaiseMan
//
//  Created by Sinkerine on 16/01/2017.
//  Copyright © 2017 sinkerine. All rights reserved.
//

import Cocoa

private var KVOContext: Int = 0

class Document: NSDocument, NSWindowDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var arrayController: NSArrayController!
    dynamic var employees: [Employee] = [] {
        willSet {
            for employee in employees {
                stopObservingEmployee(employee: employee)
            }
        }
        didSet {
            for employee in employees {
                startObservingEmployee(employee: employee)
            }
        }
    }

    override init() {
        super.init()
        // Add your subclass-specific initialization here.
    }

    override class func autosavesInPlace() -> Bool {
        return true
    }

    override var windowNibName: String? {
        // Returns the nib file name of the document
        // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this property and override -makeWindowControllers instead.
        return "Document"
    }

    override func data(ofType typeName: String) throws -> Data {
        // Insert code here to write your document to data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning nil.
        // You can also choose to override fileWrapperOfType:error:, writeToURL:ofType:error:, or writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
//        return nil
    }

    override func read(from data: Data, ofType typeName: String) throws {
        // Insert code here to read your document from the given data of the specified type. If outError != nil, ensure that you create and set an appropriate error when returning false.
        // You can also choose to override readFromFileWrapper:ofType:error: or readFromURL:ofType:error: instead.
        // If you override either of these, you should also override -isEntireFileLoaded to return false if the contents are lazily loaded.
//        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
    }
    
    // MARK: - Accessors
    func insertObject(_ employee: Employee, inEmployeesAtIndex index: Int) {
        Swift.print("adding at \(index)")
        if let undo = undoManager {
            undo.registerUndo(withTarget: self, handler: {target in
                target.removeObject(fromEmployeesAtIndex: index)
            })
            if !undo.isUndoing {
                undo.setActionName("Add Employee")
            }
        }
        employees.append(employee)
    }
    
    func removeObject(fromEmployeesAtIndex index: Int) {
        Swift.print("removing at \(index)")
        let employee = employees[index]
        if let undo = undoManager {
            undo.registerUndo(withTarget: self, handler: {target in
                target.insertObject(employee, inEmployeesAtIndex: index)
            })
            if !undo.isUndoing {
                undo.setActionName("Remove Employee")
            }
        }
        employees.remove(at: index)
    }
    
    // MARK: - Key Value Oberserving
    func startObservingEmployee(employee: Employee) {
        employee.addObserver(self, forKeyPath: "name", options: .old, context: &KVOContext)
        employee.addObserver(self, forKeyPath: "raise", options: .old, context: &KVOContext)
    }
    
    func stopObservingEmployee(employee: Employee) {
        employee.removeObserver(self, forKeyPath: "name", context: &KVOContext)
        employee.removeObserver(self, forKeyPath: "raise", context: &KVOContext)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context != &KVOContext {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        var oldValue: AnyObject? = change?[NSKeyValueChangeKey.oldKey] as AnyObject?
        if oldValue is NSNull {
            oldValue = nil
        }
        
        if let undo = undoManager {
            undo.registerUndo(withTarget: object as AnyObject!, handler: {target in
                target.setValue(oldValue, forKey: keyPath!)
            })
        }
    }
    
    // MARK: - NSWindowDelegate
    // Trigger willSet of employees to stop observing
    func windowWillClose(_ notification: Notification) {
        employees = []
    }
    
    // MARK: - Actions
    @IBAction func addEmployee(sender: NSButton) {
        let windowController = windowControllers[0]
        let window = windowController.window!
        
        let endedEditing = window.makeFirstResponder(window)
        if !endedEditing {
            Swift.print("Unable to end editing")
            return
        }
        
        let undo: UndoManager = undoManager!
        
        // Has an edit occurred already in this event?
        if undo.groupingLevel > 0 {
            // Close the last group
            undo.endUndoGrouping()
            // Open a new group
            undo.beginUndoGrouping()
        }
        
        // Create the object
        let employee = arrayController.newObject() as! Employee
        
        // Add it to the array controller's content array
        arrayController.addObject(employee)
        
        // Re-sort (in case the use has sorted a column)
        arrayController.rearrangeObjects()
        
        // Get the sorted array
        let sortedEmployees = arrayController.arrangedObjects as! [Employee]
        
        // Find the object just added
        let row = sortedEmployees.index(of: employee)!
        
        // Begin the edit in the first column
        Swift.print("starting edit of \(employee) in row \(row)")
        tableView.editColumn(0, row: row, with: nil, select: true)
    }
}

