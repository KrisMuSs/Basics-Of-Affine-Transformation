////
////  MatrixView.swift
////  Grafica_Lab1_ver2
////
////  Created by Артем Мерзликин on 07.09.2025.
////
//
//import SwiftUI
//import SceneKit
//
//
//// Маленький компонент для показа матрицы 4x4
//struct MatrixView: View {
//    let title: String
//    let matrix: SCNMatrix4
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 4) {
//            Text(title).bold().font(.system(size: 12))
//            VStack(spacing: 4) {
//                rowView(r0: matrix.m11, r1: matrix.m12, r2: matrix.m13, r3: matrix.m14)
//                rowView(r0: matrix.m21, r1: matrix.m22, r2: matrix.m23, r3: matrix.m24)
//                rowView(r0: matrix.m31, r1: matrix.m32, r2: matrix.m33, r3: matrix.m34)
//                rowView(r0: matrix.m41, r1: matrix.m42, r2: matrix.m43, r3: matrix.m44)
//            }
//            .padding(6)
//            .background(Color(white: 0.95))
//            .cornerRadius(6)
//        }
//    }
//
//    func rowView(r0: Float, r1: Float, r2: Float, r3: Float) -> some View {
//        HStack(spacing: 6) {
//            Text(String(format: "%6.2f", r0))
//            Text(String(format: "%6.2f", r1))
//            Text(String(format: "%6.2f", r2))
//            Text(String(format: "%6.2f", r3))
//        }
//    }
//}
