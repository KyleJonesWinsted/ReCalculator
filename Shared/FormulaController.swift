//
//  FormulaController.swift
//  ReCalculator (iOS)
//
//  Created by Kyle Jones on 7/9/22.
//

import Combine
import Foundation

final class FormulaController: ObservableObject {

    var formulas: [Formula] = [] {
        willSet {
            objectWillChange.send()
        }
        didSet {
            FormulaController.save(formulas: formulas) { result in
                if case .failure(let error) = result {
                    print("failed to save formulas", error.localizedDescription)
                }
            }
        }
    }

    private static func fileURL() throws -> URL {
        try FileManager.default.url(
            for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false
        ).appendingPathComponent("recalculator.data")
    }

    static func load(completion: @escaping (Result<[Formula], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileUrl = try fileURL()
                guard let file = try? FileHandle(forReadingFrom: fileUrl) else {
                    DispatchQueue.main.async {
                        completion(.success(defaultFormulas))
                    }
                    return
                }
                let formulas = try JSONDecoder().decode([Formula].self, from: file.availableData)
                DispatchQueue.main.async {
                    completion(.success(formulas))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    static func save(formulas: [Formula], completion: @escaping (Result<Int, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(formulas)
                let outFile = try fileURL()
                try data.write(to: outFile)
                DispatchQueue.main.async {
                    completion(.success(formulas.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    static private var defaultFormulas: [Formula] = [
        Formula(
            text: "(M₀ + (M₀ × (T₀ ÷ 100))) ÷ P₀", name: "Split a Meal",
            variables: [
                Variable(name: "Meal Total", symbol: "M₀", isSelected: true),
                Variable(name: "Tip Percent", symbol: "T₀"),
                Variable(name: "People", symbol: "P₀"),
            ]),
        Formula(
            text: "T₀ ÷ (1 + T₁ ÷ 100)", name: "Total without Tax",
            variables: [
                Variable(name: "Total", symbol: "T₀", isSelected: true),
                Variable(name: "Tax Percent", symbol: "T₁"),
            ]),
        Formula(
            text: "((B₀ + (T₀ × 2)) ÷ (3 × (T₀ + B₀))) × H₀",
            name: "Center of Gravity",
            variables: [
                Variable(name: "Base Width", symbol: "B₀", isSelected: true),
                Variable(name: "Top Width", symbol: "T₀"),
                Variable(name: "Height", symbol: "H₀"),
            ]),
    ]
}
