//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public protocol Measurable {
	typealias MeasuredValue: Monoid
	func measure() -> MeasuredValue
}
