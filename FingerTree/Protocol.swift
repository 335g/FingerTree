//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import Prelude

// MARK: - Measurable

public protocol Measurable {
	typealias MeasuredValue: Monoid
	func measure() -> MeasuredValue
}

// MARK: - NodeType

public protocol NodeType {
	typealias Annotation: Measurable
	typealias Value = Annotation.MeasuredValue
}

// MARK: - FingerTreeType

public protocol FingerTreeType: Measurable, Foldable, Monoid {
	typealias Annotation: Measurable
	typealias Value = Annotation.MeasuredValue
}

