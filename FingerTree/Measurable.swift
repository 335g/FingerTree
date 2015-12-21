//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

// MARK: - __ Measurable __

public protocol Measurable {
	typealias MeasuredValue: Monoid
	func measure() -> MeasuredValue
}
