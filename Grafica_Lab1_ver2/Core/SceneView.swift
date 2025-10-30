import SwiftUI

//  Кабинетная проекция

func cabinetMatrix() -> Matrix4 {
    let px = cos(Float.pi / 4) * 0.5   // cos(45) * 0.5
    let py = sin(Float.pi / 4) * 0.5   // sin(45) * 0.5

    return Matrix4(
        m11: 1,  m12: 0,  m13: 0, m14: 0,
        m21: 0,  m22: 1,  m23: 0, m24: 0,
        m31: px, m32: py, m33: 1, m34: 0,
        m41: 0,  m42: 0,  m43: 0, m44: 1
    )
}

// Преобразователь 3D -> 2D
struct Projector {
    var pixelsPerUnit: Float = 100.0

    func project(_ p: Vec3, canvasSize: CGSize) -> CGPoint {
        // Применяем проекцию
        let P = cabinetMatrix()
        let pp = P.transformPoint(p)
        
        // Переводим в координаты экрана
        let cx = canvasSize.width / 2.0
        let cy = canvasSize.height / 2.0
        let x2 = CGFloat(pp.x * pixelsPerUnit)
        let y2 = CGFloat(pp.y * pixelsPerUnit)
        return CGPoint(x: cx + x2, y: cy - y2)
    }
}
