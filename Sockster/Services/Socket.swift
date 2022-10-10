//
//  Socket.swift
//  Sockster
//
//  Created by Alek Sai on 9.10.2022.
//

import Foundation
import SocketIO

protocol SocketDelegate {
    func log(_ message: String)
    func connected()
    func disconnected()
}

class Socket: NSObject {
    
    static var shared = Socket()
    
    internal var manager: SocketManager?
    internal var delegate: SocketDelegate?
    
    func connect(url: String, delegate: SocketDelegate) {
        self.delegate = delegate
        
        manager = SocketManager(socketURL: URL(string: url)!, config: [.logger(self), .compress])
        
        manager?.defaultSocket.on(clientEvent: .connect, callback: { [weak self] data, ack in
            self?.delegate?.log("[CONNECTED] " + data.description)
            self?.delegate?.connected()
        })
        
        manager?.defaultSocket.on(clientEvent: .disconnect, callback: { [weak self] data, ack in
            self?.manager?.disconnect()
            self?.delegate?.disconnected()
        })
        
        manager?.defaultSocket.connect()
    }
    
    func disconnect() {
        manager?.defaultSocket.disconnect()
    }
    
}

extension Socket: SocketLogger {
    
    var log: Bool {
        get {
            true
        }
        set(newValue) {}
    }
    
    func log(_ message: @autoclosure () -> String, type: String) {
        delegate?.log(message() + " / " + type)
    }
    
    func error(_ message: @autoclosure () -> String, type: String) {
        delegate?.log("[ERROR] " + message() + " / " + type)
    }
    
}
