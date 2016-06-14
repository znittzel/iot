//
//  EventHandler.swift
//  TUVA2
//
//  Created by Carlos Martin (SE) on 17/05/16.
//  Copyright © 2016 Tuva Sweden AB. All rights reserved.
//

import Foundation

/*
 * Class Event<T>.
 * Is used by Master and SlaveEventHandler. Can be used as a custom event handler.
 */
class Event<T> {
    
    typealias EventHandler = T -> ()
    
    private var eventHandlers = [EventHandler]()
    
    func addHandler(handler: EventHandler) {
        eventHandlers.append(handler)
    }
    
    func raise(data: T) {
        for handler in eventHandlers {
            handler(data)
        }
    }
}

/*
 * Class SlaveEventHandler.
 * Is used by MasterEventHandler. Can be used as a single object and would work the way same as a MasterEventHandler -slave.
 */
class SlaveEventHandler {
    private var eventHandler = Event<NSError?>()
    
    /*
     * Loads an event on creating object.
     */
    init(event: (NSError?) -> Void) {
        load(event)
    }
    
    /*
     * Loads an event.
     */
    func load(event: (NSError?) -> Void) {
        eventHandler.addHandler(event)
    }
    
    /*
     * Fires all the loaded events.
     */
    func fire(error: NSError?) {
        eventHandler.raise(error)
    }
}


/**
 * Class MasterEventHandler. 
 * Load master or a custom slave with function(s). Call fetch* with your own function to finally call "fire()" and the custom slaves will fire. 
 * When all slaves has been fired the master will fire. You can fire the master manually by calling "fire()" in the "fetchMaster()" -function.
 *
 * Example: 
        // Initialize a MasterHandler
            let eventHandler = MasterEventHandler()

        // Load a slave by
           eventHandler.loadSlave("example", event: { 
                (error) in
                if error == nil {
                    // Do something with your fetched data
                } else {
                    // Handle error
                }
            })
 
        // Fetch a slave by
           eventHandler.fetchSlave("")
 
 
 */
class MasterEventHandler {
// MARK: PRIVATE VARS
    private var masterHandler : Event<NSError?>
    private var masterError : NSError?
    private var slaveHandler : [String : SlaveEventHandler]
    private var numberOfSlavesFired : Int
    
// MARK: INIT FUNCITONS
    init() {
        masterHandler = Event<NSError?>()
        slaveHandler = [String : SlaveEventHandler]()
        
        numberOfSlavesFired = 0
    }
    
// MARK: PRIVATE FUNCTIONS
    /*
     * Resets the MasterEventHandler to when it was first initialized.
     */
    private func __reset() {
        self.masterHandler = Event<NSError?>()
        self.slaveHandler = [String : SlaveEventHandler]()
        self.masterError = nil
        numberOfSlavesFired = 0
    }

// MARK: PUBLIC FUNCTIONS
    /*
     * Loads the master with an event.
     */
    func loadMaster (event: (NSError?) -> Void) {
        masterHandler.addHandler(event)
    }
    
    /*
     * Loads a custom made slave with an event.
     */
    func loadSlave (name: String, event: (NSError?) -> Void) {
        if slaveHandler[name] == nil {
            slaveHandler[name] = SlaveEventHandler(event: event)
        } else {
            slaveHandler[name]!.load(event)
        }
    }
    
    /*
     * Runs the callback function and fires the slave. If all the slaves has been fired, the master will fire.
     */
    func fetchSlave (name: String, callback: (fire: (NSError?) -> Void) -> Void) {
        if slaveHandler[name] != nil {
            callback(fire: { (error) in
                if let slave = self.slaveHandler[name] {
                    self.numberOfSlavesFired += 1
                    slave.fire(error)
                    
                    if error != nil {
                        self.masterError = error
                    }
                    
                    // All slaves has been fired
                    if self.numberOfSlavesFired == self.slaveHandler.count {
                        self.masterHandler.raise(self.masterError)
                        self.__reset()
                    }
                }
            })
        }
    }
    
    /*
     * Loads the master with and event and then fires it on callback.
     */
    func loadAndFetchMaster(event: (NSError?) -> Void, callback: (fire: (NSError?) -> Void) -> Void) {
        loadMaster(event)
        fetchMaster(callback)
    }
    
    /*
     * Runs the callback function and fires the master.
     */
    func fetchMaster(callback: (fire: (NSError?) -> Void) -> Void) {
        callback(fire: { (error) in
            self.masterHandler.raise(error)
            self.__reset()
        })
    }
}