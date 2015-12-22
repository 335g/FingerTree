//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

// MARK: - __ FingerTree __

public enum FingerTree<V, A: Measurable where V == A.MeasuredValue>: FingerTreeType {
	public typealias Annotation = A
	public typealias Value = V
	
	case Empty
	case Single(A)
	indirect case Deep(V, Digit<A>, FingerTree<V, Node<V, A>>, Digit<A>)
	
	// MARK: static
	
	public static func empty() -> FingerTree {
		return Empty
	}
	
	public static func single(a: A) -> FingerTree {
		return Single(a)
	}
	
	public static func deep(prefix prefix: Digit<A>, deeper: FingerTree<V, Node<V, A>>, suffix: Digit<A>) -> FingerTree {
		return .Deep(deeper.mappendVal(prefix.measure()), prefix, deeper, suffix)
	}
	
	// MARK: other
	
	func mappendVal(v: V) -> V {
		switch self {
		case .Empty:
			return v
			
		default:
			return v.mappend(self.measure())
		}
	}
}

// MARK: - Map

extension FingerTree {
	
	public func map<V1, A1: Measurable where V1 == A1.MeasuredValue>(f: A -> A1) -> FingerTree<V1, A1> {
		switch self {
		case .Empty:
			return .Empty
		case let .Single(a):
			return .Single(f(a))
		case let .Deep(_, pre, m, suf):
			return FingerTree<V1, A1>.deep(
				prefix: pre.map(f),
				deeper: m.map({ $0.map(f) }),
				suffix: suf.map(f)
			)
		}
	}
}

// MARK: - Construction

extension Array where Element: Measurable {
	public typealias V = Element.MeasuredValue
	
	public var fingerTree: FingerTree<V, Element> {
		return reduce(.Empty){ $0.0 |> $0.1 }
	}
}

// MARK: - Deconstruction

extension FingerTree {
	public var list: Array<A> {
		// TODO: fold with inout
		
		let append: [A] -> A -> [A] = { list in
			{ target in
				var copied = list
				copied.append(target)
				return copied
			}
		}
		return self.foldl([], append)
	}
}

// MARK: - Concatenation

extension FingerTree {
	public func appendTree0(tree: FingerTree) -> FingerTree {
		switch (self, tree) {
		case (.Empty, _):
			return tree
			
		case (_, .Empty):
			return self
			
		case let (.Single(a), _):
			return a <| tree
			
		case let (_, .Single(a)):
			return self |> a
			
		case let (.Deep(_, pr1, m1, sf1), .Deep(_, pr2, m2, sf2)):
			return FingerTree.deep(
				prefix: pr1,
				deeper: m1.addDigits0(m2, sf1, pr2),
				suffix: sf2
			)
			
		default:
			// TODO: throw
			fatalError()
		}
	}
	
	public func appendTree1(tree: FingerTree, _ a: A) -> FingerTree {
		switch (self, tree) {
		case (.Empty, _):
			return a <| tree
			
		case (_, .Empty):
			return self |> a
			
		case let (.Single(x), _):
			return x <| a <| tree
			
		case let (_, .Single(x)):
			return self |> a |> x
			
		case let (.Deep(_, pr1, m1, sf1), .Deep(_, pr2, m2, sf2)):
			return FingerTree.deep(
				prefix: pr1,
				deeper: m1.addDigits1(m2, sf1, a, pr2),
				suffix: sf2
			)
			
		default:
			// TODO: throw
			fatalError()
		}
	}
	
	public func appendTree2(tree: FingerTree, _ a: A, _ b: A) -> FingerTree {
		switch (self, tree) {
		case (.Empty, _):
			return a <| b <| tree
			
		case (_, .Empty):
			return self |> a |> b
			
		case let (.Single(x), _):
			return x <| a <| b <| tree
			
		case let (_, .Single(x)):
			return self |> a |> b |> x
			
		case let (.Deep(_, pr1, m1, sf1), .Deep(_, pr2, m2, sf2)):
			return FingerTree.deep(
				prefix: pr1,
				deeper: m1.addDigits2(m2, sf1, a, b, pr2),
				suffix: sf2)
			
		default:
			// TODO: throw
			fatalError()
		}
	}
	
	public func appendTree3(tree: FingerTree, _ a: A, _ b: A, _ c: A) -> FingerTree {
		switch (self, tree) {
		case (.Empty, _):
			return a <| b <| c <| tree
			
		case (_, .Empty):
			return self |> a |> b |> c
			
		case let (.Single(x), _):
			return x <| a <| b <| c <| tree
			
		case let (_, .Single(x)):
			return self |> a |> b |> c |> x
			
		case let (.Deep(_, pr1, m1, sf1), .Deep(_, pr2, m2, sf2)):
			return FingerTree.deep(
				prefix: pr1,
				deeper: m1.addDigits3(m2, sf1, a, b, c, pr2),
				suffix: sf2
			)
			
		default:
			// TODO: throw
			fatalError()
		}
	}
	
