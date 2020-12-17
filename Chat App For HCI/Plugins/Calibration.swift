//
//  Calibration.swift
//  Chat App For HCI
//
//  Created by Andy Wang on 5/26/20.
//  Copyright © 2020 Sudeep Raj. All rights reserved.
//
import Foundation
import UIKit
import ARKit

struct calibratedValues {
    static var browDownLeft_CB = 0.0
    static var browDownRight_CB = 0.0
    static var browInnerUp_CB = 0.0
    static var browOuterUpLeft_CB = 0.0
    static var browOuterUpRight_CB = 0.0
    static var cheekPuff_CB = 0.0
    static var cheekSquintLeft_CB = 0.0
    static var cheekSquintRight_CB = 0.0
    static var noseSneerLeft_CB = 0.0
    static var noseSneerRight_CB = 0.0
    // EYES
    static var eyeBlinkLeft_CB = 0.0
    static var eyeBlinkRight_CB = 0.0
    static var eyeLookInLeft_CB = 0.0
    static var eyeLookInRight_CB = 0.0
    static var eyeLookDownLeft_CB = 0.0
    static var eyeLookDownRight_CB = 0.0
    static var eyeLookOutLeft_CB = 0.0
    static var eyeLookOutRight_CB = 0.0
    static var eyeLookUpLeft_CB = 0.0
    static var eyeLookUpRight_CB = 0.0
    static var eyeSquintLeft_CB = 0.0
    static var eyeSquintRight_CB = 0.0
    static var eyeWideLeft_CB = 0.0
    static var eyeWideRight_CB = 0.0
    // MOUTH AND JAW
    static var jawForward_CB = 0.0
    static var jawLeft_CB = 0.0
    static var jawRight_CB = 0.0
    static var jawOpen_CB = 0.0
    static var mouthClose_CB = 0.0
    static var mouthFunnel_CB = 0.0
    static var mouthPucker_CB = 0.0
    static var mouthLeft_CB = 0.0
    static var mouthRight_CB = 0.0
    static var mouthSmileLeft_CB = 0.0
    static var mouthSmileRight_CB = 0.0
    static var mouthFrownLeft_CB = 0.0
    static var mouthFrownRight_CB = 0.0
    static var mouthDimpleLeft_CB = 0.0
    static var mouthDimpleRight_CB = 0.0
    static var mouthStretchLeft_CB = 0.0
    static var mouthStretchRight_CB = 0.0
    static var mouthRollLower_CB = 0.0
    static var mouthRollUpper_CB = 0.0
    static var mouthShrugLower_CB = 0.0
    static var mouthShrugUpper_CB = 0.0
    static var mouthPressLeft_CB = 0.0
    static var mouthPressRight_CB = 0.0
    static var mouthLowerDownLeft_CB = 0.0
    static var mouthLowerDownRight_CB = 0.0
    static var mouthUpperUpLeft_CB = 0.0
    static var mouthUpperUpRight_CB = 0.0
}
class Calibration: NSObject {
    // EYEBROWS, CHEEKS, NOSE
    
    
    public func calibrateAll(face: ARFaceAnchor) {
        /*
         VALUES FOR EYEBROWS, CHEEKS, AND NOSE
         */
        guard let browDownLeft = face.blendShapes[.browDownLeft], let browDownRight = face.blendShapes[.browDownRight], let browInnerUp = face.blendShapes[.browInnerUp], let browOuterUpLeft = face.blendShapes[.browOuterUpLeft], let browOuterUpRight = face.blendShapes[.browOuterUpLeft], let cheekPuff = face.blendShapes[.cheekPuff], let cheekSquintLeft = face.blendShapes[.cheekSquintLeft], let cheekSquintRight = face.blendShapes[.cheekSquintRight], let noseSneerLeft = face.blendShapes[.noseSneerLeft], let noseSneerRight = face.blendShapes[.noseSneerRight] else {
            return
        }
        calibratedValues.browDownLeft_CB = Double(truncating: browDownLeft)
        calibratedValues.browDownRight_CB = Double(truncating: browDownRight)
        calibratedValues.browInnerUp_CB = Double(truncating: browInnerUp)
        calibratedValues.browOuterUpLeft_CB = Double(truncating: browOuterUpLeft)
        calibratedValues.browOuterUpRight_CB = Double(truncating: browOuterUpRight)
        calibratedValues.cheekPuff_CB = Double(truncating: cheekPuff)
        calibratedValues.cheekSquintLeft_CB = Double(truncating: cheekSquintLeft)
        calibratedValues.cheekSquintRight_CB = Double(truncating: cheekSquintRight)
        calibratedValues.noseSneerLeft_CB = Double(truncating: noseSneerLeft)
        calibratedValues.noseSneerRight_CB = Double(truncating: noseSneerRight)
        
        /*
         VALUES FOR EYES
         */
        guard let eyeBlinkLeft = face.blendShapes[.eyeBlinkLeft], let eyeBlinkRight = face.blendShapes[.eyeBlinkRight], let eyeLookInLeft = face.blendShapes[.eyeLookInLeft], let eyeLookInRight = face.blendShapes[.eyeLookInRight], let eyeLookDownLeft = face.blendShapes[.eyeLookDownLeft], let eyeLookDownRight = face.blendShapes[.eyeLookDownRight], let eyeLookOutLeft = face.blendShapes[.eyeLookOutLeft], let eyeLookOutRight = face.blendShapes[.eyeLookOutRight], let eyeLookUpLeft = face.blendShapes[.eyeLookUpLeft], let eyeLookUpRight = face.blendShapes[.eyeLookUpRight], let eyeSquintLeft = face.blendShapes[.eyeSquintLeft], let eyeSquintRight = face.blendShapes[.eyeSquintRight], let eyeWideLeft = face.blendShapes[.eyeWideLeft], let eyeWideRight = face.blendShapes[.eyeWideRight] else {
                return
        }
        calibratedValues.eyeBlinkLeft_CB = Double(truncating: eyeBlinkLeft)
        calibratedValues.eyeBlinkRight_CB = Double(truncating: eyeBlinkRight)
        calibratedValues.eyeLookInLeft_CB = Double(truncating: eyeLookInLeft)
        calibratedValues.eyeLookInRight_CB = Double(truncating: eyeLookInRight)
        calibratedValues.eyeLookDownLeft_CB = Double(truncating: eyeLookDownLeft)
        calibratedValues.eyeLookDownRight_CB = Double(truncating: eyeLookDownRight)
        calibratedValues.eyeLookOutLeft_CB = Double(truncating: eyeLookOutLeft)
        calibratedValues.eyeLookOutRight_CB = Double(truncating: eyeLookOutRight)
        calibratedValues.eyeLookUpLeft_CB = Double(truncating: eyeLookUpLeft)
        calibratedValues.eyeLookUpRight_CB = Double(truncating: eyeLookUpRight)
        calibratedValues.eyeSquintLeft_CB = Double(truncating: eyeSquintLeft)
        calibratedValues.eyeSquintRight_CB = Double(truncating: eyeSquintRight)
        calibratedValues.eyeWideLeft_CB = Double(truncating: eyeWideLeft)
        calibratedValues.eyeWideRight_CB = Double(truncating: eyeWideRight)
        
        /*
         VALUES FOR MOUTH AND JAW
         */
        guard let jawForward = face.blendShapes[.jawForward], let jawLeft = face.blendShapes[.jawLeft], let jawRight = face.blendShapes[.jawRight], let jawOpen = face.blendShapes[.jawOpen], let mouthClose = face.blendShapes[.mouthClose], let mouthFunnel = face.blendShapes[.mouthFunnel], let mouthPucker = face.blendShapes[.mouthPucker], let mouthLeft = face.blendShapes[.mouthLeft], let mouthRight = face.blendShapes[.mouthRight], let mouthSmileLeft = face.blendShapes[.mouthSmileLeft], let mouthSmileRight = face.blendShapes[.mouthSmileRight], let mouthFrownLeft = face.blendShapes[.mouthFrownLeft], let mouthFrownRight = face.blendShapes[.mouthFrownRight], let mouthDimpleLeft = face.blendShapes[.mouthDimpleLeft], let mouthDimpleRight = face.blendShapes[.mouthDimpleRight], let mouthStretchLeft = face.blendShapes[.mouthStretchLeft], let mouthStretchRight = face.blendShapes[.mouthStretchRight], let mouthRollLower = face.blendShapes[.mouthRollLower], let mouthRollUpper = face.blendShapes[.mouthRollUpper], let mouthShrugLower = face.blendShapes[.mouthShrugLower], let mouthShrugUpper = face.blendShapes[.mouthShrugUpper], let mouthPressLeft = face.blendShapes[.mouthPressLeft], let mouthPressRight = face.blendShapes[.mouthPressRight], let mouthLowerDownLeft = face.blendShapes[.mouthLowerDownLeft], let mouthLowerDownRight = face.blendShapes[.mouthLowerDownRight], let mouthUpperUpLeft = face.blendShapes[.mouthUpperUpLeft], let mouthUpperUpRight = face.blendShapes[.mouthUpperUpRight] else {
            return
        }
        calibratedValues.jawForward_CB = Double(truncating: jawForward)
        calibratedValues.jawLeft_CB = Double(truncating: jawLeft)
        calibratedValues.jawRight_CB = Double(truncating: jawRight)
        calibratedValues.jawOpen_CB = Double(truncating: jawOpen)
        calibratedValues.mouthClose_CB = Double(truncating: mouthClose)
        calibratedValues.mouthFunnel_CB = Double(truncating: mouthFunnel)
        calibratedValues.mouthPucker_CB = Double(truncating: mouthPucker)
        calibratedValues.mouthLeft_CB = Double(truncating: mouthLeft)
        calibratedValues.mouthRight_CB = Double(truncating: mouthRight)
        calibratedValues.mouthSmileLeft_CB = Double(truncating: mouthSmileLeft)
        calibratedValues.mouthSmileRight_CB = Double(truncating: mouthSmileRight)
        calibratedValues.mouthFrownLeft_CB = Double(truncating: mouthFrownLeft)
        calibratedValues.mouthFrownRight_CB = Double(truncating: mouthFrownRight)
        calibratedValues.mouthDimpleLeft_CB = Double(truncating: mouthDimpleLeft)
        calibratedValues.mouthDimpleRight_CB = Double(truncating: mouthDimpleRight)
        calibratedValues.mouthStretchLeft_CB = Double(truncating: mouthStretchLeft)
        calibratedValues.mouthStretchRight_CB = Double(truncating: mouthStretchRight)
        calibratedValues.mouthRollLower_CB = Double(truncating: mouthRollLower)
        calibratedValues.mouthRollUpper_CB = Double(truncating: mouthRollUpper)
        calibratedValues.mouthShrugLower_CB = Double(truncating: mouthShrugLower)
        calibratedValues.mouthShrugUpper_CB = Double(truncating: mouthShrugUpper)
        calibratedValues.mouthPressLeft_CB = Double(truncating: mouthPressLeft)
        calibratedValues.mouthPressRight_CB = Double(truncating: mouthPressRight)
        calibratedValues.mouthLowerDownLeft_CB = Double(truncating: mouthLowerDownLeft)
        calibratedValues.mouthLowerDownRight_CB = Double(truncating: mouthLowerDownRight)
        calibratedValues.mouthUpperUpLeft_CB = Double(truncating: mouthUpperUpLeft)
        calibratedValues.mouthUpperUpRight_CB = Double(truncating: mouthUpperUpRight)

        return;
    }
    
    
}

