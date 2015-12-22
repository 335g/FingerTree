//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public enum ViewLeft<V, A: Measurable where V == A.MeasuredValue> {
	case Empty
	case EdgeWith(A, FingerTree<V, A>)
}

public enum ViewRight<V, A: Measurable where V == A.MeasuredValue> {
	case Empty
	case EdgeWith(A, FingerTree<V, A>)
}