	public func appendTree4(tree: FingerTree, _ a: A, _ b: A, _ c: A, _ d: A) -> FingerTree {
		switch (self, tree) {
		case (.Empty, _):
			return a <| b <| c <| d <| tree
			
		case (_, .Empty):
			return self |> a |> b |> c |> d
			
		case let (.Single(x), _):
			return x <| a <| b <| c <| d <| tree
			
		case let (_, .Single(x)):
			return self |> a |> b |> c |> d |> x
			
		case let (.Deep(_, pr1, m1, sf1), .Deep(_, pr2, m2, sf2)):
			return FingerTree.deep(
				prefix: pr1,
				deeper: m1.addDigits4(m2, sf1, a, b, c, d, pr2),
				suffix: sf2
			)
			
		default:
			// TODO: throw
			fatalError()
		}
	}
}

extension FingerTree where A: NodeType, V == A.Annotation.MeasuredValue {
	typealias AA = A.Annotation
	
	public func addDigits0(tree: FingerTree, _ digit: Digit<AA>, _ digit1: Digit<AA>) -> FingerTree {
		
		switch digit {
		case let .One(a):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node2(a, a1) as! A
				return self.appendTree1(tree, node1)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, a1, b1) as! A
				return self.appendTree1(tree, node1)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node2(a, a1) as! A
				let node2 = Node.node2(b1, c1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, a1, b1) as! A
				let node2 = Node.node2(c1, d1) as! A
				return self.appendTree2(tree, node1, node2)
			}
			
