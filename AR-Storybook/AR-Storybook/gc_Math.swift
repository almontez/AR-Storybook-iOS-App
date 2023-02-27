//
//  gc_Math.swift
//
//  Created by Garrick Chan on 2/20/23.
//

import Foundation
import SpriteKit

// Returns the angle, in radians, between two 2D vectors
func gc_simd_angle2D(v1: simd_float2, v2: simd_float2) -> Float{
    let v1_n = simd_normalize(v1)
    let v2_n = simd_normalize(v2)
    let dotProduct = simd_dot(v1_n, v2_n)
    return acos(dotProduct)
}
