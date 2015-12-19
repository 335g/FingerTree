//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public protocol Semigroup {
	func mappend(other: Self) -> Self
}

public func sconcat <S: Semigroup>(initial: S, t: [S]) -> S {
	return t.reduce(initial){ $0.mappend($1) }
}

public protocol Monoid: Semigroup {
	static var mempty: Self { get }
}

public protocol Foldable {
	typealias T
	func foldMap<M: Monoid>(f: T -> M) -> M
}