		case let .Two(a, b):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, a1) as! A
				return self.appendTree1(tree, node1)
				
			case let .Two(a1, b1):
				let node1 = Node.node2(a, b) as! A
				let node2 = Node.node2(a1, b1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, a1) as! A
				let node2 = Node.node2(b1, c1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, a1) as! A
				let node2 = Node.node3(b1, c1, d1) as! A
				return self.appendTree2(tree, node1, node2)
			}
			
		case let .Three(a, b, c):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node2(a, b) as! A
				let node2 = Node.node2(c, a1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node2(a1, b1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a1, b1, c1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node2(a1, b1) as! A
				let node3 = Node.node2(c1, d1) as! A
				return self.appendTree3(tree, node1, node2, node3)
			}
			
		case let .Four(a, b, c, d):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node2(d, a1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a1, b1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node2(d, a1) as! A
				let node3 = Node.node2(b1, c1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a1, b1) as! A
				let node3 = Node.node2(c1, d1) as! A
				return self.appendTree3(tree, node1, node2, node3)
			}
		}
	}
	
	public func addDigits1(tree: FingerTree, _ digit: Digit<AA>, _ a0: AA, _ digit1: Digit<AA>) -> FingerTree {
		
		switch digit {
		case let .One(a):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, a0, a1) as! A
				return self.appendTree1(tree, node1)
				
			case let .Two(a1, b1):
				let node1 = Node.node2(a, a0) as! A
				let node2 = Node.node2(a1, b1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, a0, a1) as! A
				let node2 = Node.node2(b1, c1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, a0, a1) as! A
				let node2 = Node.node3(b1, c1, d1) as! A
				return self.appendTree2(tree, node1, node2)
			}
			
		case let .Two(a, b):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node2(a, b) as! A
				let node2 = Node.node2(a0, a1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node2(a1, b1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node3(a1, b1, c1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node2(a1, b1) as! A
				let node3 = Node.node2(c1, d1) as! A
				return self.appendTree3(tree, node1, node2, node3)
			}
			
		case let .Three(a, b, c):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node2(a0, a1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, a1, b1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node2(a0, a1) as! A
				let node3 = Node.node2(b1, c1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, a1, b1) as! A
				let node3 = Node.node2(c1, d1) as! A
				return self.appendTree3(tree, node1, node2, node3)
			}
			
		case let .Four(a, b, c, d):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, a1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node2(d, a0) as! A
				let node3 = Node.node2(a1, b1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, a1) as! A
				let node3 = Node.node2(b1, c1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, a1) as! A
				let node3 = Node.node3(b1, c1, d1) as! A
				return self.appendTree3(tree, node1, node2, node3)
			}
		}
	}
	
	public func addDigits2(tree: FingerTree, _ digit: Digit<AA>, _ a0: AA, _ b0: AA, _ digit1: Digit<AA>) -> FingerTree {
		
		switch digit {
		case let .One(a):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node2(a, a0) as! A
				let node2 = Node.node2(b0, a1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, a0, b0) as! A
				let node2 = Node.node2(a1, b1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, a0, b0) as! A
				let node2 = Node.node3(a1, b1, c1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, a0, b0) as! A
				let node2 = Node.node2(a1, b1) as! A
				let node3 = Node.node2(c1, d1) as! A
				return self.appendTree3(tree, node1, node2, node3)
			}
			
		case let .Two(a, b):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node2(b0, a1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node3(b0, a1, b1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node2(b0, a1) as! A
				let node3 = Node.node2(b1, c1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node3(b0, a1, b1) as! A
				let node3 = Node.node2(c1, d1) as! A
				return self.appendTree3(tree, node1, node2, node3)
			}
			
		case let .Three(a, b, c):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, b0, a1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node2(a0, b0) as! A
				let node3 = Node.node2(a1, b1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, b0, a1) as! A
				let node3 = Node.node2(b1, c1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, b0, a1) as! A
				let node3 = Node.node3(b1, c1, d1) as! A
				return self.appendTree3(tree, node1, node2, node3)
			}
			
		case let .Four(a, b, c, d):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node2(d, a0) as! A
				let node3 = Node.node2(b0, a1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, b0) as! A
				let node3 = Node.node2(a1, b1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, b0) as! A
				let node3 = Node.node3(a1, b1, c1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, b0) as! A
				let node3 = Node.node2(a1, b1) as! A
				let node4 = Node.node2(c1, d1) as! A
				return self.appendTree4(tree, node1, node2, node3, node4)
			}
		}
	}
	
	public func addDigits3(tree: FingerTree, _ digit: Digit<AA>, _ a0: AA, _ b0: AA, _ c0: AA, _ digit1: Digit<AA>) -> FingerTree {
		
		switch digit {
		case let .One(a):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, a0, b0) as! A
				let node2 = Node.node2(c0, a1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, a0, b0) as! A
				let node2 = Node.node3(c0, a1, b1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, a0, b0) as! A
				let node2 = Node.node2(c0, a1) as! A
				let node3 = Node.node2(b1, c1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, a0, b0) as! A
				let node2 = Node.node3(c0, a1, b1) as! A
				let node3 = Node.node2(c1, d1) as! A
				return self.appendTree3(tree, node1, node2, node3)
			}
			
		case let .Two(a, b):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node3(b0, c0, a1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node2(b0, c0) as! A
				let node3 = Node.node2(a1, b1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node3(b0, c0, a1) as! A
				let node3 = Node.node2(b1, c1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node3(b0, c0, a1) as! A
				let node3 = Node.node3(b1, c1, d1) as! A
				return self.appendTree3(tree, node1, node2, node3)
			}
			
		case let .Three(a, b, c):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node2(a0, b0) as! A
				let node3 = Node.node2(c0, a1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, b0, c0) as! A
				let node3 = Node.node2(a1, b1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, b0, c0) as! A
				let node3 = Node.node3(a1, b1, c1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, b0, c0) as! A
				let node3 = Node.node2(a1, b1) as! A
				let node4 = Node.node2(c1, d1) as! A
				return self.appendTree4(tree, node1, node2, node3, node4)
			}
			
		case let .Four(a, b, c, d):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, b0) as! A
				let node3 = Node.node2(c0, a1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, b0) as! A
				let node3 = Node.node3(c0, a1, b1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, b0) as! A
				let node3 = Node.node2(c0, a1) as! A
				let node4 = Node.node2(b1, c1) as! A
				return self.appendTree4(tree, node1, node2, node3, node4)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, b0) as! A
				let node3 = Node.node3(c0, a1, b1) as! A
				let node4 = Node.node2(c1, d1) as! A
				return self.appendTree4(tree, node1, node2, node3, node4)
			}
		}
	}
	
	public func addDigits4(tree: FingerTree, _ digit: Digit<AA>, _ a0: AA, _ b0: AA, _ c0: AA, _ d0: AA, _ digit1: Digit<AA>) -> FingerTree {
		
		switch digit {
		case let .One(a):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, a0, b0) as! A
				let node2 = Node.node3(c0, d0, a1) as! A
				return self.appendTree2(tree, node1, node2)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, a0, b0) as! A
				let node2 = Node.node2(c0, d0) as! A
				let node3 = Node.node2(a1, b1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, a0, b0) as! A
				let node2 = Node.node3(c0, d0, a1) as! A
				let node3 = Node.node2(b1, c1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, a0, b0) as! A
				let node2 = Node.node3(c0, d0, a1) as! A
				let node3 = Node.node3(b1, c1, d1) as! A
				return self.appendTree3(tree, node1, node2, node3)
			}
			
		case let .Two(a, b):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node2(b0, c0) as! A
				let node3 = Node.node2(d0, a1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node3(b0, c0, d0) as! A
				let node3 = Node.node2(a1, b1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node3(b0, c0, d0) as! A
				let node3 = Node.node3(a1, b1, c1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, a0) as! A
				let node2 = Node.node3(b0, c0, d0) as! A
				let node3 = Node.node2(a1, b1) as! A
				let node4 = Node.node2(c1, d1) as! A
				return self.appendTree4(tree, node1, node2, node3, node4)
			}
			
		case let .Three(a, b, c):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, b0, c0) as! A
				let node3 = Node.node2(d0, a1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, b0, c0) as! A
				let node3 = Node.node3(d0, a1, b1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, b0, c0) as! A
				let node3 = Node.node2(d0, a1) as! A
				let node4 = Node.node2(b1, c1) as! A
				return self.appendTree4(tree, node1, node2, node3, node4)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(a0, b0, c0) as! A
				let node3 = Node.node3(d0, a1, b1) as! A
				let node4 = Node.node2(c1, d1) as! A
				return self.appendTree4(tree, node1, node2, node3, node4)
			}
			
		case let .Four(a, b, c, d):
			switch digit1 {
			case let .One(a1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, b0) as! A
				let node3 = Node.node3(c0, d0, a1) as! A
				return self.appendTree3(tree, node1, node2, node3)
				
			case let .Two(a1, b1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, b0) as! A
				let node3 = Node.node2(c0, d0) as! A
				let node4 = Node.node2(a1, b1) as! A
				return self.appendTree4(tree, node1, node2, node3, node4)
				
			case let .Three(a1, b1, c1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, b0) as! A
				let node3 = Node.node3(c0, d0, a1) as! A
				let node4 = Node.node2(b1, c1) as! A
				return self.appendTree4(tree, node1, node2, node3, node4)
				
			case let .Four(a1, b1, c1, d1):
				let node1 = Node.node3(a, b, c) as! A
				let node2 = Node.node3(d, a0, b0) as! A
				let node3 = Node.node3(c0, d0, a1) as! A
				let node4 = Node.node3(b1, c1, d1) as! A
				return self.appendTree4(tree, node1, node2, node3, node4)
			}
		}
	}
}

