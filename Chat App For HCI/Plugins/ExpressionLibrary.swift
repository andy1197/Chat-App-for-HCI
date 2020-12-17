//
//  ExpressionsPlayground.swift
//  Chat App For HCI
//
//  Created by Andy Wang on 5/22/20.
//  Copyright © 2020 Andy Wang. All rights reserved.
//
//  Alternative expression detection method from the "Expressions" class.
//  I have left that class' code in as an archive as I did not create it but
//  heavily edited it.
//
//  The old method ran a fairly trivial threshold checker using IF statements.
//  Upon testing, this method proved too simple to accurately recognize negative emotions.
//

import Foundation
import UIKit
import ARKit

/*
 getName() returns the name of the expression.
 
 score() returns a value between 0 and 100. The higher this score, the more likely the expression.
         In rare occasions, values above 100 can be returned based on the formula.
 */
protocol Expressions: NSObject {
    func getName() -> String
    func score(face: ARFaceAnchor) -> Double 
}

class Happy: NSObject {
    func getName() -> String {
        return "Happy"
    }
    func score(face: ARFaceAnchor) -> Double {
        guard let smileLeft = face.blendShapes[.mouthSmileLeft], let smileRight = face.blendShapes[.mouthSmileRight], let cheekSquintLeft = face.blendShapes[.cheekSquintLeft], let cheekSquintRight = face.blendShapes[.cheekSquintRight], let noseSneerRight = face.blendShapes[.noseSneerRight], let noseSneerLeft = face.blendShapes[.noseSneerLeft], let eyeSquintLeft = face.blendShapes[.eyeSquintLeft], let eyeSquintRight = face.blendShapes[.eyeSquintRight] else {
            return -1.0;
        }
        
        // SCORE CALCULATION FORMULA
        var score = 0.0
        let averageSmile = (Double(truncating: smileRight) - calibratedValues.mouthSmileRight_CB + Double(truncating: smileLeft) - calibratedValues.mouthSmileLeft_CB) / 2
        let averageCheekSquint = (Double(truncating: cheekSquintLeft) - calibratedValues.cheekSquintLeft_CB + Double(truncating: cheekSquintRight) - calibratedValues.cheekSquintRight_CB) / 2
        let averageNoseSneer = (Double(truncating: noseSneerRight) - calibratedValues.noseSneerRight_CB + Double(truncating:noseSneerLeft) - calibratedValues.noseSneerLeft_CB) / 2
        let averageEyeSquint = (Double(truncating: eyeSquintLeft) - calibratedValues.eyeSquintLeft_CB + Double(truncating: eyeSquintRight) - calibratedValues.eyeSquintRight_CB) / 2
        
        if (averageSmile > 0.10) {
            if (averageSmile > 0.5) { // almost guaranteed Smile
                score = 100
                return score
            }
            score = ((averageSmile) + (averageCheekSquint * 0.4) + (averageNoseSneer * 0.3) + (averageNoseSneer * 0.4) + (averageEyeSquint * 0.3)) * 100
            return score
        }
        else {
            return 0.0
        }
    }
}

class Surprise: NSObject {
    func getName() -> String {
        return "Surprise"
    }
    func score(face: ARFaceAnchor) -> Double {
        var jawOpenValue = -1.0
        var browOuterUpRightValue  = -1.0
        var browOuterUpLeftValue = -1.0
        guard let jawOpen = face.blendShapes[.jawOpen], let browOuterUpRight = face.blendShapes[.browOuterUpRight], let browOuterUpLeft = face.blendShapes[.browOuterUpLeft] else {
            return -1.0
        }
        jawOpenValue = Double(truncating: jawOpen)
        browOuterUpRightValue = Double(truncating: browOuterUpRight)
        browOuterUpLeftValue = Double(truncating: browOuterUpLeft)
        let averageBrowValue = (browOuterUpRightValue + browOuterUpLeftValue) / 2
        if (averageBrowValue > 0.2)
        {
            return (averageBrowValue + jawOpenValue * (0.2)) * 100
        }
        return 0.0
    }
}

class Disgust: NSObject {
    func getName() -> String {
        return "Disgust"
    }
    func score(face: ARFaceAnchor) -> Double {
        
        guard let mouthUpperUpRight = face.blendShapes[.mouthUpperUpRight], let mouthUpperUpLeft = face.blendShapes[.mouthUpperUpLeft], let cheekSquintRight = face.blendShapes[.cheekSquintRight], let cheekSquintLeft = face.blendShapes[.cheekSquintLeft], let noseSneerRight = face.blendShapes[.noseSneerRight], let noseSneerLeft = face.blendShapes[.noseSneerLeft] else {
            return 0.0
        }
        let avgCheekSquint = (Double(truncating: cheekSquintLeft) + Double(truncating: cheekSquintRight)) / 2
        let avgSneer = (Double(truncating: noseSneerRight) + Double(truncating: noseSneerLeft)) / 2
        let avgMouthUpper = (Double(truncating: mouthUpperUpLeft) + Double(truncating: mouthUpperUpRight)) / 2
        if ((((avgCheekSquint + avgSneer) / 2) + (avgMouthUpper / 5)) > 0.2)
        {
            return (((avgCheekSquint + avgSneer) / 2)*(1.5) + (avgMouthUpper / 4)) * 100
        }
        return 0.0
    }
}

