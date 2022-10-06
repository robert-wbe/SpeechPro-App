//
//  helper.swift
//  Speech App
//
//  Created by Robert Wiebe on 5/21/22.
//

import SwiftUI
struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.9 : 1)
    }
}
extension String {
    /// Returns true only if its last word occurs only once in self.
    func singularLastWordInstance() -> Bool {
        let stringToFind = self.lastWord()
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: [], range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count == 1
    }
    func removeSpecialChars() -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz")
        return String(self.lowercased().filter {okayChars.contains($0) })
    }
    func lastWord() -> String {
        return self.components(separatedBy: " ").last!.removeSpecialChars()
    }
    func reduceToLast() -> String {
        let lastWord = self.lastWord().removeSpecialChars()
        return self.components(separatedBy: " ").filter{$0.removeSpecialChars() == lastWord}.joined(separator: " ")
    }
    func countOccurances(of: String) -> Int {
        return self.components(separatedBy: of).count-1
    }
}

