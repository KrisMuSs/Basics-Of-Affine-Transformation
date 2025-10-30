////
////  MultiplyMatrix.swift
////  Grafica_Lab1_ver2
////
////  Created by Артем Мерзликин on 07.09.2025.
////
//
//import SceneKit
//
//// Умножение матриц (C = A * B), вручную (строчно-столбцовый метод)
//// Для итоговой M матрицы переумножаем их
//func multiply(_ A: SCNMatrix4, _ B: SCNMatrix4) -> SCNMatrix4 {
//    // Cij = sum_k Aik * Bkj
//    func a(_ r: Int, _ c: Int) -> Float {
//        switch (r, c) {
//        case (0,0):
//            return A.m11;
//        case (0,1):
//            return A.m12;
//        case (0,2):
//            return A.m13;
//        case (0,3):
//            return A.m14
//        case (1,0):
//            return A.m21;
//        case (1,1):
//            return A.m22;
//        case (1,2):
//            return A.m23;
//        case (1,3):
//            return A.m24
//        case (2,0):
//            return A.m31;
//        case (2,1):
//            return A.m32;
//        case (2,2):
//            return A.m33;
//        case (2,3):
//            return A.m34
//        case (3,0):
//            return A.m41;
//        case (3,1):
//            return A.m42;
//        case (3,2):
//            return A.m43;
//        case (3,3):
//            return A.m44
//        default:
//            return 0
//        }
//    }
//    func b(_ r: Int, _ c: Int) -> Float {
//        switch (r, c) {
//        case (0,0):
//            return B.m11;
//        case (0,1):
//            return B.m12;
//        case (0,2):
//            return B.m13;
//        case (0,3):
//            return B.m14
//        case (1,0):
//            return B.m21;
//        case (1,1):
//            return B.m22;
//        case (1,2):
//            return B.m23;
//        case (1,3):
//            return B.m24
//        case (2,0):
//            return B.m31;
//        case (2,1):
//            return B.m32;
//        case (2,2):
//            return B.m33;
//        case (2,3):
//            return B.m34
//        case (3,0):
//            return B.m41;
//        case (3,1):
//            return B.m42;
//        case (3,2):
//            return B.m43;
//        case (3,3):
//            return B.m44
//        default:
//            return 0
//        }
//    }
//
//    var C = SCNMatrix4()
//    C.m11 = a(0,0)*b(0,0) + a(0,1)*b(1,0) + a(0,2)*b(2,0) + a(0,3)*b(3,0)
//    C.m12 = a(0,0)*b(0,1) + a(0,1)*b(1,1) + a(0,2)*b(2,1) + a(0,3)*b(3,1)
//    C.m13 = a(0,0)*b(0,2) + a(0,1)*b(1,2) + a(0,2)*b(2,2) + a(0,3)*b(3,2)
//    C.m14 = a(0,0)*b(0,3) + a(0,1)*b(1,3) + a(0,2)*b(2,3) + a(0,3)*b(3,3)
//
//    C.m21 = a(1,0)*b(0,0) + a(1,1)*b(1,0) + a(1,2)*b(2,0) + a(1,3)*b(3,0)
//    C.m22 = a(1,0)*b(0,1) + a(1,1)*b(1,1) + a(1,2)*b(2,1) + a(1,3)*b(3,1)
//    C.m23 = a(1,0)*b(0,2) + a(1,1)*b(1,2) + a(1,2)*b(2,2) + a(1,3)*b(3,2)
//    C.m24 = a(1,0)*b(0,3) + a(1,1)*b(1,3) + a(1,2)*b(2,3) + a(1,3)*b(3,3)
//
//    C.m31 = a(2,0)*b(0,0) + a(2,1)*b(1,0) + a(2,2)*b(2,0) + a(2,3)*b(3,0)
//    C.m32 = a(2,0)*b(0,1) + a(2,1)*b(1,1) + a(2,2)*b(2,1) + a(2,3)*b(3,1)
//    C.m33 = a(2,0)*b(0,2) + a(2,1)*b(1,2) + a(2,2)*b(2,2) + a(2,3)*b(3,2)
//    C.m34 = a(2,0)*b(0,3) + a(2,1)*b(1,3) + a(2,2)*b(2,3) + a(2,3)*b(3,3)
//
//    C.m41 = a(3,0)*b(0,0) + a(3,1)*b(1,0) + a(3,2)*b(2,0) + a(3,3)*b(3,0)
//    C.m42 = a(3,0)*b(0,1) + a(3,1)*b(1,1) + a(3,2)*b(2,1) + a(3,3)*b(3,1)
//    C.m43 = a(3,0)*b(0,2) + a(3,1)*b(1,2) + a(3,2)*b(2,2) + a(3,3)*b(3,2)
//    C.m44 = a(3,0)*b(0,3) + a(3,1)*b(1,3) + a(3,2)*b(2,3) + a(3,3)*b(3,3)
//
//    return C
//}
