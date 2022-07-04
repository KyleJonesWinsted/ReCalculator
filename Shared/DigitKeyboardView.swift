//
//  DigitKeyboardView.swift
//  ReCalculator
//
//  Created by Kyle Jones on 7/2/22.
//

import SwiftUI


struct DigitKeyboard: View {
    @Binding var input: String
    @State private var info = GridInfo()
    var addVariable: () -> Void
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible(), alignment: .leading),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    let labels = [
        "7","8","9","×",
        "4","5","6","-",
        "1","2","3","+",
        "(","0",".", ")"
    ]
    let colors: [String: Color] = [
        "×": .orange,
        "-": .orange,
        "+": .orange,
        "(": .mint,
        ")": .mint,
        ".": .mint,
    ]
    var body: some View {
        LazyVGrid(columns: columns) {
            let subscripts = ["₀", "₁", "₂", "₃", "₄", "₅", "₆", "₇",  "₈",  "₉"]
            DigitButton(label: "←", color: .orange) {
                guard let last = input.last else { return }
                if subscripts.contains(String(last)) {
                    input.removeLast()
                }
                input.removeLast()
            }
            AddVariableButton(width: self.info.columnWidth(1) * 2 + self.info.spacing(1), addVariable: addVariable)
                .frame(maxWidth: .infinity)
            Text("")
            DigitButton(label: "÷", color: .orange) { input.append("÷") }
            ForEach(0..<labels.count, id: \.self) { idx in
                let digit = labels[idx]
                DigitButton(label: digit, color: colors[digit] ?? .gray) { input.append(digit) }
                    .gridInfoId(idx)
            }
        }
        .gridInfo($info)
        .padding(10)
    }
}

struct AddVariableButton: View {
    var width: CGFloat
    var addVariable: () -> Void
    var body: some View {
        Button {
            addVariable()
        } label: {
            Text("+ Add Variable")
                .font(.title2)
                .frame(width: width, height: 53)
        }
        .frame(width: width)
        .buttonStyle(DigitButtonStyle(color: .mint))
    }
}


struct DigitButton: View {
    
    var label: String
    var color = Color.gray
    
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(label)
                .font(.largeTitle)
                .frame(maxWidth: .infinity)
                .padding(7)
        }
        .buttonStyle(DigitButtonStyle(color: color))
            
    }
}

struct DigitButtonStyle: ButtonStyle {
    var color = Color.gray
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(.white)
            .background(configuration.isPressed ? .blue : color)
            .cornerRadius(30)
            .padding(1)
    }
}

struct GridInfoPreference {
    let id: Int
    let bounds: Anchor<CGRect>
}

struct GridPreferenceKey: PreferenceKey {
    static var defaultValue: [GridInfoPreference] = []
    
    static func reduce(value: inout [GridInfoPreference], nextValue: () -> [GridInfoPreference]) {
        return value.append(contentsOf: nextValue())
    }
}

struct GridInfo: Equatable {
    // A array of all rendered cells's bounds
    var cells: [Item] = []
    
    // a computed property that returns the number of columns
    var columnCount: Int {
        guard cells.count > 1 else { return cells.count }

        var k = 1

        for i in 1..<cells.count {
            if cells[i].bounds.origin.x > cells[i-1].bounds.origin.x {
                k += 1
            } else {
                break
            }
        }

        return k
    }
    
    // a computed property that returns the range of cells being rendered
    var cellRange: ClosedRange<Int>? {
        guard let lower = cells.first?.id, let upper = cells.last?.id else { return nil }
        
        return lower...upper
    }
  
    // returns the width of a rendered cell
    func cellWidth(_ id: Int) -> CGFloat {
        columnCount > 0 ? columnWidth(id % columnCount) : 0
    }
    
    // returns the width of a column
    func columnWidth(_ col: Int) -> CGFloat {
        columnCount > 0 && col < columnCount ? cells[col].bounds.width : 0
    }
    
    // returns the spacing between columns col and col+1
    func spacing(_ col: Int) -> CGFloat {
        guard columnCount > 0 else { return 0 }
        let left = col < columnCount ? cells[col].bounds.maxX : 0
        let right = col+1 < columnCount ? cells[col+1].bounds.minX : left
        
        return right - left
    }

    // Do not forget the "Equatable", as it prevent redrawing loops
    struct Item: Equatable {
        let id: Int
        let bounds: CGRect
    }
}

extension View {
    func gridInfoId(_ id: Int) -> some View {
        self.anchorPreference(key: GridPreferenceKey.self, value: .bounds) {
                [GridInfoPreference(id: id, bounds: $0)]
            }
    }
    
    func gridInfo(_ info: Binding<GridInfo>) -> some View {
        self.backgroundPreferenceValue(GridPreferenceKey.self) { prefs in
            GeometryReader { proxy -> Color in
                DispatchQueue.main.async {
                    info.wrappedValue.cells = prefs.compactMap {
                      GridInfo.Item(id: $0.id, bounds: proxy[$0.bounds])
                    }
                }
                    
                return Color.clear
            }
        }
    }
}
