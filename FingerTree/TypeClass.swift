//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public protocol Semigroup {
	func mappend(other: Self) -> Self
}

public protocol Monoid: Semigroup {
	static var mempty: Self { get }
}

public protocol Foldable {
	typealias T
	func foldMap<M: Monoid>(f: T -> M) -> M
}