class Sad: NSObject {
    func getName() -> String {
        return "Sad"
    }
    func score(face:ARFaceAnchor) -> Double {
        var browInnerUpValue = 0.0
        
        guard let frownLeft = face.blendShapes[.mouthFrownLeft], let frownRight = face.blendShapes[.mouthFrownRight], let browInnerUp = face.blendShapes[.browInnerUp] else {
            return 0.0
        }
        let avgFrown = (Double(truncating: frownLeft) + Double(truncating: frownRight)) / 2
        browInnerUpValue = Double(truncating: browInnerUp)
        if (((avgFrown + browInnerUpValue) / 2.0) > 0.2) {
        return ((avgFrown + browInnerUpValue) / 2.0)
        }
        return 0.0
    }
}

class Angry: NSObject {
    func name() -> String {
        return "Angry"
    }
    func score(face: ARFaceAnchor) -> Double {
        var browDownLeftValue = -1.0
        var browDownRightValue = -1.0
        var eyeWideRightValue = -1.0
        var eyeWideLeftValue = -1.0
        guard let browDownLeft = face.blendShapes[.browDownLeft], let browDownRight = face.blendShapes[.browDownRight], let eyeWideRight = face.blendShapes[.eyeWideRight], let eyeWideLeft = face.blendShapes[.eyeWideLeft] else {
            return 0.0
        }
        browDownLeftValue = Double(truncating: browDownLeft)
        browDownRightValue = Double(truncating: browDownRight)
        let avgBrowDown = (browDownLeftValue + browDownRightValue) / 2
        eyeWideRightValue = Double(truncating: eyeWideRight)
        eyeWideLeftValue = Double(truncating: eyeWideLeft)
        let avgEyeWide = (eyeWideRightValue + eyeWideLeftValue) / 2
        if (((avgBrowDown + (0.5 * avgEyeWide)) / 2) > 0.2) {
            return ((avgBrowDown + (0.5 * avgEyeWide)) / 2) * 100
        }
        return 0.0
    }
}

