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
	return { a in
		{ b in
			{ tree1 in
				switch (tree, a, b, tree1) {
				case (.Empty, _, _, _):
					return a <| b <| tree1
					
				case (_, _, _, .Empty):
					return tree |> a |> b
					
				case let (.Single(x), _, _, _):
					return x <| a <| b <| tree1
					
				case let (_, _, _, .Single(x)):
					return tree |> a |> b |> x
					
				case let (.Deep(_, pr1, m1, sf1), _, _, .Deep(_, pr2, m2, sf2)):
					return FingerTree<V, A>.deep(
						prefix: pr1,
						deeper: addDigits2(m1)(sf1)(a)(b)(pr2)(m2),
						suffix: sf2)
					
				default:
					fatalError()
				}
			}
		}
	}
}

public func appendTree3<V, A>(tree: FingerTree<V, A>) -> A -> A -> A -> FingerTree<V, A> -> FingerTree<V, A> {
	return { a in
		{ b in
			{ c in
				{ tree1 in
					switch (tree, a, b, c, tree1) {
					case (.Empty, _, _, _, _):
						return a <| b <| c <| tree1
						
					case (_, _, _, _, .Empty):
						return tree |> a |> b |> c
						
					case let (.Single(x), _, _, _, _):
						return x <| a <| b <| c <| tree1
						
					case let (_, _, _, _, .Single(x)):
						return tree |> a |> b |> c |> x
						
					case let (.Deep(_, pr1, m1, sf1), _, _, _, .Deep(_, pr2, m2, sf2)):
						return FingerTree<V, A>.deep(
							prefix: pr1,
							deeper: addDigits3(m1)(sf1)(a)(b)(c)(pr2)(m2),
							suffix: sf2
						)
						
					default:
						fatalError()
					}
				}
			}
		}
	}
}

public func appendTree4<V, A>(tree: FingerTree<V, A>) -> A -> A -> A -> A -> FingerTree<V, A> -> FingerTree<V, A> {
	return { a in
		{ b in
			{ c in
				{ d in
					{ tree1 in
						switch (tree, a, b, c, d, tree1) {
						case (.Empty, _, _, _, _, _):
							return a <| b <| c <| d <| tree1
							
						case (_, _, _, _, _, .Empty):
							return tree |> a |> b |> c |> d
							
						case let (.Single(x), _, _, _, _, _):
							return x <| a <| b <| c <| d <| tree1
							
						case let (_, _, _, _, _, .Single(x)):
							return tree |> a |> b |> c |> d |> x
							
						case let (.Deep(_, pr1, m1, sf1), _, _, _, _, .Deep(_, pr2, m2, sf2)):
							return FingerTree<V, A>.deep(
								prefix: pr1,
								deeper: addDigits4(m1)(sf1)(a)(b)(c)(d)(pr2)(m2),
								suffix: sf2
							)
							
						default:
							fatalError()
						}
					}
				}
			}
		}
	}
}

// MARK: - addDigits X

