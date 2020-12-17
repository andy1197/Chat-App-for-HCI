//
//  Expressions.swift
//  Chat App For HCI
//
//  Created by Sudeep Raj on 7/7/18.
//  Collaborators: Andy Wang 
//  Copyright © 2018 Sudeep Raj. All rights reserved.
//
//  *******THIS CODE IS ARCHIVED AND NOT CURRENTLY IN USE*******
//
//

import Foundation
import UIKit
import ARKit

class Expression: NSObject {
    func name() -> String {
        //should return values for corresponding coefficients
        return ""
    }
    func isExpressing(from: ARFaceAnchor) -> String {
        // should return true when the ARFaceAnchor is performing the expression we want
        return ""
    }
}

class SmileExpression: Expression {
    override func name() -> String {
        return "Smile"
    }
    override func isExpressing(from: ARFaceAnchor) -> String {
        var smileLeftValue = -1.0
        var smileRightValue = -1.0
        
        guard let smileLeft = from.blendShapes[.mouthSmileLeft], let smileRight = from.blendShapes[.mouthSmileRight] else {
            return ""
        }
        smileLeftValue = Double(truncating: smileLeft)
        smileRightValue = Double(truncating: smileRight)
        let average = (smileLeftValue + smileRightValue) / 2
        
        if (average >= 0.5)
        {
            return "BIG SMILE -- Values: SmileLeft \(smileLeftValue), SmileRight \(smileRightValue)"
        }
        else if (average >= 0.4)
        {
            return "NORMAL SMILE -- Values: SmileLeft \(smileLeftValue), SmileRight \(smileRightValue)"
        }
        else if (average >= 0.3)
        {
            return "LIGHT SMILE -- Values: SmileLeft \(smileLeftValue), SmileRight \(smileRightValue)"
        }
        else
        {
            return ""
        }
    }
}

class SurpriseExpression: Expression {
    override func name() -> String {
        return "Surprised"
    }
    override func isExpressing(from: ARFaceAnchor) -> String {
        var jawOpenValue = -1.0
        var browOuterUpRightValue  = -1.0
        var browOuterUpLeftValue = -1.0
        
        guard let jawOpen = from.blendShapes[.jawOpen], let browOuterUpRight = from.blendShapes[.browOuterUpRight], let browOuterUpLeft = from.blendShapes[.browOuterUpLeft] else {
            return ""
        }
    
        jawOpenValue = Double(truncating: jawOpen)
        browOuterUpRightValue = Double(truncating: browOuterUpRight)
        browOuterUpLeftValue = Double(truncating: browOuterUpLeft)
        
        let averageBrowValue = (browOuterUpRightValue + browOuterUpLeftValue) / 2
        
        if (averageBrowValue > 0.35 && jawOpen.floatValue > 0.2) {
            return "JAW DROPPING SURPRISE -- Values: JawOpen \(jawOpenValue), browOuterUpRight \(browOuterUpRightValue), browOuterUpLeft \(browOuterUpLeftValue)"
        }
        else if (averageBrowValue > 0.3) {
            return "SURPRISE -- Values: JawOpen \(jawOpenValue), browOuterUpRight \(browOuterUpRightValue), browOuterUpLeft \(browOuterUpLeftValue)"
        }
        else if (averageBrowValue > 0.25) {
            return "INTRIGUED -- Values: JawOpen \(jawOpenValue), browOuterUpRight \(browOuterUpRightValue), browOuterUpLeft \(browOuterUpLeftValue)"
        }
        else
        {
            return ""
        }
    }
}

