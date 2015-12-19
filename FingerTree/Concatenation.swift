//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

// MARK: - appendTree X

public func appendTree0<V, A>(tree: FingerTree<V, A>) -> FingerTree<V, A> -> FingerTree<V, A> {
	return { tree1 in
		switch (tree, tree1) {
		case (.Empty, _):
			return tree1
			
		case (_, .Empty):
			return tree
			
		case let (.Single(a), _):
			return a <| tree1
			
		case let (_, .Single(a)):
			return tree |> a
			
		case let (.Deep(_, pr1, m1, sf1), .Deep(_, pr2, m2, sf2)):
			return FingerTree<V, A>.deep(
				prefix: pr1,
				deeper: addDigits0(m1)(sf1)(pr2)(m2),
				suffix: sf2
			)
			
		default:
			fatalError()
		}
	}
}

public func appendTree1<V, A>(tree: FingerTree<V, A>) -> A -> FingerTree<V, A> -> FingerTree<V, A> {
	return { a in
		{ tree1 in
			switch (tree, a, tree1) {
			case (.Empty, _, _):
				return a <| tree1
				
			case (_, _, .Empty):
				return tree |> a
				
			case let (.Single(x), _, _):
				return x <| a <| tree1
				
			case let (_, _, .Single(x)):
				return tree |> a |> x
				
			case let (.Deep(_, pr1, m1, sf1), _, .Deep(_, pr2, m2, sf2)):
				return FingerTree<V, A>.deep(
					prefix: pr1,
					deeper: addDigits1(m1)(sf1)(a)(pr2)(m2),
					suffix: sf2
				)
				
			default:
				fatalError()
			}
		}
	}
}

public func appendTree2<V, A>(tree: FingerTree<V, A>) -> A -> A -> FingerTree<V, A> -> FingerTree<V, A> {
	fatalError()
}

public func appendTree3<V, A>(tree: FingerTree<V, A>) -> A -> A -> A -> FingerTree<V, A> -> FingerTree<V, A> {
	fatalError()
}

public func appendTree4<V, A>(tree: FingerTree<V, A>) -> A -> A -> A -> A -> FingerTree<V, A> -> FingerTree<V, A> {
	fatalError()
}

// MARK: - addDigits X

public func addDigits0<V, A>(tree: FingerTree<V, Node<V, A>>) -> Digit<A> -> Digit<A> -> FingerTree<V, Node<V, A>> -> FingerTree<V, Node<V, A>> {
	fatalError()
}

public func addDigits1<V, A>(tree: FingerTree<V, Node<V, A>>) -> Digit<A> -> A -> Digit<A> -> FingerTree<V, Node<V, A>> -> FingerTree<V, Node<V, A>> {
	fatalError()
}

public func addDigits2<V, A>(tree: FingerTree<V, Node<V, A>>) -> Digit<A> -> A -> A -> Digit<A> -> FingerTree<V, Node<V, A>> -> FingerTree<V, Node<V, A>> {
	fatalError()
}

public func addDigits3<V, A>(tree: FingerTree<V, Node<V, A>>) -> Digit<A> -> A -> A -> A -> Digit<A> -> FingerTree<V, Node<V, A>> -> FingerTree<V, Node<V, A>> {
	fatalError()
}

public func addDigits4<V, A>(tree: FingerTree<V, Node<V, A>>) -> Digit<A> -> A -> A -> A -> A -> Digit<A> -> FingerTree<V, Node<V, A>> -> FingerTree<V, Node<V, A>> {
	fatalError()
}