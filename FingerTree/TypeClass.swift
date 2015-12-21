//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

// MARK: - __ Semigroup __

public protocol Semigroup {
	func mappend(other: Self) -> Self
}

// MARK: - __ Monoid __

public protocol Monoid: Semigroup {
	static var mempty: Self { get }
}

// MARK: - __ Foldable __

public protocol Foldable {
	typealias T
	func foldMap<M: Monoid>(f: T -> M) -> M
}