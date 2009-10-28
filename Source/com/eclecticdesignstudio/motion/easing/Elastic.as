package com.eclecticdesignstudio.motion.easing {
	
	
	/**
	 * @author Joshua Granick
	 * @author Philippe / http://philippe.elsass.me
	 * @author Robert Penner / http://www.robertpenner.com/easing_terms_of_use.html
	 */
	final public class Elastic {
		
		
		static public function get easeIn ():IEasing { return new ElasticEaseIn (0.1, 0.4); }
		static public function get easeOut ():IEasing { return new ElasticEaseOut (0.1, 0.4); }
		static public function get easeInOut ():IEasing { return new ElasticEaseInOut (0.1, 0.4); }
		
		
		static public function easeInWith (a:Number, p:Number):IEasing {
			
			return new ElasticEaseIn (a, p);
			
		}
		
		
		static public function easeOutWith (a:Number, p:Number):IEasing {
			
			return new ElasticEaseOut (a, p);
			
		}
		
		
		static public function easeInOutWith (a:Number, p:Number):IEasing {
			
			return new ElasticEaseInOut (a, p);
			
		}
		
		
	}
	

}


import com.eclecticdesignstudio.motion.easing.IEasing;


final class ElasticEaseIn implements IEasing {
	
	
	public var a:Number;
	public var p:Number;
	
	
	public function ElasticEaseIn (a:Number, p:Number) {
		
		this.a = a;
		this.p = p;
		
	}
	
	
	public function calculate (k:Number):Number {
		
		if (k == 0) return 0; if (k == 1) return 1; if (!p) p = 0.3;
		var s:Number;
		if (!a || a < 1) { a = 1; s = p / 4; }
		else s = p / (2 * Math.PI) * Math.asin (1 / a);
		return -(a * Math.pow(2, 10 * (k -= 1)) * Math.sin( (k - s) * (2 * Math.PI) / p ));
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		if (t == 0) {
			return b;
		}
		if ((t /= d) == 1) {
			return b + c;
		}
		if (!p) {
			p = d * 0.3;
		}
		var s:Number;
		if (!a || a < Math.abs(c)) {
			a = c;
			s = p / 4;
		}
		else {
			s = p / (2 * Math.PI) * Math.asin(c / a);
		}
		return -(a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
		
	}
	
	
}


final class ElasticEaseOut implements IEasing {
	
	
	public var a:Number;
	public var p:Number;
	
	
	public function ElasticEaseOut (a:Number, p:Number) {
		
		this.a = a;
		this.p = p;
		
	}
	
	
	public function calculate (k:Number):Number {
		
		if (k == 0) return 0; if (k == 1) return 1; if (!p) p = 0.3;
		var s:Number;
		if (!a || a < 1) { a = 1; s = p / 4; }
		else s = p / (2 * Math.PI) * Math.asin (1 / a);
		return (a * Math.pow(2, -10 * k) * Math.sin((k - s) * (2 * Math.PI) / p ) + 1);
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		if (t == 0) {
			return b;
		}
		if ((t /= d) == 1) {
			return b + c;
		}
		if (!p) {
			p = d * 0.3;
		}
		var s:Number;
		if (!a || a < Math.abs(c)) {
			a = c;
			s = p / 4;
		}
		else {
			s = p / (2 * Math.PI) * Math.asin(c / a);
		}
		return a * Math.pow(2, -10 * t) * Math.sin((t * d - s) * (2 * Math.PI) / p) + c + b;
		
	}
	
	
}


final class ElasticEaseInOut implements IEasing {
	
	
	public var a:Number;
	public var p:Number;
	
	
	public function ElasticEaseInOut (a:Number, p:Number) {
		
		this.a = a;
		this.p = p;
		
	}
	
	public function calculate (k:Number):Number {
		
		if (k == 0) return 0; if (k == 1) return 1; if (!p) p = 0.3;
		var s:Number;
		if (!a || a < 1) { a = 1; s = p / 4; }
		else s = p / (2 * Math.PI) * Math.asin (1 / a);
		if (k < 1) return -0.5 * (a * Math.pow(2, 10 * (k -= 1)) * Math.sin( (k - s) * (2 * Math.PI) / p ));
		return a * Math.pow(2, -10 * (k -= 1)) * Math.sin( (k - s) * (2 * Math.PI) / p ) * .5 + 1;
		
	}
	
	
	public function ease (t:Number, b:Number, c:Number, d:Number):Number {
		
		if (t == 0) {
			return b;
		}
		if ((t /= d / 2) == 2) {
			return b + c;
		}
		if (!p) {
			p = d * (0.3 * 1.5);
		}
		var s:Number;
		if (!a || a < Math.abs(c)) {
			a = c;
			s = p / 4;
		}
		else {
			s = p / (2 * Math.PI) * Math.asin(c / a);
		}
		if (t < 1) {
			return -0.5 * (a * Math.pow(2, 10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p)) + b;
		}
		return a * Math.pow(2, -10 * (t -= 1)) * Math.sin((t * d - s) * (2 * Math.PI) / p) * 0.5 + c + b;
		
	}
	
	
}