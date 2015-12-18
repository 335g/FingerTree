//  Copyright © 2015 Yoshiki Kudo. All rights reserved.

public enum Digit<T> {
	case One(T)
	case Two(T, T)
	case Three(T, T, T)
	case Four(T, T, T, T)
}