import SwiftUI
import Foundation

// Вектор
struct Vec3 {
    var x: Float
    var y: Float
    var z: Float
}



//  Фигуры

func cubeEdges(half: Float) -> [(Vec3, Vec3)] {
    let s = half
    let v0 = Vec3(x: -s,y: -s,z: -s)
    let v1 = Vec3(x:  s,y: -s,z: -s)
    let v2 = Vec3(x:  s,y:  s,z: -s)
    let v3 = Vec3(x: -s,y:  s,z: -s)
    let v4 = Vec3(x: -s,y: -s,z:  s)
    let v5 = Vec3(x:  s,y: -s,z:  s)
    let v6 = Vec3(x:  s,y:  s,z:  s)
    let v7 = Vec3(x: -s,y:  s,z:  s)
    
    return [
        (v0,v1),(v1,v2),(v2,v3),(v3,v0),
        (v4,v5),(v5,v6),(v6,v7),(v7,v4),
        (v0,v4),(v1,v5),(v2,v6),(v3,v7)
    ]
}


func make3DM(size: Float, depth: Float) -> [(Vec3, Vec3)] {
    let s = size

    let leftBottomFront   = Vec3(x: -s, y: -s,    z: 0)
    let leftTopFront      = Vec3(x: -s, y:  s,    z: 0)
    let centerBottomFront = Vec3(x:  0, y: -s+1, z: 0)
    let rightTopFront     = Vec3(x:  s, y:  s,    z: 0)
    let rightBottomFront  = Vec3(x:  s, y: -s,    z: 0)

    let leftBottomBack   = Vec3(x: -s, y: -s,    z: depth)   // A1
    let leftTopBack      = Vec3(x: -s, y:  s,    z: depth)   // B1
    let centerBottomBack = Vec3(x:  0, y: -s+1, z: depth)   // D1
    let rightTopBack     = Vec3(x:  s, y:  s,    z: depth)   // F1
    let rightBottomBack  = Vec3(x:  s, y: -s,    z: depth)   // G1

    var edges: [(Vec3, Vec3)] = []

    edges += [
        (leftBottomFront, leftTopFront),       // левая вертикаль
        (leftTopFront, centerBottomFront),     // левая диагональ
        (centerBottomFront, rightTopFront),    // правая диагональ
        (rightTopFront, rightBottomFront)      // правая вертикаль
    ]

    edges += [
        (leftBottomBack, leftTopBack),
        (leftTopBack, centerBottomBack),
        (centerBottomBack, rightTopBack),
        (rightTopBack, rightBottomBack)
    ]

    edges += [
        (leftBottomFront, leftBottomBack),
        (leftTopFront, leftTopBack),
        (centerBottomFront, centerBottomBack),
        (rightTopFront, rightTopBack),
        (rightBottomFront, rightBottomBack)
    ]

    return edges
}




struct WireframeCanvas: View {
    @Binding var tx: Double
    @Binding var ty: Double
    @Binding var tz: Double
    @Binding var rx: Double
    @Binding var ry: Double
    @Binding var rz: Double
    @Binding var scale: Double
    var useLetterM: Bool = false

    let projector = Projector()

    var body: some View {
        GeometryReader { _geo in
            Canvas { ctx, size in

                // Оси координат
                func drawAxis(_ a: Vec3, _ b: Vec3, color: Color, width: CGFloat = 1) {
                    let pa = projector.project(a, canvasSize: size)
                    let pb = projector.project(b, canvasSize: size)
                    var path = Path(); path.move(to: pa); path.addLine(to: pb)
                    ctx.stroke(path, with: .color(color), lineWidth: width)
                }

                // Сами оси
                let axisLen: Float = 3.0
                drawAxis(Vec3(x:-axisLen,y:0,z:0), Vec3(x:axisLen,y:0,z:0), color: .red.opacity(0.9), width: 1.5)
                drawAxis(Vec3(x:0,y:-axisLen,z:0), Vec3(x:0,y:axisLen,z:0), color: .green.opacity(0.9), width: 1.5)
                drawAxis(Vec3(x:0,y:0,z:-axisLen), Vec3(x:0,y:0,z:axisLen), color: .blue.opacity(0.9), width: 1.5)

                let txF = Float(tx)
                let tyF = Float(ty)
                let tzF = Float(tz)
                let rxF = Float(rx)
                let ryF = Float(ry)
                let rzF = Float(rz)
                let scaleF = Float(scale)

                let S = scaleMatrix(s: scaleF)
                let Rx = rotationXMatrix(angle: rxF)
                let Ry = rotationYMatrix(angle: ryF)
                let Rz = rotationZMatrix(angle: rzF)
                let R = Rx.multiplied(by: Ry).multiplied(by: Rz)
                let T = translationMatrix(tx: txF, ty: tyF, tz: tzF)
                let M = S.multiplied(by: R).multiplied(by: T)

                let edges = useLetterM ? make3DM(size: 1.0, depth: 0.4) : cubeEdges(half: 1.0)

                for (a,b) in edges {
                    let wa = M.transformPoint(a)
                    let wb = M.transformPoint(b)
                    let pa = projector.project(wa, canvasSize: size)
                    let pb = projector.project(wb, canvasSize: size)
                    var path = Path()
                    path.move(to: pa); path.addLine(to: pb)
                    ctx.stroke(path, with: .color(.primary), lineWidth: 2)
                }

                let px = projector.project(Vec3(x: axisLen+0.2, y: 0, z: 0), canvasSize: size)
                ctx.fill(Path(ellipseIn: CGRect(x: px.x-4, y: px.y-4, width: 8, height: 8)), with: .color(.red))
                let py = projector.project(Vec3(x: 0, y: axisLen+0.2, z: 0), canvasSize: size)
                ctx.fill(Path(ellipseIn: CGRect(x: py.x-4, y: py.y-4, width: 8, height: 8)), with: .color(.green))
                let pz = projector.project(Vec3(x: 0, y: 0, z: axisLen+0.2), canvasSize: size)
                ctx.fill(Path(ellipseIn: CGRect(x: pz.x-4, y: pz.y-4, width: 8, height: 8)), with: .color(.blue))
            }
            .background(Color(white: 0.98))
            .border(Color.gray.opacity(0.3))
        }
    }
}


