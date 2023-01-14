//
//  NetworkManager.swift
//  Solance
//
//  Created by Alexander Senin on 12.05.2022.
//

import Foundation
import Solana

protocol NetworkManagerProtocol {
    static var shared: NetworkManager { get }
    
    var solana: Solana { get }
    func receiveNetwork() -> String
}

class NetworkManager: NetworkManagerProtocol {
    
    static var shared: NetworkManager = {
        let instance = NetworkManager()
        return instance
    }()
    
    private init() {}

    var solana: Solana {
        return Solana(router: router)
    }
    
    private var router: NetworkingRouter {
        return NetworkingRouter(endpoint: endpoint)
    }
    
    private var endpoint: RPCEndpoint {
        return RPCEndpoint(url: URL(string: receiveNetworkUrl())!, urlWebSocket: URL(string: receiveNetworkUrlWebSocket())!, network: network)
    }
    
    private var network: Network {
        return Network(rawValue: UserDefaults.standard.string(forKey: "network") ?? "mainnet-beta")!
    }
    
    func receiveNetwork() -> String {
        let network = UserDefaults.standard.string(forKey: "network") ?? "mainnet-beta"
        switch network {
        case "mainnet-beta":
            return "MAINNET BETA"
        case "devnet":
            return "DEVNET"
        case "testnet":
            return "TESTNET"
        default:
            return "MAINNET BETA"
        }
    }

    private func receiveNetworkUrl() -> String {
        let network = UserDefaults.standard.string(forKey: "network") ?? "mainnet-beta"
        switch network {
        case "mainnet-beta":
            return "https://api.mainnet-beta.solana.com"
        case "devnet":
            return "https://api.devnet.solana.com"
        case "testnet":
            return "https://api.testnet.solana.com"
        default:
            return "https://api.mainnet-beta.solana.com"
        }
    }

    private func receiveNetworkUrlWebSocket() -> String {
        let network = UserDefaults.standard.string(forKey: "network") ?? "mainnet-beta"
        switch network {
        case "mainnet-beta":
            return "wss://api.mainnet-beta.solana.com"
        case "devnet":
            return "wss://api.devnet.solana.com"
        case "testnet":
            return "wss://api.testnet.solana.com"
        default:
            return "wss://api.mainnet-beta.solana.com"
        }
    }
}

extension NetworkManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
