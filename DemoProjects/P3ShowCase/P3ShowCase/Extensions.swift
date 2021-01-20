//
//  Extensions.swift
//  P3ShowCase
//
//  Created by JiangWang on 2021/1/20.
//

import Foundation


let linearP3ToLinearSRGBMatrix: matrix_float3x3 = {
    let col1 = float3([1.2249,  -0.2247,  0])
    let col2 = float3([-0.0420,   1.0419,  0])
    let col3 = float3([-0.0197,  -0.0786,  1.0979])
    return matrix_float3x3([col1, col2, col3])
}()

extension SIMD3 where Scalar == Float {
    
    var gammaDecoded: SIMD3<Float> {
        let f = {(c: Float) -> Float in
            if abs(c) <= 0.04045 {
                return c / 12.92
            }
            return sign(c) * powf((abs(c) + 0.055) / 1.055, 2.4)
        }
       return SIMD3<Float>(f(x), f(y), f(z))
    }
    
    var gammaEncoded: SIMD3<Float> {
        let f = {(c: Float) -> Float in
            if abs(c) <= 0.0031308 {
                return c * 12.92
            }
            return sign(c) * (powf(abs(c), 1/2.4) * 1.055 - 0.055)
        }
        return SIMD3<Float>(f(x), f(y), f(z))
     }
}

@objc class PixelConverter: NSObject {
    @objc static func toSRGB(_ p3: simd_float3) -> simd_float4 {
        // Note: gamma decoding not strictly necessary in this demo
        // because 0 and 1 always decode to 0 and 1
        let linearSrgb = p3.gammaDecoded * linearP3ToLinearSRGBMatrix
        let srgb = linearSrgb.gammaEncoded
        return SIMD4<Float>(x: srgb.x, y: srgb.y, z: srgb.z, w: 1.0)
    }
}
