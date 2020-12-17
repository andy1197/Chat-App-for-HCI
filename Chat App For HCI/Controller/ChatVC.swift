//
//  ChatVC.swift
//  Chat App For HCI
//
//  Created by Sudeep Raj on 6/26/18.
//  Collaborators: Andy Wang 
//  Copyright © 2018 Sudeep Raj. All rights reserved.
//

import UIKit
import ARKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit
import FirebaseDatabase

class ChatVC: JSQMessagesViewController, MessageReceivedDelegate, UINavigationControllerDelegate, ARSessionDelegate{
    var timer = Timer();
    var currentExpression = "NEUTRAL";
    let testerId = "lqizrjTo60Q3vTZlo16W0wldNA63";
    private var messages = [JSQMessage]();
    private var newMessageRefHandle: MessagesHandler?
    let session = ARSession();
    var runSession = true;
    var timeMSGSent = "NA";
    var timeExpressionDetected = "NA";
    var timeResponseStarts = "NA";
    var expressionData = "NA";
    var resetEXPData = "NA";
    var calibrateRequired = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderDisplayName = "";
        MessagesHandler.Instance.delegate = self;
        self.senderId = AuthProvider.Instance.userID();
        MessagesHandler.Instance.observeMessages();
        self.inputToolbar.contentView.leftBarButtonItem = nil;
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(self.tick) , userInfo: nil, repeats: true);
        let config = ARFaceTrackingConfiguration();
        config.worldAlignment = .gravity;
        session.delegate = self;
        if (runSession) {
            session.run(config, options: []);
        } else {
            session.pause();
        }
    }
    
    ///////////////////////////////////////////////////////////////SETTING UP ARSESSION//////////////////////////////////////////////
    var currentFaceAnchor: ARFaceAnchor?
    var currentFrame: ARFrame?
    var expressionsToUse: [Expression] = [SmileExpression(), FrownExpression(), SurpriseExpression(), AngerExpression(), DisgustExpression()]
    var currentExpressionShownAt: Date? = nil
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        self.currentFrame = frame
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if self.calibrateRequired == true {
                self.processNewARFrameCALIBRATION()
                self.calibrateRequired = false
            }
            else {
                self.processNewARFrame2()
            }
        }
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }
        self.currentFaceAnchor = faceAnchor
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
        
    }
    func processNewARFrameCALIBRATION() {
        if let faceAnchor = self.currentFaceAnchor {
            if runSession {
                runSession = false;
                timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                print("*************** INITIATE calibration ***************")
                Calibration().calibrateAll(face: faceAnchor)
                print("*************** calibration complete ***************")
            }
        }
    }
    // test function that prints every faceAnchor value
    func processNewARFrameTEST() {
        if let faceAnchor = self.currentFaceAnchor {
            if runSession {
                runSession = false;
                timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                print("*************** INITIATE TEST ***************")
                Test().printAllValues(face: faceAnchor)
                print("*************** TEST COMPLETE ***************")
            }
        }
    }
    
    func processNewARFrame2() {
        if let faceAnchor = self.currentFaceAnchor {
            if runSession {
                let scores = [Happy().score(face: faceAnchor), Surprise().score(face: faceAnchor), Disgust().score(face: faceAnchor), Angry().score(face: faceAnchor), Sad().score(face: faceAnchor), 20.0]
                let happyScore = Happy().score(face: faceAnchor)
                let surpriseScore = Surprise().score(face: faceAnchor)
                let disgustScore = Disgust().score(face: faceAnchor)
                let angryScore = Angry().score(face: faceAnchor)
                let sadScore = Sad().score(face: faceAnchor)
                
                print("Happy: \(happyScore)")
                print("Surprise: \(surpriseScore)")
                print("Disgust: \(disgustScore)")
                print("Angry: \(angryScore)")
                print("Sad: \(sadScore)")
                
                let neutral = 20.0
                let MAX = scores.max();
                
                runSession = false;
                timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)

                if (MAX == happyScore) {
                    currentExpression = "HAPPY"
                }
                else if (MAX == surpriseScore) {
                    currentExpression = "SURPRISE"
                }
                else if (MAX == disgustScore) {
                    currentExpression = "DISGUST"
                }
                else if (MAX == angryScore) {
                    currentExpression = "ANGRY"
                }
                else if (MAX == sadScore) {
                    currentExpression = "SAD"
                }
                else if (MAX == neutral) {
                    currentExpression = "NEUTRAL"
                }
                print(MAX!)
                print(currentExpression)
            }
        }
    }
    func processNewARFrame() {
        // called each time ARKit updates our frame (aka we have new facial recognition data)
        if let faceAnchor = self.currentFaceAnchor
        {
            if runSession
            {
                // CHECKS NEGATIVE EMOTIONS FIRST SINCE THEY ARE MORE COMPLEX
                if (DisgustExpression().isExpressing(from: faceAnchor) != "") {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    if expressionData.contains("DISGUST") {
                        currentExpression = "DISGUST"
                    }
                    else if expressionData.contains("MILD DISGUST") {
                        currentExpression = "MILD DISGUST"
                    }
                    else if expressionData.contains("CONFUSED") {
                        currentExpression = "CONFUSED"
                    }
                    runSession = false
                    timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                    expressionData = DisgustExpression().isExpressing(from: faceAnchor)
                    print(expressionData)
                }
                else if (FrownExpression().isExpressing(from: faceAnchor) != "") {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    currentExpression = "sadMS"
                    runSession = false
                    timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                    expressionData = FrownExpression().isExpressing(from: faceAnchor)
                    print(expressionData)
                    }
                else if (AngerExpression().isExpressing(from: faceAnchor) != "") {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    currentExpression = "angryMS"
                    runSession = false
                    timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                    expressionData = AngerExpression().isExpressing(from: faceAnchor)
                    print(expressionData)
                    }
                    
                // POSITIVE OR NEUTRAL EXPRESSIONS
                else if (SmileExpression().isExpressing(from: faceAnchor) != "") {
                    expressionData = SmileExpression().isExpressing(from: faceAnchor)
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    if expressionData.contains("BIG SMILE") {
                        currentExpression = "BIG SMILE"
                        }
                    else if expressionData.contains("NORMAL SMILE") {
                        currentExpression = "NORMAL SMILE"
                    }
                    else if expressionData.contains("LIGHT SMILE") {
                        currentExpression = "LIGHT SMILE"
                    }
                    runSession = false
                    timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                    print(expressionData)
                }
                else if (SurpriseExpression().isExpressing(from: faceAnchor) != "") {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    if expressionData.contains("JAW DROPPING SURPRISE") {
                        currentExpression = "JAW DROPPING SURPRISE"
                    }
                    else if expressionData.contains("SURPRISE") {
                        currentExpression = "SURPRISE"
                    }
                    else if expressionData.contains("INTRIGUED") {
                        currentExpression = "INTRIGUED"
                    }
                    runSession = false
                    timeExpressionDetected = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium)
                    expressionData = SurpriseExpression().isExpressing(from: faceAnchor)
                    print(expressionData)
                }
                else
                {
                    currentExpression = "normalMS"
                    expressionData = "NEUTRAL"
                }
            }
        }
    }
    
    ///////////////////////////////////////////////////////////////ENDING UP ARSESSION//////////////////////////////////////////////
    
    @objc func tick() {
        DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium);
    }
    
    //COLLECTION VIEW FUNCTIONS

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory();
        let message = messages[indexPath.item];
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue);
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.lightGray);
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = messages[indexPath.item];
        if message.senderId == testerId {
            return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "testerMS"), diameter: 30);
        } else {
            return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: message.senderDisplayName), diameter: 30);
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count;
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        return cell;
    }
    
    //END COLLECTION VIEW FUNCTIONS
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        timeMSGSent = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .medium);
        let expressionDataString = ", Exp Detected At: " + timeExpressionDetected + ", " + expressionData + " Previous Exp: " + resetEXPData ;
        let info = senderId + " MSG Sent: " + timeMSGSent + expressionDataString;
        MessagesHandler.Instance.sendMessage(senderID: info, senderName: currentExpression, text: text);
        self.finishSendingMessage();
    }
    
    //DELEGATION FUNCTIONS
    
    func messageReceived(senderID: String, senderName: String, text: String) {
        let currentUser = String(senderID.prefix(28))
        messages.append(JSQMessage(senderId: currentUser, displayName: senderName, text: text));
        collectionView.reloadData();
        runSession = true;
    }
    
    //END DELEGATION FUNCTIONS
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        DBProvider.Instance.messagesRef.removeAllObservers();
    }
    
    @IBAction func emotionReset(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.runSession = true;
            self.resetEXPData = self.expressionData;
              }
    }
    
    var seconds = 120;
    var reset = false;
    @IBOutlet weak var countdown: UIButton!
    @IBOutlet weak var timingChat: UINavigationItem!
    @IBAction func count(_ sender: Any) {
        if(reset == false){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatVC.counter), userInfo: nil, repeats: true);
            reset = true;
        }
        else{
            timer.invalidate();
            timingChat.prompt = "-click again to restart-";
            seconds = 120
            reset = false;
        }
    }
    @objc func counter(){
        seconds -= 1;
        timingChat.prompt = String(seconds) + " Seconds";
        if (seconds == 0){
            timer.invalidate();
        }
    }
    
    deinit {
        DBProvider.Instance.messagesRef.removeAllObservers();
    }
    
} //class
