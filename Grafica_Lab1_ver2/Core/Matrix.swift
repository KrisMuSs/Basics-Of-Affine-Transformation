//
//  Matrix.swift
//  Grafica_Lab1_ver2
//
//  Created by Артем Мерзликин on 07.09.2025.
//

import SwiftUI

// Матрицы

func translationMatrix(tx: Float, ty: Float, tz: Float) -> Matrix4 {
    // Перенос в нижнюю строку (m41, m42, m43)
    return Matrix4(
        m11: 1, m12: 0, m13: 0, m14: 0,
        m21: 0, m22: 1, m23: 0, m24: 0,
        m31: 0, m32: 0, m33: 1, m34: 0,
        m41: tx, m42: ty, m43: tz, m44: 1
    )
}

func scaleMatrix(s: Float) -> Matrix4 {
    return Matrix4(
        m11: s, m12: 0, m13: 0, m14: 0,
        m21: 0, m22: s, m23: 0, m24: 0,
        m31: 0, m32: 0, m33: s, m34: 0,
        m41: 0, m42: 0, m43: 0, m44: 1
    )
}

func rotationXMatrix(angle: Float) -> Matrix4 {
    let c = cosf(angle); let s = sinf(angle)
    return Matrix4(
        m11: 1, m12: 0,  m13: 0, m14: 0,
        m21: 0, m22: c,  m23: s, m24: 0,
        m31: 0, m32: -s,  m33: c, m34: 0,
        m41: 0, m42: 0,  m43: 0, m44: 1
    )
}

func rotationYMatrix(angle: Float) -> Matrix4 {
    let c = cosf(angle); let s = sinf(angle)
    return Matrix4(
        m11:  c, m12: 0, m13: -s, m14: 0,
        m21:  0, m22: 1, m23:  0, m24: 0,
        m31:  s, m32: 0, m33:  c, m34: 0,
        m41:  0, m42: 0, m43:  0, m44: 1
    )
}

func rotationZMatrix(angle: Float) -> Matrix4 {
    let c = cosf(angle); let s = sinf(angle)
    return Matrix4(
        m11: c,  m12:s, m13: 0, m14:0,
        m21: -s,  m22: c, m23: 0, m24:0,
        m31: 0,  m32: 0, m33: 1, m34:0,
        m41: 0,  m42: 0, m43: 0, m44:1
    )
}

// Основная матрица для преобразований
struct Matrix4 {
    var m11: Float, m12: Float, m13: Float, m14: Float
    var m21: Float, m22: Float, m23: Float, m24: Float
    var m31: Float, m32: Float, m33: Float, m34: Float
    var m41: Float, m42: Float, m43: Float, m44: Float

    init(
        m11: Float = 1, m12: Float = 0, m13: Float = 0, m14: Float = 0,
        m21: Float = 0, m22: Float = 1, m23: Float = 0, m24: Float = 0,
        m31: Float = 0, m32: Float = 0, m33: Float = 1, m34: Float = 0,
        m41: Float = 0, m42: Float = 0, m43: Float = 0, m44: Float = 1
    ) {
        self.m11 = m11; self.m12 = m12; self.m13 = m13; self.m14 = m14
        self.m21 = m21; self.m22 = m22; self.m23 = m23; self.m24 = m24
        self.m31 = m31; self.m32 = m32; self.m33 = m33; self.m34 = m34
        self.m41 = m41; self.m42 = m42; self.m43 = m43; self.m44 = m44
    }

    init(_ a: [Float]) {
        precondition(a.count == 16)
        self.m11=a[0];  self.m12=a[1];  self.m13=a[2];  self.m14=a[3]
        self.m21=a[4];  self.m22=a[5];  self.m23=a[6];  self.m24=a[7]
        self.m31=a[8];  self.m32=a[9];  self.m33=a[10]; self.m34=a[11]
        self.m41=a[12]; self.m42=a[13]; self.m43=a[14]; self.m44=a[15]
    }

