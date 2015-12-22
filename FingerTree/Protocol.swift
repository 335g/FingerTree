//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

// MARK: - Semigroup

public protocol Semigroup {
	func mappend(other: Self) -> Self
}

// MARK: - Monoid

public protocol Monoid: Semigroup {
	static var mempty: Self { get }
}

// MARK: - Foldable

public protocol Foldable {
	typealias T
	func foldMap<M: Monoid>(f: T -> M) -> M
}

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

public protocol FingerTreeType {
	typealias Annotation: Measurable
	typealias Value = Annotation.MeasuredValue
}
