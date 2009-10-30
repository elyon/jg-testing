package com.eclecticdesignstudio.motion.easing {
	
	
	/**
	 * @author Joshua Granick
	 * @author Zeh Fernando, Nate Chatellier
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Back {
		
		
		static public function get easeIn ():IEasing { return new BackEaseIn (); }
		static public function get easeOut ():IEasing { return new BackEaseOut (); }
		static public function get easeInOut ():IEasing { return new BackEaseInOut (); }
		
		
	}
	

}


import com.eclecticdesignstudio.motion.easing.IEasing;


final class BackEaseIn implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		var s:Number = 1.70158;
		return k * k * ((s + 1) * k - s);
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		var s:Number = 1.70158;
		return c*(t/=d)*t*((s+1)*t - s) + b;
		
	}
	
	
}


final class BackEaseOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		var s:Number = 1.70158;
		return ((k = k - 1) * k * ((s + 1) * k + s) + 1);
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		var s:Number = 1.70158;
		return c*((t=t/d-1)*t*((s+1)*t + s) + 1) + b;
		
	}
	
	
}


final class BackEaseInOut implements IEasing {
	
	
	public function calculate (k:Number):Number {
		
		var s:Number = 1.70158;
		if ((k /= 0.5) < 1) return 0.5 * (k * k * (((s *= (1.525)) + 1) * k - s));
		return 0.5 * ((k -= 2) * k * (((s *= (1.525)) + 1) * k + s) + 2);
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		var s:Number = 1.70158;
		if ((t/=d/2) < 1) return c/2*(t*t*(((s*=(1.525))+1)*t - s)) + b;
		return c/2*((t-=2)*t*(((s*=(1.525))+1)*t + s) + 2) + b;
		
	}
	
	
}