class DisgustExpression: Expression {
    override func name() -> String {
        return "Disgusted"
    }
    override func isExpressing(from: ARFaceAnchor) -> String {
        var mouthUpperUpRightValue = -1.0
        var mouthUpperUpLeftValue = -1.0
        var cheekSquintRightValue = -1.0
        var cheekSquintLeftValue = -1.0
        var noseSneerRightValue = -1.0
        var noseSneerLeftValue = -1.0
        guard let mouthUpperUpRight = from.blendShapes[.mouthUpperUpRight], let mouthUpperUpLeft = from.blendShapes[.mouthUpperUpLeft], let cheekSquintRight = from.blendShapes[.cheekSquintRight], let cheekSquintLeft = from.blendShapes[.cheekSquintLeft], let noseSneerRight = from.blendShapes[.noseSneerRight], let noseSneerLeft = from.blendShapes[.noseSneerLeft] else {
            return ""
        }
        mouthUpperUpRightValue = Double(truncating: mouthUpperUpRight)
        mouthUpperUpLeftValue = Double(truncating: mouthUpperUpLeft)
        cheekSquintRightValue = Double(truncating: cheekSquintRight)
        cheekSquintLeftValue = Double(truncating: cheekSquintLeft)
        noseSneerRightValue = Double(truncating: noseSneerRight)
        noseSneerLeftValue = Double(truncating: noseSneerLeft)
        
        let avgCheekSquint = (cheekSquintRightValue + cheekSquintLeftValue) / 2
        let avgSneer = (noseSneerLeftValue + noseSneerRightValue) / 2
        let avgMouthUpper = (mouthUpperUpLeftValue + mouthUpperUpRightValue) / 2

        if (avgCheekSquint > 0.25 && avgSneer > 0.25 && avgMouthUpper > 0.25) {
            return "DISGUST -- Values: avgMouthUpper \(avgMouthUpper), avgSneer \(avgSneer), avgCheekSquint \(avgCheekSquint)"
        }
        else if ((avgCheekSquint > 0.25 && avgSneer > 0.25) || (avgCheekSquint > 0.2 && avgSneer > 0.2 && avgMouthUpper > 0.2)) {
            return "MILD DISGUST -- Values: avgMouthUpper \(avgMouthUpper), avgSneer \(avgSneer), avgCheekSquint \(avgCheekSquint)"
        }
        else if (avgCheekSquint > 0.2 && avgSneer > 0.15) {
            return "CONFUSION -- Values: mouthUpperUpRight \(mouthUpperUpRightValue), mouthUpperUpLeft \(mouthUpperUpLeftValue), cheekSquintRight \(cheekSquintRightValue), cheekSquintLeft \(cheekSquintLeftValue), noseSneerRight \(noseSneerRightValue), noseSneerLeft \(noseSneerLeftValue)"
        }
        else {
            return ""
        }
    }
}

class FrownExpression: Expression {
    override func name() -> String {
        return "Frown"
    }
    override func isExpressing(from: ARFaceAnchor) -> String {
        var frownLeftValue = -1.0
        var frownRightValue = -1.0
        var browInnerUpValue = -1.0
        
        guard let frownLeft = from.blendShapes[.mouthFrownLeft], let frownRight = from.blendShapes[.mouthFrownRight], let browInnerUp = from.blendShapes[.browInnerUp] else {
            return ""
        }
        
        if(frownLeft.floatValue > 0.3 && frownRight.floatValue > 0.3 && browInnerUp.floatValue > 0.3) {
            frownLeftValue = Double(truncating: frownLeft)
            frownRightValue = Double(truncating: frownRight)
            browInnerUpValue = Double(truncating: browInnerUp)
            return "SAD - Values: FrownLeft \(frownLeftValue), FrownRight \(frownRightValue), browInner \(browInnerUpValue)"
        } else {
            return ""
        }
    }
}

class AngerExpression: Expression {
    override func name() -> String {
        return "Be Angry"
    }
    override func isExpressing(from: ARFaceAnchor) -> String {
        var browDownLeftValue = -1.0
        var browDownRightValue = -1.0
        var eyeWideRightValue = -1.0
        var eyeWideLeftValue = -1.0
        guard let browDownLeft = from.blendShapes[.browDownLeft], let browDownRight = from.blendShapes[.browDownRight], let eyeWideRight = from.blendShapes[.eyeWideRight], let eyeWideLeft = from.blendShapes[.eyeWideLeft] else {
            return ""
        }
        
        if(browDownLeft.floatValue > 0.3 && browDownRight.floatValue > 0.3 && eyeWideRight.floatValue > 0.1 && eyeWideLeft.floatValue > 0.1) {
            browDownLeftValue = Double(truncating: browDownLeft)
            browDownRightValue = Double(truncating: browDownRight)
            eyeWideRightValue = Double(truncating: eyeWideRight)
            eyeWideLeftValue = Double(truncating: eyeWideLeft)
            return "ANGER - Values: BrowDownLeft \(browDownLeftValue), BrowDownRight \(browDownRightValue), eyeWideRight \(eyeWideRightValue), eyeWideLeft \(eyeWideLeftValue)"
        } else {
            return ""
        }
    }
}

class PuckerUpExpression: Expression {
    override func name() -> String {
        return "Pucker"
    }
    override func isExpressing(from: ARFaceAnchor) -> String {
        var mouthPuckerValue = -1.0
        guard let mouthPucker = from.blendShapes[.mouthPucker] else {
            return ""
        }
        
        if(mouthPucker.doubleValue > 0.8) {
            mouthPuckerValue = Double(truncating: mouthPucker)
            return "Pucker- Values: MouthPucker \(mouthPuckerValue)"
        } else {
            return ""
        }
    }
}
