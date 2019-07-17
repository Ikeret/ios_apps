//
//  MPCHandler.swift
//  Rock Paper Scissors
//
//  Created by Сергей Коршунов on 16/07/2019.
//  Copyright © 2019 Sergey Korshunov. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class MPCHandler: NSObject, MCSessionDelegate {

    var peerID : MCPeerID!
    var session : MCSession!
    var browser : MCBrowserViewController!
    var advertiser : MCAdvertiserAssistant?
    
    func setupPeerWithDisplayName(displayName: String) {
        peerID = MCPeerID(displayName: displayName)
    }
    
    func setupSession() {
        session = MCSession(peer: peerID)
        session.delegate = self
    }
    
    func setupBrowser() {
        browser = MCBrowserViewController(serviceType: "my-game", session: session)
    }
    
    func advertiseSelf(advertise: Bool) {
        if advertise {
            advertiser = MCAdvertiserAssistant(serviceType: "my-game", discoveryInfo: nil, session: session)
            advertiser?.start()
        } else {
            advertiser?.stop()
            advertiser = nil
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        let userInfo : [String : Any] = ["peerID": peerID, "state": state.rawValue]
        let name = Notification.Name(rawValue: "MPC_DidChangeStateNotification")
        let notification =  Notification(name: name, object: nil, userInfo: userInfo)
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        let userInfo : [String : Any] = ["data": data, "peerID": peerID]
        let name = Notification.Name(rawValue: "MPC_DidReciveDataNotification")
        let notification =  Notification(name: name, object: nil, userInfo: userInfo)
        
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
}