// method to be used in X-code console; returns all the values measured by ARFaceAnchor at the given moment
class Test {
    func printAllValues(face: ARFaceAnchor) {
        /*
         VALUES FOR EYEBROWS, CHEEKS, AND NOSE
         */
        guard let browDownLeft = face.blendShapes[.browDownLeft], let browDownRight = face.blendShapes[.browDownRight], let browInnerUp = face.blendShapes[.browInnerUp], let browOuterUpLeft = face.blendShapes[.browOuterUpLeft], let browOuterUpRight = face.blendShapes[.browOuterUpLeft], let cheekPuff = face.blendShapes[.cheekPuff], let cheekSquintLeft = face.blendShapes[.cheekSquintLeft], let cheekSquintRight = face.blendShapes[.cheekSquintRight], let noseSneerLeft = face.blendShapes[.noseSneerLeft], let noseSneerRight = face.blendShapes[.noseSneerRight] else {
            return
        }
        print("browDownLeft: \(browDownLeft)")
        print("browDownRight: \(browDownRight)")
        print("browInnerUp: \(browInnerUp)")
        print("browOuterUpLeft: \(browOuterUpLeft)")
        print("browOuterUpRight: \(browOuterUpRight)")
        print("cheekPuff: \(cheekPuff)")
        print("cheekSquintLeft: \(cheekSquintLeft)")
        print("cheekSquintRight: \(cheekSquintRight)")
        print("noseSneerLeft: \(noseSneerLeft)")
        print("noseSneerRight: \(noseSneerRight)")
        
        /*
         VALUES FOR EYES
         */
        guard let eyeBlinkLeft = face.blendShapes[.eyeBlinkLeft], let eyeBlinkRight = face.blendShapes[.eyeBlinkRight], let eyeLookInLeft = face.blendShapes[.eyeLookInLeft], let eyeLookInRight = face.blendShapes[.eyeLookInRight], let eyeLookDownLeft = face.blendShapes[.eyeLookDownLeft], let eyeLookDownRight = face.blendShapes[.eyeLookDownRight], let eyeLookOutLeft = face.blendShapes[.eyeLookOutLeft], let eyeLookOutRight = face.blendShapes[.eyeLookOutRight], let eyeLookUpLeft = face.blendShapes[.eyeLookUpLeft], let eyeLookUpRight = face.blendShapes[.eyeLookUpRight], let eyeSquintLeft = face.blendShapes[.eyeSquintLeft], let eyeSquintRight = face.blendShapes[.eyeSquintRight], let eyeWideLeft = face.blendShapes[.eyeWideLeft], let eyeWideRight = face.blendShapes[.eyeWideRight] else {
                return
        }
        print("eyeBlinkLeft: \(eyeBlinkLeft)")
        print("eyeBlinkRight: \(eyeBlinkRight)")
        print("eyeLookInLeft: \(eyeLookInLeft)")
        print("eyeLookInRight: \(eyeLookInRight)")
        print("eyeLookDownLeft: \(eyeLookDownLeft)")
        print("eyelookDownRight: \(eyeLookDownRight)")
        print("eyeLookOutLeft: \(eyeLookOutLeft)")
        print("eyeLookOutRight: \(eyeLookOutRight)")
        print("eyeLookUpLeft: \(eyeLookUpLeft)")
        print("eyeLookUpRight: \(eyeLookUpRight)")
        print("eyeSquintLeft: \(eyeSquintLeft)")
        print("eyeSquintRight: \(eyeSquintRight)")
        print("eyeWideLeft: \(eyeWideLeft)")
        print("eyeWideRight: \(eyeWideRight)")
        
        /*
         VALUES FOR MOUTH AND JAW
         */
        guard let jawForward = face.blendShapes[.jawForward], let jawLeft = face.blendShapes[.jawLeft], let jawRight = face.blendShapes[.jawRight], let jawOpen = face.blendShapes[.jawOpen], let mouthClose = face.blendShapes[.mouthClose], let mouthFunnel = face.blendShapes[.mouthFunnel], let mouthPucker = face.blendShapes[.mouthPucker], let mouthLeft = face.blendShapes[.mouthLeft], let mouthRight = face.blendShapes[.mouthRight], let mouthSmileLeft = face.blendShapes[.mouthSmileLeft], let mouthSmileRight = face.blendShapes[.mouthSmileRight], let mouthFrownLeft = face.blendShapes[.mouthFrownLeft], let mouthFrownRight = face.blendShapes[.mouthFrownRight], let mouthDimpleLeft = face.blendShapes[.mouthDimpleLeft], let mouthDimpleRight = face.blendShapes[.mouthDimpleRight], let mouthStretchLeft = face.blendShapes[.mouthStretchLeft], let mouthStretchRight = face.blendShapes[.mouthStretchRight], let mouthRollLower = face.blendShapes[.mouthRollLower], let mouthRollUpper = face.blendShapes[.mouthRollUpper], let mouthShrugLower = face.blendShapes[.mouthShrugLower], let mouthShrugUpper = face.blendShapes[.mouthShrugUpper], let mouthPressLeft = face.blendShapes[.mouthPressLeft], let mouthPressRight = face.blendShapes[.mouthPressRight], let mouthLowerDownLeft = face.blendShapes[.mouthLowerDownLeft], let mouthLowerDownRight = face.blendShapes[.mouthLowerDownRight], let mouthUpperUpLeft = face.blendShapes[.mouthUpperUpLeft], let mouthUpperUpRight = face.blendShapes[.mouthUpperUpRight] else {
            return
        }
        print("jawForward: \(jawForward)")
        print("jawLeft: \(jawLeft)")
        print("jawRight: \(jawRight)")
        print("jawOpen: \(jawOpen)")
        print("mouthClose: \(mouthClose)")
        print("mouthFunnel: \(mouthFunnel)")
        print("mouthPucker: \(mouthPucker)")
        print("mouthLeft: \(mouthLeft)")
        print("mouthRight: \(mouthRight)")
        print("mouthSmileLeft: \(mouthSmileLeft)")
        print("mouthSmileRight: \(mouthSmileRight)")
        print("mouthFrownLeft: \(mouthFrownLeft)")
        print("mouthFrownRight: \(mouthFrownRight)")
        print("mouthDimpleLeft: \(mouthDimpleLeft)")
        print("mouthDimpleRight: \(mouthDimpleRight)")
        print("mouthStretchLeft: \(mouthStretchLeft )")
        print("mouthStretchRight: \(mouthStretchRight)")
        print("mouthRollLower: \(mouthRollLower)")
        print("mouthRollUpper: \(mouthRollUpper)")
        print("mouthShrugLower: \(mouthShrugLower)")
        print("mouthShrugUpper: \(mouthShrugUpper )")
        print("mouthPressLeft: \(mouthPressLeft)")
        print("mouthPressRight: \(mouthPressRight)")
        print("mouthLowerDownLeft: \(mouthLowerDownLeft)")
        print("mouthLowerDownRight: \(mouthLowerDownRight)")
        print("mouthUpperUpLeft: \(mouthUpperUpLeft)")
        print("mouthUpperUpRight: \(mouthUpperUpRight)")
        
        return

    }
}
