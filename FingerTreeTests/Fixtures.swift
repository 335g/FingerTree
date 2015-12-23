//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

import Foundation
@testable import FingerTree

public typealias Size = UInt

extension Size: Monoid {
	public static var mempty: Size { return 0 }
	public func mappend(other: Size) -> Size {
		return self + other
	}
}

extension Character: Measurable {
	public typealias MeasuredValue = Size
	public func measure() -> MeasuredValue {
		return 1
	}
}

infix operator <> {
	associativity right
	precedence 160
}

func <> <S: Semigroup>(lhs: S, rhs: S) -> S {
	return lhs.mappend(rhs)
}

