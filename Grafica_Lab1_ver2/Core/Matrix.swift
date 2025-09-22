//
//  Matrix.swift
//  Grafica_Lab1_ver2
//
//  Created by Артем Мерзликин on 07.09.2025.
//

import SceneKit

// Матрицы

// Матрица переноса T
func translationMatrix(tx: Float, ty: Float, tz: Float) -> SCNMatrix4 {
    return SCNMatrix4(
        m11: 1, m12: 0, m13: 0, m14: 0,
        m21: 0, m22: 1, m23: 0, m24: 0,
        m31: 0, m32: 0, m33: 1, m34: 0,
        m41: tx, m42: ty, m43: tz, m44: 1
    )
}

// Матрица масштабирования S 
func scaleMatrix(s: Float) -> SCNMatrix4 {
    return SCNMatrix4(
        m11: s, m12: 0, m13: 0, m14: 0,
        m21: 0, m22: s, m23: 0, m24: 0,
        m31: 0, m32: 0, m33: s, m34: 0,
        m41: 0, m42: 0, m43: 0, m44: 1
    )
}

// Матрица вращения вокруг оси Y
func rotationYMatrix(angle: Float) -> SCNMatrix4 {
    let c = cos(angle)
    let s = sin(angle)
    return SCNMatrix4(
        m11:   c, m12: 0, m13:  -s, m14: 0,
        m21:   0, m22: 1, m23:  0, m24: 0,
        m31:  s, m32: 0, m33:  c, m34: 0,
        m41:   0, m42: 0, m43:  0, m44: 1
    )
}

// Матрица вращения вокруг оси X
func rotationXMatrix(angle: Float) -> SCNMatrix4 {
    let c = cos(angle)
    let s = sin(angle)
    return SCNMatrix4(
        m11:  1, m12:  0,  m13:  0, m14: 0,
        m21:  0, m22:  c,  m23: s, m24: 0,
        m31:  0, m32:  -s,  m33:  c, m34: 0,
        m41:  0, m42:  0,  m43:  0, m44: 1
    )
}

// Матрица вращения вокруг оси Z
func rotationZMatrix(angle: Float) -> SCNMatrix4 {
    let c = cos(angle)
    let s = sin(angle)
    return SCNMatrix4(
        m11:  c,  m12: s, m13:  0, m14: 0,
        m21:  -s,  m22:  c, m23:  0, m24: 0,
        m31:  0,  m32:  0, m33:  1, m34: 0,
        m41:  0,  m42:  0, m43:  0, m44: 1
    )
}
