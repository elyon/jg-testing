package com.eclecticdesignstudio.motion.easing {
	
	
	/**
	 * @author Joshua Granick
	 * @author Philippe / http://philippe.elsass.me
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Quart {
		
		
		static public function get easeIn ():IEasing { return new QuartEaseIn (); }
		static public function get easeOut ():IEasing { return new QuartEaseOut (); }
		static public function get easeInOut ():IEasing { return new QuartEaseInOut (); }
		
		
	}
	

}


import com.eclecticdesignstudio.motion.easing.IEasing;


final class QuartEaseIn implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return k * k * k * k;
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return c * (t /= d) * t * t * t + b;
		
	}
	
	
}


final class QuartEaseOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return -(--k * k * k * k - 1);
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return -c * ((t = t / d - 1) * t * t * t - 1) + b;
		
	}
	
	
}


final class QuartEaseInOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		if (k < 0.5) return 0.5 * k * k * k * k;
		return -0.5 * ((k -= 2) * k * k * k - 2);
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		if ((t /= d / 2) < 1) {
			return c / 2 * t * t * t * t + b;
		}
		return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
		
	}
	
	
}