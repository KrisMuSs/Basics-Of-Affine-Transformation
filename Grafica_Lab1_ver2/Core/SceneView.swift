import SceneKit
import SwiftUI
import UIKit 

struct SceneFactory {
    // Создание сцены
    static func makeScene(transform: SCNMatrix4) -> SCNScene {
        let scene = SCNScene() // создаём пустую сцену

        // камера
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera() // создаём камеру
        cameraNode.position = SCNVector3(0, 0, 8) // ставим её на некотором расстоянии от центра
        scene.rootNode.addChildNode(cameraNode)  // добавляем в корень сцены

        // ОСИ координат (фон)
        let axes = axesNode(length: 6.0) // создаём узел с осями X,Y,Z
        // добавляем в корень сцены
        scene.rootNode.addChildNode(axes)

        // куб
        let cubeNode = wireframeCube(size: 2.0)
        // применяем матрицу трансформации (перемещение, вращение, масштаб)
        cubeNode.transform = transform

        // добавляем куб в сцену
        scene.rootNode.addChildNode(cubeNode)

        return scene
    }


    static func wireframeCube(size: Float) -> SCNNode {
        let node = SCNNode()

        // Вариант с кубом
       // let v = makeCube(s: size / 2.0)
        
        // Вариант с буквой М
         let v = make3DM(s: 1.0)

        // создаём линии между каждой парой вершин

        for i in stride(from: 0, to: v.count, by: 2) {
            let lineNode = line(from: v[i], to: v[i+1], color: UIColor.systemBlue)
            node.addChildNode(lineNode)
        }
        return node
    }
    static func make3DM(s: Float) -> [SCNVector3] {
        let d: Float = 0.4 // глубина по оси Z

        return [
            // Левая вертикаль
            SCNVector3(-s, -s, 0), SCNVector3(-s,  s, 0),
            SCNVector3(-s, -s, d), SCNVector3(-s,  s, d),
            SCNVector3(-s, -s, 0), SCNVector3(-s, -s, d),
            SCNVector3(-s,  s, 0), SCNVector3(-s,  s, d),

            // Левая диагональ
            SCNVector3(-s,  s, 0), SCNVector3(0, 0, 0),
            SCNVector3(-s,  s, d), SCNVector3(0, 0, d),
            SCNVector3(-s,  s, 0), SCNVector3(-s,  s, d),
            SCNVector3(0, 0, 0),   SCNVector3(0, 0, d),

            // Правая диагональ
            SCNVector3(0, 0, 0), SCNVector3(s,  s, 0),
            SCNVector3(0, 0, d), SCNVector3(s,  s, d),
            SCNVector3(0, 0, 0), SCNVector3(0, 0, d),
            SCNVector3(s,  s, 0), SCNVector3(s,  s, d),

            // Правая вертикаль
            SCNVector3(s,  s, 0), SCNVector3(s, -s, 0),
            SCNVector3(s,  s, d), SCNVector3(s, -s, d),
            SCNVector3(s,  s, 0), SCNVector3(s,  s, d),
            SCNVector3(s, -s, 0), SCNVector3(s, -s, d)
        ]
    }
    static func makeCube(s: Float) -> [SCNVector3] {
        return [
            SCNVector3(-s, -s, -s), SCNVector3(s, -s, -s),
            SCNVector3(s, -s, -s), SCNVector3(s,  s, -s),
            SCNVector3(s,  s, -s), SCNVector3(-s,  s, -s),
            SCNVector3(-s,  s, -s), SCNVector3(-s, -s, -s),
            
            SCNVector3(-s, -s,  s), SCNVector3(s, -s,  s),
            SCNVector3(s, -s,  s), SCNVector3(s,  s,  s),
            SCNVector3(s,  s,  s), SCNVector3(-s,  s,  s),
            SCNVector3(-s,  s,  s), SCNVector3(-s, -s,  s),
            
            SCNVector3(-s, -s, -s), SCNVector3(-s, -s,  s),
            SCNVector3(s, -s, -s),  SCNVector3(s, -s,  s),
            SCNVector3(s,  s, -s),  SCNVector3(s,  s,  s),
            SCNVector3(-s,  s, -s), SCNVector3(-s,  s,  s)
        ]
    }
    
    //  Оси координат X (красная), Y (зелёная), Z (синяя)
    static func axesNode(length: Float) -> SCNNode {
        let node = SCNNode()

        // создаём линии осей
        let half: Float = length / 2.0
        let xLine = line(from: SCNVector3(-half, 0, 0), to: SCNVector3(half, 0, 0), color: UIColor.systemRed)
        let yLine = line(from: SCNVector3(0, -half, 0), to: SCNVector3(0, half, 0), color: UIColor.systemGreen)
        let zLine = line(from: SCNVector3(0, 0, -half), to: SCNVector3(0, 0, half), color: UIColor.systemBlue)

        // Добавляем маленькие квадраты на концах вмемсто стрелок
        let markerSize: CGFloat = 0.06
        let xMarker = markerPlane(color: UIColor.systemRed, size: markerSize)
        xMarker.position = SCNVector3(half + 0.15, 0, 0)
        let yMarker = markerPlane(color: UIColor.systemGreen, size: markerSize)
        yMarker.position = SCNVector3(0, half + 0.15, 0)
        let zMarker = markerPlane(color: UIColor.systemBlue, size: markerSize)
        zMarker.position = SCNVector3(0, 0, half + 0.15)

        // добавляем линии и маркеры в узел
        node.addChildNode(xLine)
        node.addChildNode(yLine)
        node.addChildNode(zLine)
        node.addChildNode(xMarker)
        node.addChildNode(yMarker)
        node.addChildNode(zMarker)

        // Делаем оси чуть тусклее
        node.opacity = 0.85

        return node
    }

    // Создаем квадратики для указания направления на конец осей
    static func markerPlane(color: UIColor, size: CGFloat) -> SCNNode {
        let plane = SCNPlane(width: size, height: size)
        plane.firstMaterial = SCNMaterial()
        plane.firstMaterial?.diffuse.contents = color
        plane.firstMaterial?.isDoubleSided = true
        let node = SCNNode(geometry: plane)
        // Повернем эту плоскость
        node.eulerAngles = SCNVector3(-Float.pi/4, 0, 0)
        return node
    }

    // Создаем линии между двумя точками с цветом
    static func line(from: SCNVector3, to: SCNVector3, color: UIColor) -> SCNNode {
        let source = SCNGeometrySource(vertices: [from, to])
        let indices: [UInt32] = [0, 1]
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        let geo = SCNGeometry(sources: [source], elements: [element])
        let mat = SCNMaterial()
        mat.diffuse.contents = color
        mat.isDoubleSided = true
        mat.lightingModel = .constant
        geo.materials = [mat]
        let node = SCNNode(geometry: geo)

     
        return node
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
