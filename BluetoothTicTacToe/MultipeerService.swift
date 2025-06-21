import Foundation
import MultipeerConnectivity

class MultipeerService: NSObject, ObservableObject {
    private let serviceType = "tictactoe"
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private let serviceAdvertiser: MCNearbyServiceAdvertiser
    private let serviceBrowser: MCNearbyServiceBrowser
    private let session: MCSession
    
    @Published var connectedPeers: [MCPeerID] = []
    @Published var receivedMessage: String = ""
    @Published var isHost = false
    @Published var gameInviteReceived = false
    @Published var invitingPeer: MCPeerID?
    
    override init() {
        session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: serviceType)
        serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: serviceType)
        
        super.init()
        
        session.delegate = self
        serviceAdvertiser.delegate = self
        serviceBrowser.delegate = self
    }
    
    func startHosting() {
        isHost = true
        serviceAdvertiser.startAdvertisingPeer()
        serviceBrowser.startBrowsingForPeers()
    }
    
    func joinGame() {
        isHost = false
        serviceBrowser.startBrowsingForPeers()
    }
    
    func stopBrowsing() {
        serviceAdvertiser.stopAdvertisingPeer()
        serviceBrowser.stopBrowsingForPeers()
    }
    
    func sendMove(_ move: GameMove) {
        guard !session.connectedPeers.isEmpty else { return }
        
        do {
            let data = try JSONEncoder().encode(move)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Error sending move: \(error)")
        }
    }
    
    func sendGameReset() {
        guard !session.connectedPeers.isEmpty else { return }
        
        let resetMessage = GameMessage(type: .reset, data: nil)
        do {
            let data = try JSONEncoder().encode(resetMessage)
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("Error sending reset: \(error)")
        }
    }
}

extension MultipeerService: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        DispatchQueue.main.async {
            self.invitingPeer = peerID
            self.gameInviteReceived = true
        }
        invitationHandler(true, session)
    }
}

extension MultipeerService: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: session, withContext: nil, timeout: 10)
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("Lost peer: \(peerID)")
    }
}

extension MultipeerService: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            switch state {
            case .connected:
                self.connectedPeers.append(peerID)
                self.stopBrowsing()
            case .notConnected:
                self.connectedPeers.removeAll { $0 == peerID }
            case .connecting:
                break
            @unknown default:
                break
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async {
            if let move = try? JSONDecoder().decode(GameMove.self, from: data) {
                NotificationCenter.default.post(name: .gameMove, object: move)
            } else if let message = try? JSONDecoder().decode(GameMessage.self, from: data) {
                NotificationCenter.default.post(name: .gameMessage, object: message)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

struct GameMove: Codable {
    let row: Int
    let col: Int
    let player: String
}

struct GameMessage: Codable {
    let type: MessageType
    let data: String?
    
    enum MessageType: String, Codable {
        case reset
        case playerAssignment
    }
}

extension Notification.Name {
    static let gameMove = Notification.Name("gameMove")
    static let gameMessage = Notification.Name("gameMessage")
}