public func addDigits0<V, A>(tree: FingerTree<V, Node<V, A>>) -> Digit<A> -> Digit<A> -> FingerTree<V, Node<V, A>> -> FingerTree<V, Node<V, A>> {
	return { digit in
		{ digit1 in
			{ tree1 in
				switch (digit, digit1) {
				case let (.One(a), .One(a1)):
					return appendTree1(tree)(Node.node2(a, a1))(tree1)
					
				case let (.One(a), .Two(a1, b1)):
					return appendTree1(tree)(Node.node3(a, a1, b1))(tree1)
					
				case let (.One(a), .Three(a1, b1, c1)):
					return appendTree2(tree)(Node.node2(a, a1))(Node.node2(b1, c1))(tree1)
					
				case let (.One(a), .Four(a1, b1, c1, d1)):
					return appendTree2(tree)(Node.node3(a, a1, b1))(Node.node2(c1, d1))(tree1)
					
				case let (.Two(a, b), .One(a1)):
					return appendTree1(tree)(Node.node3(a, b, a1))(tree1)
					
				case let (.Two(a, b), .Two(a1, b1)):
					return appendTree2(tree)(Node.node2(a, b))(Node.node2(a1, b1))(tree1)
					
				case let (.Two(a, b), .Three(a1, b1, c1)):
					return appendTree2(tree)(Node.node3(a, b, a1))(Node.node2(b1, c1))(tree1)
					
				case let (.Two(a, b), .Four(a1, b1, c1, d1)):
					return appendTree2(tree)(Node.node3(a, b, a1))(Node.node3(b1, c1, d1))(tree1)
					
				case let (.Three(a, b, c), .One(a1)):
					return appendTree2(tree)(Node.node2(a, b))(Node.node2(c, a1))(tree1)
					
				case let (.Three(a, b, c), .Two(a1, b1)):
					return appendTree2(tree)(Node.node3(a, b, c))(Node.node2(a1, b1))(tree1)
					
				case let (.Three(a, b, c), .Three(a1, b1, c1)):
					return appendTree2(tree)(Node.node3(a, b, c))(Node.node3(a1, b1, c1))(tree1)
					
				case let (.Three(a, b, c), .Four(a1, b1, c1, d1)):
					return appendTree3(tree)(Node.node3(a, b, c))(Node.node2(a1, b1))(Node.node2(c1, d1))(tree1)
					
				case let (.Four(a, b, c, d), .One(a1)):
					return appendTree2(tree)(Node.node3(a, b, c))(Node.node2(d, a1))(tree1)
					
				case let (.Four(a, b, c, d), .Two(a1, b1)):
					return appendTree2(tree)(Node.node3(a, b, c))(Node.node3(d, a1, b1))(tree1)
					
				case let (.Four(a, b, c, d), .Three(a1, b1, c1)):
					return appendTree3(tree)(Node.node3(a, b, c))(Node.node2(d, a1))(Node.node2(b1, c1))(tree1)
					
				case let (.Four(a, b, c, d), .Four(a1, b1, c1, d1)):
					return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(d, a1, b1))(Node.node2(c1, d1))(tree1)
				}
			}
		}
	}
}

public func addDigits1<V, A>(tree: FingerTree<V, Node<V, A>>) -> Digit<A> -> A -> Digit<A> -> FingerTree<V, Node<V, A>> -> FingerTree<V, Node<V, A>> {
	return { digit in
		{ a0 in
			{ digit1 in
				{ tree1 in
					switch (digit, digit1) {
					case let (.One(a), .One(a1)):
						return appendTree1(tree)(Node.node3(a, a0, a1))(tree1)
						
					case let (.One(a), .Two(a1, b1)):
						return appendTree2(tree)(Node.node2(a, a0))(Node.node2(a1, b1))(tree1)
						
					case let (.One(a), .Three(a1, b1, c1)):
						return appendTree2(tree)(Node.node3(a, a0, a1))(Node.node2(b1, c1))(tree1)
						
					case let (.One(a), .Four(a1, b1, c1, d1)):
						return appendTree2(tree)(Node.node3(a, a0, a1))(Node.node3(b1, c1, d1))(tree1)
						
					case let (.Two(a, b), .One(a1)):
						return appendTree2(tree)(Node.node2(a, b))(Node.node2(a0, a1))(tree1)
						
					case let (.Two(a, b), .Two(a1, b1)):
						return appendTree2(tree)(Node.node3(a, b, a0))(Node.node2(a1, b1))(tree1)
						
					case let (.Two(a, b), .Three(a1, b1, c1)):
						return appendTree2(tree)(Node.node3(a, b, a0))(Node.node3(a1, b1, c1))(tree1)
						
					case let (.Two(a, b), .Four(a1, b1, c1, d1)):
						return appendTree3(tree)(Node.node3(a, b, a0))(Node.node2(a1, b1))(Node.node2(c1, d1))(tree1)
						
					case let (.Three(a, b, c), .One(a1)):
						return appendTree2(tree)(Node.node3(a, b, c))(Node.node2(a0, a1))(tree1)
						
					case let (.Three(a, b, c), .Two(a1, b1)):
						return appendTree2(tree)(Node.node3(a, b, c))(Node.node3(a0, a1, b1))(tree1)
						
					case let (.Three(a, b, c), .Three(a1, b1, c1)):
						return appendTree3(tree)(Node.node3(a, b, c))(Node.node2(a0, a1))(Node.node2(b1, c1))(tree1)
						
					case let (.Three(a, b, c), .Four(a1, b1, c1, d1)):
						return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(a0, a1, b1))(Node.node2(c1, d1))(tree1)
						
					case let (.Four(a, b, c, d), .One(a1)):
						return appendTree2(tree)(Node.node3(a, b, c))(Node.node3(d, a0, a1))(tree1)
						
					case let (.Four(a, b, c, d), .Two(a1, b1)):
						return appendTree3(tree)(Node.node3(a, b, c))(Node.node2(d, a0))(Node.node2(a1, b1))(tree1)
						
					case let (.Four(a, b, c, d), .Three(a1, b1, c1)):
						return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(d, a0, a1))(Node.node2(b1, c1))(tree1)
						
					case let (.Four(a, b, c, d), .Four(a1, b1, c1, d1)):
						return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(d, a0, a1))(Node.node3(b1, c1, d1))(tree1)
					}
				}
			}
		}
	}
}

