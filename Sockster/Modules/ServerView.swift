//
//  ServerView.swift
//  Sockster
//
//  Created by Alek Sai on 9.10.2022.
//

import SwiftUI

struct ServerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var url = ""
    @State private var log: [String] = []
    @State private var button = "Connect"
    @State private var buttonDisabled = false
    @State private var connection = false
    @State private var error = false
    
    var server: Server

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                ZStack(alignment: .trailing) {
                    TextField("Server URL", text: $url)
                        .frame(maxWidth: .infinity)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: url) { newValue in
                            server.url = url
                            
                            disconnected()
                            
                            do {
                                try viewContext.save()
                            } catch {
                                // Replace this implementation with code to handle the error appropriately.
                                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                                let nsError = error as NSError
                                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                            }
                        }
                        .onAppear {
                            url = server.url ?? ""
                        }
                    
                    HStack(spacing: 4) {
                        if error {
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(.red)
                        }
                        
                        if connection {
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(.green)
                        }
                    }
                    .padding(.trailing, 8)
                }
                
                Button(button, action: connect)
                    .disabled(buttonDisabled)
            }
            .padding(.horizontal, 10)
            .padding(.top, -28)
            
            ScrollView {
                VStack {
                    log.reduce(Text(""), { $0 + Text($1).foregroundColor($1.contains("[CONNECTED]") ? .green : ($1.contains("[ERROR]") ? .red : .primary)) + Text("\n")} )
                }
                .textSelection(.enabled)
                .padding(20)
            }
        }
    }
    
    private func connect() {
        if button == "Connect" {
            error = false
            connection = false
            log.removeAll()
            buttonDisabled = true
            Socket.shared.connect(url: url, delegate: self)
        } else {
            disconnect()
        }
    }
    
    private func disconnect() {
        buttonDisabled = true
        Socket.shared.disconnect()
    }
    
}

extension ServerView: SocketDelegate {
    
    func log(_ message: String) {
        self.log.append(message)
        
        if message.contains("[ERROR]") {
            error = true
        }
    }
    
    func connected() {
        button = "Disconnect"
        buttonDisabled = false
        connection = true
    }
    
    func disconnected() {
        button = "Connect"
        buttonDisabled = false
        connection = false
    }
    
}