// MARK: - Foldable

extension FingerTree: Foldable {
	
	func foldr<B>(initial: B, _ f: A -> B -> B) -> B {
		switch self {
		case .Empty:
			return initial
		
		case let .Single(a):
			return f(a)(initial)

		case let .Deep(_, pre, m, suf):
			return pre.foldr(
				m.foldr(
					suf.foldr(initial, f),
					{ node in { node.foldr($0, f) }} ),
				f)
		}
	}
	
	func foldl<B>(initial: B, _ f: B -> A -> B) -> B {
		switch self {
		case .Empty:
			return initial
		
		case let .Single(a):
			return f(initial)(a)
			
		case let .Deep(_, pre, m, suf):
			return suf.foldl(
				m.foldl(
					pre.foldl(initial, f),
					{ b in { $0.foldl(b, f) } }),
				f)
		}
	}
	
	public func foldMap<M: Monoid>(f: A -> M) -> M {
		switch self {
		case .Empty:
			return M.mempty
			
		case let .Single(x):
			return f(x)
			
		case let .Deep(_, pre, deeper, suf):
			return pre.foldMap(f).mappend(deeper.foldMap({ $0.foldMap(f) }).mappend(suf.foldMap(f)))
		}
	}
}

// MARK: - Measurable

extension FingerTree: Measurable {
	public typealias MeasuredValue = V
	
	public func measure() -> MeasuredValue {
		switch self {
		case .Empty:
			return V.mempty
			
		case let .Single(a):
			return a.measure()
			
		case let .Deep(v, _, _, _):
			return v
			
		}
	}
}

// MARK: - Semigroup

extension FingerTree: Semigroup {
	public func mappend(other: FingerTree) -> FingerTree {
		return appendTree0(other)
	}
}

// MARK: - Monoid

extension FingerTree: Monoid {
	public static var mempty: FingerTree {
		return .Empty
	}
}

// MARK: - Equatable

public func == <V, A: Equatable>(lhs: FingerTree<V, A>, rhs: FingerTree<V, A>) -> Bool {
	return lhs.list == rhs.list
}
