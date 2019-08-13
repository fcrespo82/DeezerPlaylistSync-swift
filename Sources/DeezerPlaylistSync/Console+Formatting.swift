import Console
import Foundation

extension Console {
	public func centered(_ string: String, padding: Character = " ") -> String {
		let paddingCount = ((size.width - 1) - string.count) / 2
		return "\(String(repeating: padding, count: paddingCount))\(string)\(String(repeating: padding, count: paddingCount))"
	}

	public func halfCentered(_ string: String, padding: Character = " ") -> String {
		let paddingCount = ((size.width - 1) / 2 - string.count) / 2
		return "\(String(repeating: padding, count: paddingCount))\(string)\(String(repeating: padding, count: paddingCount))"
	}

	public func left(_ string: String, padding: Character = " ") -> String {
		return "\(string)\(String(repeating: padding, count: (size.width - 1) - string.count))"
	}

	public func halfLeft(_ string: String, padding: Character = " ") -> String {
		return "\(string)\(String(repeating: padding, count: (size.width - 1) / 2 - string.count))"
	}

	public func right(_ string: String, padding: Character = " ") -> String {
		return "\(String(repeating: padding, count: (size.width - 1) - string.count))\(string)"
	}

	public func halfRight(_ string: String, padding: Character = " ") -> String {
		return "\(String(repeating: padding, count: (size.width - 1) / 2 - string.count))\(string)"
	}

	public func two_columns(leftString: String, leftFormatter: (String, Character) -> String, rightString: String, rightFormatter: (String, Character) -> String, padding: Character = " ", separator: String = "|") -> String {
		// leftFormatter(string)
		return "\(leftFormatter(leftString, padding))\(separator)\(rightFormatter(rightString, padding))"
	}
}