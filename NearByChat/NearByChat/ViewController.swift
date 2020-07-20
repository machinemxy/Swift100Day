//
//  ViewController.swift
//  NearByChat
//
//  Created by Ma Xueyuan on 2020/07/18.
//  Copyright © 2020 Ma Xueyuan. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textField: UITextField!
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiser: MCNearbyServiceAdvertiser?
    
    var text = "" {
        didSet {
            textView.text = text
            // scroll to end
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chat"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(action))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Status", style: .plain, target: self, action: #selector(checkConnectStatus))
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }

    @IBAction func send(_ sender: Any) {
        guard var content = textField.text else { return }
        
        textField.text = ""
        content = peerID.displayName + ": " + content + "\n"
        text.append(content)
        
        if let session = mcSession, session.connectedPeers.count > 0 {
            if let data = content.data(using: .utf8) {
                do {
                    try session.send(data, toPeers: session.connectedPeers, with: .reliable)
                } catch {
                    fatalError("Fatal Error!")
                }
            }
        }
    }
    
    @objc func checkConnectStatus() {
        guard let session = mcSession else { return }
        let people = session.connectedPeers.map { $0.displayName }.joined(separator: "\n")
        let ac = UIAlertController(title: "Current people", message: people, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    @objc func action() {
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let advertiser = self.mcAdvertiser {
            ac.addAction(UIAlertAction(title: "Stop hosting", style: .destructive, handler: { [unowned self] (_) in
                self.mcSession?.disconnect()
                advertiser.stopAdvertisingPeer()
                self.mcAdvertiser = nil
            }))
        } else if let session = mcSession {
            if session.connectedPeers.count > 0 {
                ac.addAction(UIAlertAction(title: "Disconnect", style: .destructive, handler: { (_) in
                    session.disconnect()
                }))
            } else {
                ac.addAction(UIAlertAction(title: "Start hosting", style: .default, handler: { [unowned self] (_) in
                    self.mcAdvertiser = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo: nil, serviceType: "mxy-nearbychat")
                    self.mcAdvertiser?.delegate = self
                    self.mcAdvertiser?.startAdvertisingPeer()
                }))
                
                ac.addAction(UIAlertAction(title: "Join", style: .default, handler: { [unowned self] (_) in
                    let browser = MCBrowserViewController(serviceType: "mxy-nearbychat", session: session)
                    browser.delegate = self
                    self.present(browser, animated: true)
                }))
            }
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
}

extension ViewController: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            DispatchQueue.main.async { [unowned self] in
                self.text.append("\(peerID.displayName) joined.\n")
            }
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            DispatchQueue.main.async { [unowned self] in
                self.text.append("\(peerID.displayName) left.\n")
            }
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [unowned self] in
            if let str = String(data: data, encoding: .utf8) {
                self.text.append(str)
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // do nothing
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // do nothing
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // do nothing
    }
}

extension ViewController: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession)
    }
}

extension ViewController: MCBrowserViewControllerDelegate {
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    
}