public func addDigits2<V, A>(tree: FingerTree<V, Node<V, A>>) -> Digit<A> -> A -> A -> Digit<A> -> FingerTree<V, Node<V, A>> -> FingerTree<V, Node<V, A>> {
	return { digit in
		{ a0 in
			{ b0 in
				{ digit1 in
					{ tree1 in
						switch (digit, digit1) {
						case let (.One(a), .One(a1)):
							return appendTree2(tree)(Node.node2(a, a0))(Node.node2(b0, a1))(tree1)
							
						case let (.One(a), .Two(a1, b1)):
							return appendTree2(tree)(Node.node3(a, a0, b0))(Node.node2(a1, b1))(tree1)
							
						case let (.One(a), .Three(a1, b1, c1)):
							return appendTree2(tree)(Node.node3(a, a0, b0))(Node.node3(a1, b1, c1))(tree1)
							
						case let (.One(a), .Four(a1, b1, c1, d1)):
							return appendTree3(tree)(Node.node3(a, a0, b0))(Node.node2(a1, b1))(Node.node2(c1, d1))(tree1)
							
						case let (.Two(a, b), .One(a1)):
							return appendTree2(tree)(Node.node3(a, b, a0))(Node.node2(b0, a1))(tree1)
							
						case let (.Two(a, b), .Two(a1, b1)):
							return appendTree2(tree)(Node.node3(a, b, a0))(Node.node3(b0, a1, b1))(tree1)
							
						case let (.Two(a, b), .Three(a1, b1, c1)):
							return appendTree3(tree)(Node.node3(a, b, a0))(Node.node2(b0, a1))(Node.node2(b1, c1))(tree1)
							
						case let (.Two(a, b), .Four(a1, b1, c1, d1)):
							return appendTree3(tree)(Node.node3(a, b, a0))(Node.node3(b0, a1, b1))(Node.node2(c1, d1))(tree1)
							
						case let (.Three(a, b, c), .One(a1)):
							return appendTree2(tree)(Node.node3(a, b, c))(Node.node3(a0, b0, a1))(tree1)
							
						case let (.Three(a, b, c), .Two(a1, b1)):
							return appendTree3(tree)(Node.node3(a, b, c))(Node.node2(a0, b0))(Node.node2(a1, b1))(tree1)
							
						case let (.Three(a, b, c), .Three(a1, b1, c1)):
							return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(a0, b0, a1))(Node.node2(b1, c1))(tree1)
							
						case let (.Three(a, b, c), .Four(a1, b1, c1, d1)):
							return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(a0, b0, a1))(Node.node3(b1, c1, d1))(tree1)
							
						case let (.Four(a, b, c, d), .One(a1)):
							return appendTree3(tree)(Node.node3(a, b, c))(Node.node2(d, a0))(Node.node2(b0, a1))(tree1)
							
						case let (.Four(a, b, c, d), .Two(a1, b1)):
							return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(d, a0, b0))(Node.node2(a1, b1))(tree1)
							
						case let (.Four(a, b, c, d), .Three(a1, b1, c1)):
							return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(d, a0, b0))(Node.node3(a1, b1, c1))(tree1)
							
						case let (.Four(a, b, c, d), .Four(a1, b1, c1, d1)):
							return appendTree4(tree)(Node.node3(a, b, c))(Node.node3(d, a0, b0))(Node.node2(a1, b1))(Node.node2(c1, d1))(tree1)
						}
					}
				}
			}
		}
	}
}

