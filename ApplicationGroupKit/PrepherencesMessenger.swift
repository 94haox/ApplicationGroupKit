//
//  PrepherencesMessenger.swift
//  ApplicationGroupKit
//
//  Created by phimage on 03/02/16.
//  Copyright © 2016 phimage. All rights reserved.
//

import Foundation
import Prephirences

public class PrepherencesMessenger: Messenger {
    
    public var preferences: MutablePreferencesType? {
        fatalError("Must be overrided")
    }
    
    public override var type: MessengerType {
        fatalError("Must be overrided")
        // return .Custom(self)
    }
    
    override func checkConfig() -> Bool {
        return preferences != nil
    }

    override func writeMessage(message: Message, forIdentifier identifier: MessageIdentifier) -> Bool {
        let data = dataFromMessage(message)
        guard let preferences = self.preferences else {
            return false
        }
        preferences.setObject(data, forKey: identifier)
        return true
    }

    override func readMessageForIdentifier(identifier: MessageIdentifier) -> Message? {
        guard let data = self.preferences?.objectForKey(identifier) as? NSData else {
            return nil
        }
        return messageFromData(data)
    }

    override func deleteContentForIdentifier(identifier: MessageIdentifier) throws {
        self.preferences?.removeObjectForKey(identifier)
    }

    override func deleteContentForAllMessageIdentifiers() throws {
        if let keys = self.preferences?.dictionary().keys {
            for key in keys {
                self.preferences?.removeObjectForKey(key)
            }
        }
    }
    
    override func readMessages() -> [MessageIdentifier: Message]? {
        guard let preferences = self.preferences else {
            return nil
        }
        
        let messageLists = preferences.dictionary().filter { $0.1 is Message }
        return Dictionary(messageLists) as? [MessageIdentifier: Message]
    }
    
}

extension Dictionary {
    
    init(_ pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
    
}
