//
//  Extensions.swift
//  Netflix
//
//  Created by Anna Shin on 09.09.2022.
//

import Foundation

extension String {
    func capitalizedFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
