package com.eclecticdesignstudio.motion.easing {
	
	
	/**
	 * @author Joshua Granick
	 * @author Philippe / http://philippe.elsass.me
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Quad {
		
		
		static public function get easeIn ():IEasing { return new QuadEaseIn (); }
		static public function get easeOut ():IEasing { return new QuadEaseOut (); }
		static public function get easeInOut ():IEasing { return new QuadEaseInOut (); }
		
		
	}
	

}


import com.eclecticdesignstudio.motion.easing.IEasing;


final class QuadEaseIn implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return k * k;
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return c * (t /= d) * t + b;
		
	}
	
	
}


final class QuadEaseOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return -k * (k - 2);
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return -c * (t /= d) * (t - 2) + b;
		
	}
	
	
}


final class QuadEaseInOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		if ((k *= 2) < 1) {
			return 1 / 2 * k * k;
		}
		return -1 / 2 * ((--k) * (k - 2) - 1);
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		if ((t /= d / 2) < 1) {
			return c / 2 * t * t + b;
		}
		return -c / 2 * ((--t) * (t - 2) - 1) + b;
		
	}
	
	
}