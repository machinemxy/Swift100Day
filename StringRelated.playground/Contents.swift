import UIKit

extension String {
    func withPrefix(_ text: String) -> String {
        if self.hasPrefix(text) {
            return self
        } else {
            return text + self
        }
    }
    
    func isNumeric() -> Bool {
        if let _ = Double(self) {
            return true
        } else {
            return false
        }
    }
    
    var lines: [String] {
        self.components(separatedBy: "\n")
    }
}

print("pet".withPrefix("car"))
print("fuck".withPrefix("fu"))
print("12.34".isNumeric())
print("fuck".isNumeric())
print("this\nis\na\napple".lines)
print("fuck".lines)