public func addDigits3<V, A>(tree: FingerTree<V, Node<V, A>>) -> Digit<A> -> A -> A -> A -> Digit<A> -> FingerTree<V, Node<V, A>> -> FingerTree<V, Node<V, A>> {
	return { digit in
		{ a0 in
			{ b0 in
				{ c0 in
					{ digit1 in
						{ tree1 in
							switch (digit, digit1) {
							case let (.One(a), .One(a1)):
								return appendTree2(tree)(Node.node3(a, a0, b0))(Node.node2(c0, a1))(tree1)
								
							case let (.One(a), .Two(a1, b1)):
								return appendTree2(tree)(Node.node3(a, a0, b0))(Node.node3(c0, a1, b1))(tree1)
								
							case let (.One(a), .Three(a1, b1, c1)):
								return appendTree3(tree)(Node.node3(a, a0, b0))(Node.node2(c0, a1))(Node.node2(b1, c1))(tree1)
								
							case let (.One(a), .Four(a1, b1, c1, d1)):
								return appendTree3(tree)(Node.node3(a, a0, b0))(Node.node3(c0, a1, b1))(Node.node2(c1, d1))(tree1)
								
							case let (.Two(a, b), .One(a1)):
								return appendTree2(tree)(Node.node3(a, b, a0))(Node.node3(b0, c0, a1))(tree1)
								
							case let (.Two(a, b), .Two(a1, b1)):
								return appendTree3(tree)(Node.node3(a, b, a0))(Node.node2(b0, c0))(Node.node2(a1, b1))(tree1)
								
							case let (.Two(a, b), .Three(a1, b1, c1)):
								return appendTree3(tree)(Node.node3(a, b, a0))(Node.node3(b0, c0, a1))(Node.node2(b1, c1))(tree1)
								
							case let (.Two(a, b), .Four(a1, b1, c1, d1)):
								return appendTree3(tree)(Node.node3(a, b, a0))(Node.node3(b0, c0, a1))(Node.node3(b1, c1, d1))(tree1)
								
							case let (.Three(a, b, c), .One(a1)):
								return appendTree3(tree)(Node.node3(a, b, c))(Node.node2(a0, b0))(Node.node2(c0, a1))(tree1)
								
							case let (.Three(a, b, c), .Two(a1, b1)):
								return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(a0, b0, c0))(Node.node2(a1, b1))(tree1)
								
							case let (.Three(a, b, c), .Three(a1, b1, c1)):
								return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(a0, b0, c0))(Node.node3(a1, b1, c1))(tree1)
								
							case let (.Three(a, b, c), .Four(a1, b1, c1, d1)):
								return appendTree4(tree)(Node.node3(a, b, c))(Node.node3(a0, b0, c0))(Node.node2(a1, b1))(Node.node2(c1, d1))(tree1)
								
							case let (.Four(a, b, c, d), .One(a1)):
								return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(d, a0, b0))(Node.node2(c0, a1))(tree1)
								
							case let (.Four(a, b, c, d), .Two(a1, b1)):
								return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(d, a0, b0))(Node.node3(c0, a1, b1))(tree1)
								
							case let (.Four(a, b, c, d), .Three(a1, b1, c1)):
								return appendTree4(tree)(Node.node3(a, b, c))(Node.node3(d, a0, b0))(Node.node2(c0, a1))(Node.node2(b1, c1))(tree1)
								
							case let (.Four(a, b, c, d), .Four(a1, b1, c1, d1)):
								return appendTree4(tree)(Node.node3(a, b, c))(Node.node3(d, a0, b0))(Node.node3(c0, a1, b1))(Node.node2(c1, d1))(tree1)
							}
						}
					}
				}
			}
		}
	}
}

