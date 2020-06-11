import Foundation

extension String {
    func removingSpecialCharacters() -> String {
        let okayChars : Set<Character> =
            Set("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890+-*=(),.:!_/")
        return String(filter {okayChars.contains($0) })
    }
}
