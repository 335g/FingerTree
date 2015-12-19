//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public protocol MeasuredType {
	typealias MeasuredValue: Monoid
	func measure() -> MeasuredValue
}
