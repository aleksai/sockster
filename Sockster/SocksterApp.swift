//
//  SocksterApp.swift
//  Sockster
//
//  Created by Alek Sai on 9.10.2022.
//

import SwiftUI

@main
struct SocksterApp: App {
    @State var gvm = GlobalViewModel()
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                HostingWindowFinder { window in
                    if let window = window {
                        gvm.addWindow(window: window)
                    }
                }
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
    }
}

class GlobalViewModel : NSObject, ObservableObject {
    @Published var windows = Set<NSWindow>()
    
    func addWindow(window: NSWindow) {
        window.delegate = self
        windows.insert(window)
    }
}

extension GlobalViewModel : NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        NSApplication.shared.terminate(self)
    }
}

struct HostingWindowFinder: NSViewRepresentable {
    var callback: (NSWindow?) -> ()

    func makeNSView(context: Self.Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    func updateNSView(_ nsView: NSView, context: Context) {}
}
