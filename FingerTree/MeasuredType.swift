//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public protocol MeasuredType {
	typealias Value: Monoid
	typealias Annotation
	
	func measure(annotation: Annotation) -> Value
}

