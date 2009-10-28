package com.eclecticdesignstudio.motion.easing {
	
	
	/**
	 * @author Joshua Granick
	 * @author Philippe / http://philippe.elsass.me
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Linear {
		
		
		static public function get easeNone ():IEasing { return new LinearEaseNone (); }
		
		
	}
	

}


import com.eclecticdesignstudio.motion.easing.IEasing;


final class LinearEaseNone implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return k;
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return c * t / d + b;
		
	}
	
	
}