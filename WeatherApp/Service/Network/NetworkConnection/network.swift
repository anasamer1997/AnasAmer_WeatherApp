//
//  network.swift
//  WeatherApp
//
//  Created by anas amer on 30/08/2024.
//

import Foundation
import Network

final class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "NetworkMonitorQueue")
    @Published var isConnected = false
    
    init() {
        // Set up the path update handler to observe network changes
        networkMonitor.pathUpdateHandler = {  path in
            // Update the isConnected property based on network status
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        
        // Start monitoring on a dedicated queue
        networkMonitor.start(queue: workerQueue)
    }
    
    deinit {
        // Stop monitoring when the object is deinitialized
        networkMonitor.cancel()
    }
}