public func addDigits4<V, A>(tree: FingerTree<V, Node<V, A>>) -> Digit<A> -> A -> A -> A -> A -> Digit<A> -> FingerTree<V, Node<V, A>> -> FingerTree<V, Node<V, A>> {
	return { digit in
		{ a0 in
			{ b0 in
				{ c0 in
					{ d0 in
						{ digit1 in
							{ tree1 in
								switch (digit, digit1) {
								case let (.One(a), .One(a1)):
									return appendTree2(tree)(Node.node3(a, a0, b0))(Node.node3(c0, d0, a1))(tree1)
									
								case let (.One(a), .Two(a1, b1)):
									return appendTree3(tree)(Node.node3(a, a0, b0))(Node.node2(c0, d0))(Node.node2(a1, b1))(tree1)
									
								case let (.One(a), .Three(a1, b1, c1)):
									return appendTree3(tree)(Node.node3(a, a0, b0))(Node.node3(c0, d0, a1))(Node.node2(b1, c1))(tree1)
									
								case let (.One(a), .Four(a1, b1, c1, d1)):
									return appendTree3(tree)(Node.node3(a, a0, b0))(Node.node3(c0, d0, a1))(Node.node3(b1, c1, d1))(tree1)
									
								case let (.Two(a, b), .One(a1)):
									return appendTree3(tree)(Node.node3(a, b, a0))(Node.node2(b0, c0))(Node.node2(d0, a1))(tree1)
									
								case let (.Two(a, b), .Two(a1, b1)):
									return appendTree3(tree)(Node.node3(a, b, a0))(Node.node3(b0, c0, d0))(Node.node2(a1, b1))(tree1)
									
								case let (.Two(a, b), .Three(a1, b1, c1)):
									return appendTree3(tree)(Node.node3(a, b, a0))(Node.node3(b0, c0, d0))(Node.node3(a1, b1, c1))(tree1)
									
								case let (.Two(a, b), .Four(a1, b1, c1, d1)):
									return appendTree4(tree)(Node.node3(a, b, a0))(Node.node3(b0, c0, d0))(Node.node2(a1, b1))(Node.node2(c1, d1))(tree1)
									
								case let (.Three(a, b, c), .One(a1)):
									return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(a0, b0, c0))(Node.node2(d0, a1))(tree1)
									
								case let (.Three(a, b, c), .Two(a1, b1)):
									return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(a0, b0, c0))(Node.node3(d0, a1, b1))(tree1)
									
								case let (.Three(a, b, c), .Three(a1, b1, c1)):
									return appendTree4(tree)(Node.node3(a, b, c))(Node.node3(a0, b0, c0))(Node.node2(d0, a1))(Node.node2(b1, c1))(tree1)
									
								case let (.Three(a, b, c), .Four(a1, b1, c1, d1)):
									return appendTree4(tree)(Node.node3(a, b, c))(Node.node3(a0, b0, c0))(Node.node3(d0, a1, b1))(Node.node2(c1, d1))(tree1)
									
								case let (.Four(a, b, c, d), .One(a1)):
									return appendTree3(tree)(Node.node3(a, b, c))(Node.node3(d, a0, b0))(Node.node3(c0, d0, a1))(tree1)
									
								case let (.Four(a, b, c, d), .Two(a1, b1)):
									return appendTree4(tree)(Node.node3(a, b, c))(Node.node3(d, a0, b0))(Node.node2(c0, d0))(Node.node2(a1, b1))(tree1)
									
								case let (.Four(a, b, c, d), .Three(a1, b1, c1)):
									return appendTree4(tree)(Node.node3(a, b, c))(Node.node3(d, a0, b0))(Node.node3(c0, d0, a1))(Node.node2(b1, c1))(tree1)
									
								case let (.Four(a, b, c, d), .Four(a1, b1, c1, d1)):
									return appendTree4(tree)(Node.node3(a, b, c))(Node.node3(d, a0, b0))(Node.node3(c0, d0, a1))(Node.node3(b1, c1, d1))(tree1)
								}
							}
						}
					}
				}
			}
		}
	}
}