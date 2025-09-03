import Foundation

extension Date {
    static func days(_ n: Int) -> Date { Calendar.current.date(byAdding: .day, value: n, to: Date()) ?? Date() }
}
