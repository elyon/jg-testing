package com.eclecticdesignstudio.motion.easing {
	
	
	/**
	 * @author Joshua Granick
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Expo {
		
		
		static public function get easeIn ():IEasing { return new ExpoEaseIn (); }
		static public function get easeOut ():IEasing { return new ExpoEaseOut (); }
		static public function get easeInOut ():IEasing { return new ExpoEaseInOut (); }
		
		
	}
	

}


import com.eclecticdesignstudio.motion.easing.IEasing;


final class ExpoEaseIn implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return k == 0 ? 0 : Math.pow(2, 10 * (k - 1));
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return t == 0 ? b : c * Math.pow(2, 10 * (t / d - 1)) + b;
		
	}
	
	
}


final class ExpoEaseOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return k == 1 ? 1 : (1 - Math.pow(2, -10 * k));
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return t == d ? b + c : c * (1 - Math.pow(2, -10 * t / d)) + b;
		
	}
	
	
}


final class ExpoEaseInOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		if (k == 0) { return 0; }
		if (k == 1) { return 1; }
		if ((k /= 1 / 2.0) < 1.0) {
			return 0.5 * Math.pow(2, 10 * (k - 1));
		}
		return 0.5 * (2 - Math.pow(2, -10 * --k));
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		if (t == 0) {
			return b;
		}
		if (t == d) {
			return b + c;
		}
		if ((t /= d / 2.0) < 1.0) {
			return c / 2 * Math.pow(2, 10 * (t - 1)) + b;
		}
		return c / 2 * (2 - Math.pow(2, -10 * --t)) + b;
		
	}
	
	
}