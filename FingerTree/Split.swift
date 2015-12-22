//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public enum Split<T, A> {
	case Split(T, A, T)
}

func splitTree<V, A: Measurable where V == A.MeasuredValue>(predicate: V -> Bool) -> V -> FingerTree<V, A> -> Split<FingerTree<V, A>, A> {
	return { i in
		{ tree in
			switch tree {
			case .Empty:
				// TODO: Remove fatalError
				fatalError()
				
			case let .Single(a):
				return .Split(.Empty, a, .Empty)
			
			case let .Deep(_, pre, m, suf):
				let vpr = i.mappend(pre.measure())
				let vm = m.mappendVal(vpr)
				
				if predicate(vpr) {
					switch splitDigit(predicate)(i)(pre) {
					case let .Split(l, x, r):
						if let leftToTree = l?.tree {
							return .Split(leftToTree, x, deepL(r)(m)(suf))
						}else {
							return .Split(.Empty, x, deepL(r)(m)(suf))
						}
					}
					
				}else if predicate(vm) {
					switch splitTree(predicate)(vpr)(m) {
					case let .Split(ml, xs, mr):
						switch splitNode(predicate)(ml.mappendVal(vpr))(xs) {
						case let .Split(l, x, r):
							return .Split(deepR(pre)(ml)(l), x, deepL(r)(mr)(suf))
						}
					}
					
				}else {
					switch splitDigit(predicate)(vm)(suf) {
					case let .Split(l, x, r):
						if let rightToTree = r?.tree {
							return .Split(deepR(pre)(m)(l), x, rightToTree)
						}else {
							return .Split(deepR(pre)(m)(l), x, .Empty)
						}
					}
				}
			}
		}
	}
}

func deepL<V, A: Measurable where V == A.MeasuredValue>(digit: Digit<A>?) -> FingerTree<V, Node<V, A>> -> Digit<A> -> FingerTree<V, A> {
	
	fatalError()
}

func deepR<V, A: Measurable where V == A.MeasuredValue>(digit: Digit<A>) -> FingerTree<V, Node<V, A>> -> Digit<A>? -> FingerTree<V, A> {
	
	fatalError()
}

func splitDigit<V, A: Measurable where V == A.MeasuredValue>(predicate: V -> Bool) -> V -> Digit<A> -> Split<Digit<A>?, A> {
	return { i in
		{ digit in
			switch digit {
			case let .One(a):
				return .Split(nil, a, nil)
				
			case let .Two(a, b):
				let va = i.mappend(a.measure())
				if predicate(va) {
					return .Split(nil, a, .One(b))
				}else {
					return .Split(.One(a), b, nil)
				}
				
			case let .Three(a, b, c):
				let va = i.mappend(a.measure())
				let vab = va.mappend(b.measure())
				
				if predicate(va) {
					return .Split(nil, a, .Two(b, c))
				}else if predicate(vab) {
					return .Split(.One(a), b, .One(c))
				}else {
					return .Split(.Two(a, b), c, nil)
				}
				
			case let .Four(a, b, c, d):
				let va = i.mappend(a.measure())
				let vab = va.mappend(b.measure())
				let vabc = vab.mappend(c.measure())
				
				if predicate(va) {
					return .Split(nil, a, .Three(b, c, d))
				}else if predicate(vab) {
					return .Split(.One(a), b, .Two(c, d))
				}else if predicate(vabc) {
					return .Split(.Two(a, b), c, .One(d))
				}else {
					return .Split(.Three(a, b, c), d, nil)
				}
			}
		}
	}
}

func splitNode<V, A>(predicate: V -> Bool) -> V -> Node<V, A> -> Split<Digit<A>?, A> {
	return { i in
		{ node in
			switch node {
			case let .Node2(_, a, b):
				if predicate(i.mappend(a.measure())) {
					return .Split(nil, a, .One(b))
				}else {
					return .Split(.One(a), b, nil)
				}
				
			case let .Node3(_, a, b, c):
				let va = i.mappend(a.measure())
				let vab = va.mappend(b.measure())
				
				if predicate(va) {
					return .Split(nil, a, .Two(b, c))
				}else if predicate(vab) {
					return .Split(.One(a), b, .One(c))
				}else {
					return .Split(.Two(a, b), c, nil)
				}
			}
		}
	}
}