struct ContentView: View {
    @State private var tx: Double = 0
    @State private var ty: Double = 0
    @State private var tz: Double = 0

    @State private var rx: Double = 0
    @State private var ry: Double = 0
    @State private var rz: Double = 0

    @State private var scale: Double = 1.0

    @State private var useM = false
    @State private var showTask = false

    var body: some View {
        VStack(spacing: 12) {
            WireframeCanvas(
                tx: $tx, ty: $ty, tz: $tz,
                rx: $rx, ry: $ry, rz: $rz,
                scale: $scale,
                useLetterM: useM
            )
            .frame(height: 420)

            Toggle("Use letter M", isOn: $useM).padding(.horizontal)

            Group {
                HStack {
                    Text("Translate X: \(tx, specifier: "%.2f")")
                    Slider(value: $tx, in: -3...3)
                }.padding(.horizontal)

                HStack {
                    Text("Translate Y: \(ty, specifier: "%.2f")")
                    Slider(value: $ty, in: -3...3)
                }.padding(.horizontal)

                HStack {
                    Text("Translate Z: \(tz, specifier: "%.2f")")
                    Slider(value: $tz, in: -8...8)
                }.padding(.horizontal)
            }

            Group {
                HStack {
                    Text("Rotate X: \(rx, specifier: "%.2f")")
                    Slider(value: $rx, in: 0...Double.pi*2)
                }.padding(.horizontal)

                HStack {
                    Text("Rotate Y: \(ry, specifier: "%.2f")")
                    Slider(value: $ry, in: 0...Double.pi*2)
                }.padding(.horizontal)

                HStack {
                    Text("Rotate Z: \(rz, specifier: "%.2f")")
                    Slider(value: $rz, in: 0...Double.pi*2)
                }.padding(.horizontal)
            }

            HStack {
                Text("Scale: \(scale, specifier: "%.2f")")
                Slider(value: $scale, in: 0.1...3.0)
            }
            .padding(.horizontal)

            HStack {
                Button("Задание") { showTask = true }
                    .padding().background(Color.orange.opacity(0.25)).cornerRadius(8)
                Spacer()
            }.padding(.horizontal)

            Spacer()
        }
        .sheet(isPresented: $showTask) {
            TaskView(useLetterM: useM)
        }
    }
}

//  TaskView

struct TaskView: View {
    var useLetterM: Bool = false

    @State private var rx: Double = 0
    @State private var ry: Double = 0
    @State private var rz: Double = 0

    // Индекс оси вращения: 0 — X, 1 — Y, 2 — Z
    @State private var axisIndex: Int = 1
    // Текущее направление вращения (1 — по часовой, -1 — против)
    @State private var direction: Double = 1.0
    @State private var targetDirection: Double = 1.0
    // Таймер, который запускает обновление анимации
    @State private var timer: Timer?

    var body: some View {
        VStack {
            WireframeCanvas(
                tx: .constant(0), ty: .constant(0), tz: .constant(0),
                rx: $rx, ry: $ry, rz: $rz,
                scale: .constant(1.0),
                useLetterM: useLetterM
            )
            .frame(height: 420)
            .onAppear {
                timer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
                    let interp: Double = 0.08
                    direction += (targetDirection - direction) * interp
                    let delta: Double = 0.02
                    switch axisIndex {
                    case 0: rx += delta * direction
                    case 1: ry += delta * direction
                    default: rz += delta * direction
                    }
                }
                scheduleRandomChange()
            }
            .onDisappear {
                timer?.invalidate(); timer = nil
            }

            Text("Вращение относительно геометрического центра объекта со случайной сменой направления ")
                .padding()

        }
    }

    func scheduleRandomChange() {
        let interval = Double.random(in: 1.0...3.0)
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            targetDirection = Bool.random() ? 1.0 : -1.0
            axisIndex = Int.random(in: 0...2)
            scheduleRandomChange()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
