import Foundation

// MARK: - Localized
extension String {
	var localized: String {
		NSLocalizedString(self, comment: "\(self)_comment")
	}
}
