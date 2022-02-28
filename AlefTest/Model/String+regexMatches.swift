//
//  String+regexMatches.swift
//  AlefTest
//
//  Created by  Егор Шуляк on 28.02.22.
//

import Foundation

extension String {
    func regexMatches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
