package com.eclecticdesignstudio.motion.easing {
	
	
	/**
	 * @author Joshua Granick
	 * @author Philippe / http://philippe.elsass.me
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Cubic {
		
		
		static public function get easeIn ():IEasing { return new CubicEaseIn (); }
		static public function get easeOut ():IEasing { return new CubicEaseOut (); }
		static public function get easeInOut ():IEasing { return new CubicEaseInOut (); }
		
		
	}
	

}


import com.eclecticdesignstudio.motion.easing.IEasing;


final class CubicEaseIn implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return k * k * k;
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return c * (t /= d) * t * t + b;
		
	}
	
	
}


final class CubicEaseOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return --k * k * k + 1;
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return c * ((t = t / d - 1) * t * t + 1) + b;
		
	}
	
	
}


final class CubicEaseInOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return ((k /= 1 / 2) < 1) ? 0.5 * k * k * k : 0.5 * ((k -= 2) * k * k + 2);
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return ((t /= d / 2) < 1) ? c / 2 * t * t * t + b : c / 2 * ((t -= 2) * t * t + 2) + b;
		
	}
	
	
}