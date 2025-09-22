import SwiftUI
import SceneKit

struct ContentView: View {
    // Состояния для управления трансформациями куба
    @State private var activeAxis: String = "X"  // выбранная ось для перемещения
    @State private var activeRotationAxis: String = "Y"  // выбранная ось для вращения

    @State private var translateX: Float = 0.0  // смещение по X
    @State private var translateY: Float = 0.0  // смещение по Y
    @State private var translateZ: Float = 0.0  // смещение по Z

    @State private var rotationY: Float = 0.0  // угол вращения вокруг Y
    @State private var rotationX: Float = 0.0  // угол вращения вокруг X
    @State private var rotationZ: Float = 0.0  // угол вращения вокруг Z

    @State private var scaleUniform: Double = 1.0   // общий коэффициент масштаба
    
    @State private var showTask = false                   // состояние для перехода на экран задачи

    var body: some View {
        VStack(spacing: 12) {
            // 3D сцена
            SceneView(scene: SceneFactory.makeScene(transform: finalTransformMatrix()),
                      options: [.allowsCameraControl, .autoenablesDefaultLighting])

            // Перемещение
            Group {
                HStack {
                    // Показываем текущую координату выбранной оси
                    Text("Перемещение \(activeAxis): \(currentTranslation(), specifier: "%.2f")")
                    
                    // Кнопки выбора оси перемещения
                    ForEach(["X", "Y", "Z"], id: \.self) { axis in
                        Button(axis) { activeAxis = axis }
                            .padding(.horizontal, 10)
                            .background(activeAxis == axis ? Color.blue.opacity(0.3) : Color(white: 0.95))
                            .cornerRadius(6)
                    }
                    Spacer()
                }
                // Слайдер для перемещения вдоль выбранной оси
                Slider(value: bindingForActiveAxis(), in: -4...4, step: 0.01)
                    .padding(.horizontal)
            }

            // Вращение
            Group {
                HStack {
                    Text("Вращение \(activeRotationAxis): \(currentRotation(), specifier: "%.2f")")

                    ForEach(["X", "Y", "Z"], id: \.self) { axis in
                        Button(axis) { activeRotationAxis = axis }
                            .padding(.horizontal, 10)
                            .background(activeRotationAxis == axis ? Color.green.opacity(0.3) : Color(white: 0.95))
                            .cornerRadius(6)
                    }
                    Spacer()
                }
                // Слайдер для вращения
                Slider(value: bindingForRotationAxis(), in: 0...Float.pi * 2, step: 0.01)
                    .padding(.horizontal)
            }

            // Масштаб
            Group {
                HStack {
                    Text("Масштаб: \(Float(scaleUniform), specifier: "%.2f")")
                    Spacer()
                }
               // Слайдер для масштаба
                Slider(value: $scaleUniform, in: 0.1...3.0, step: 0.01)

                .padding(.horizontal)
            }

            // Отображение матриц
            VStack(alignment: .leading, spacing: 6) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 12) {
                        MatrixView(title: "S (Scale)", matrix: scaleMatrix(s: Float(scaleUniform)))

                        // Вращение по выбранной оси
                        switch activeRotationAxis {
                        case "X": MatrixView(title: "R (Rotate X)", matrix: rotationXMatrix(angle: rotationX))
                        case "Y": MatrixView(title: "R (Rotate Y)", matrix: rotationYMatrix(angle: rotationY))
                        case "Z": MatrixView(title: "R (Rotate Z)", matrix: rotationZMatrix(angle: rotationZ))
                        default: EmptyView()
                        }

                        MatrixView(title: "T (Translate)",
                                   matrix: translationMatrix(tx: translateX, ty: translateY, tz: translateZ))
                        MatrixView(title: "M = T·R·S", matrix: finalTransformMatrix())
                    }
                }
                .padding(.horizontal)
                .font(.system(size: 12, design: .monospaced))
            }

          
            Button("Задание: вращение с плавной сменой направления") {
                showTask = true
            }
            .padding()
            .background(Color.orange.opacity(0.3))
            .cornerRadius(8)

            Spacer()
        }
        .padding(.top)
        .sheet(isPresented: $showTask) {
            TaskView()
        }
    }

    // Получить текущую координату перемещения по выбранной оси
    func currentTranslation() -> Float {
        switch activeAxis {
        case "X": return translateX
        case "Y": return translateY
        case "Z": return translateZ
        default: return 0
        }
    }
    // Получить текущий угол вращения по выбранной оси
    func currentRotation() -> Float {
        switch activeRotationAxis {
        case "X": return rotationX
        case "Y": return rotationY
        case "Z": return rotationZ
        default: return 0
        }
    }
    // Создать биндинг для выбранной оси перемещения
    func bindingForActiveAxis() -> Binding<Float> {
        switch activeAxis {
        case "X": return $translateX
        case "Y": return $translateY
        case "Z": return $translateZ
        default: return $translateX
        }
    }
    // Создать биндинг для выбранной оси вращения
    func bindingForRotationAxis() -> Binding<Float> {
        switch activeRotationAxis {
        case "X": return $rotationX
        case "Y": return $rotationY
        case "Z": return $rotationZ
        default: return $rotationY
        }
    }

    // Получить итоговую матрицу трансформации куба: M = T * R * S
     func finalTransformMatrix() -> SCNMatrix4 {
         let S = scaleMatrix(s: Float(scaleUniform))             // масштаб
         let Rx = rotationXMatrix(angle: rotationX)       // вращение по X
         let Ry = rotationYMatrix(angle: rotationY)       // вращение по Y
         let Rz = rotationZMatrix(angle: rotationZ)       // вращение по Z
         let T = translationMatrix(tx: translateX, ty: translateY, tz: translateZ) // перемещение

         let Rxy = multiply(Ry, Rx)                       // комбинированное вращение X + Y
         let Rxyz = multiply(Rz, Rxy)                     // комбинированное вращение X+Y+Z
         let RS = multiply(Rxyz, S)                       // вращение + масштаб
         let TRS = multiply(T, RS)                        // перемещение + вращение + масштаб

         return TRS
     }
 }

struct TaskView: View {
    @State private var angle: Float = 0
    @State private var direction: Float = 1 // direction это просто множитель, который определяет в какую сторону крутится куб
    @State private var axis: String = "Y"

    var body: some View {
        VStack(spacing: 12) {
            SceneView(
                scene: SceneFactory.makeScene(transform: finalMatrix()),
                options: [.autoenablesDefaultLighting, .allowsCameraControl]
            )
            .frame(height: 400)

            HStack(spacing: 12) {
                            ForEach(["X","Y","Z"], id: \.self) { a in
                                Button(a) { axis = a }
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 14)
                                    .background(axis == a ? Color.blue.opacity(0.25) : Color(white: 0.95))
                                    .cornerRadius(8)
                            }
                        }

            Text("Ось: \(axis)")
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                angle += 0.02 * direction
            }
            // каждые 4 секунды direction *= -1. То есть знак меняется, и вращение идёт то туда, то обратно.
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true) { _ in
                direction *= -1
            }
        }
    }

    func finalMatrix() -> SCNMatrix4 {
        switch axis {
        case "X": return rotationXMatrix(angle: angle)
        case "Z": return rotationZMatrix(angle: angle)
        default:  return rotationYMatrix(angle: angle)
        }
    }
}


#Preview {
    ContentView()
}
