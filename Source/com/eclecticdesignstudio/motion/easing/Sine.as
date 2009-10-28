package com.eclecticdesignstudio.motion.easing {
	
	
	/**
	 * @author Joshua Granick
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Sine {
		
		
		static public function get easeIn ():IEasing { return new SineEaseIn (); }
		static public function get easeOut ():IEasing { return new SineEaseOut (); }
		static public function get easeInOut ():IEasing { return new SineEaseInOut (); }
		
		
	}
	
	
}


import com.eclecticdesignstudio.motion.easing.IEasing;


final class SineEaseIn implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return 1 - Math.cos(k * (Math.PI / 2));
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
		
	}
	
	
}


final class SineEaseOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return Math.sin(k * (Math.PI / 2));
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return c * Math.sin(t / d * (Math.PI / 2)) + b;
		
	}
	
	
}


final class SineEaseInOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		return - (Math.cos(Math.PI * k) - 1) / 2;
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
		
	}
	
	
}
