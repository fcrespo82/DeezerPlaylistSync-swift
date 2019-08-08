extension String {
    func rightJustified(width: Int, truncate: Bool = false) -> String {
        guard width > count else {
            return truncate ? String(suffix(width)) : self
        }
        return String(repeating: " ", count: width - count) + self
    }

    func leftJustified(width: Int, truncate: Bool = false) -> String {
        guard width > count else {
            return truncate ? String(prefix(width)) : self
        }
        return self + String(repeating: " ", count: width - count)
    }
}