    // Умножение двух матриц
    func multiplied(by B: Matrix4) -> Matrix4 {
        func a(_ r:Int,_ c:Int) -> Float {
            return self.at(r,c)
        }
    
        func b(_ r:Int,_ c:Int) -> Float {
            return B.at(r,c)
        }
        
        var C = Matrix4()
        
        C.m11 = a(0,0)*b(0,0) + a(0,1)*b(1,0) + a(0,2)*b(2,0) + a(0,3)*b(3,0)
        C.m12 = a(0,0)*b(0,1) + a(0,1)*b(1,1) + a(0,2)*b(2,1) + a(0,3)*b(3,1)
        C.m13 = a(0,0)*b(0,2) + a(0,1)*b(1,2) + a(0,2)*b(2,2) + a(0,3)*b(3,2)
        C.m14 = a(0,0)*b(0,3) + a(0,1)*b(1,3) + a(0,2)*b(2,3) + a(0,3)*b(3,3)

        C.m21 = a(1,0)*b(0,0) + a(1,1)*b(1,0) + a(1,2)*b(2,0) + a(1,3)*b(3,0)
        C.m22 = a(1,0)*b(0,1) + a(1,1)*b(1,1) + a(1,2)*b(2,1) + a(1,3)*b(3,1)
        C.m23 = a(1,0)*b(0,2) + a(1,1)*b(1,2) + a(1,2)*b(2,2) + a(1,3)*b(3,2)
        C.m24 = a(1,0)*b(0,3) + a(1,1)*b(1,3) + a(1,2)*b(2,3) + a(1,3)*b(3,3)

        C.m31 = a(2,0)*b(0,0) + a(2,1)*b(1,0) + a(2,2)*b(2,0) + a(2,3)*b(3,0)
        C.m32 = a(2,0)*b(0,1) + a(2,1)*b(1,1) + a(2,2)*b(2,1) + a(2,3)*b(3,1)
        C.m33 = a(2,0)*b(0,2) + a(2,1)*b(1,2) + a(2,2)*b(2,2) + a(2,3)*b(3,2)
        C.m34 = a(2,0)*b(0,3) + a(2,1)*b(1,3) + a(2,2)*b(2,3) + a(2,3)*b(3,3)

        C.m41 = a(3,0)*b(0,0) + a(3,1)*b(1,0) + a(3,2)*b(2,0) + a(3,3)*b(3,0)
        C.m42 = a(3,0)*b(0,1) + a(3,1)*b(1,1) + a(3,2)*b(2,1) + a(3,3)*b(3,1)
        C.m43 = a(3,0)*b(0,2) + a(3,1)*b(1,2) + a(3,2)*b(2,2) + a(3,3)*b(3,2)
        C.m44 = a(3,0)*b(0,3) + a(3,1)*b(1,3) + a(3,2)*b(2,3) + a(3,3)*b(3,3)
        return C
    }
    // Доступ к элементам матрицы по индексам строки и столбца
    func at(_ r:Int,_ c:Int) -> Float {
        switch (r,c) {
        case (0,0):
            return m11;
        case (0,1):
            return m12;
        case (0,2):
            return m13;
        case (0,3):
            return m14
        case (1,0):
            return m21;
        case (1,1):
            return m22;
        case (1,2):
            return m23;
        case (1,3):
            return m24
        case (2,0):
            return m31;
        case (2,1):
            return m32;
        case (2,2):
            return m33;
        case (2,3):
            return m34
        case (3,0):
            return m41;
        case (3,1):
            return m42;
        case (3,2):
            return m43;
        case (3,3):
            return m44
        default:
            return 0
        }
    }

    // Умножение вектора на матрицу
    func transformPoint(_ p: Vec3) -> Vec3 {
        let x = p.x * m11 + p.y * m21 + p.z * m31 + 1 * m41
        let y = p.x * m12 + p.y * m22 + p.z * m32 + 1 * m42
        let z = p.x * m13 + p.y * m23 + p.z * m33 + 1 * m43
        let w = p.x * m14 + p.y * m24 + p.z * m34 + 1 * m44
        
        if w == 0 {
            return Vec3(x: x, y: y, z: z)
        }
        
        return Vec3(x: x / w, y: y / w, z: z / w)
    }
}

