package com.eclecticdesignstudio.motion.actuators {
	
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	use namespace MotionInternal;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class ColorTransformActuator extends SimpleActuator {
		
		
		protected var amount:Number = 1;
		protected var endTransform:ColorTransform;
		protected var tweenTransform:ColorTransform;
		
		
		public function ColorTransformActuator (target:Object, duration:Number, properties:Object) {
			
			super (target, duration, properties);
			
			if ("amount" in properties) {
				
				amount = properties.amount;
				
			}
			
			endTransform = new ColorTransform ();
			
			if (amount < 1) {
				
				var multiplier:Number;
				var offset:Number;
				
				if (amount < 0.5) {
					
					multiplier = 1;
					offset = (amount * 2);
					
				} else {
					
					multiplier = 1 - ((amount - 0.5) * 2);
					offset = 1;
					
				}
				
				endTransform.redMultiplier = multiplier;
				endTransform.greenMultiplier = multiplier;
				endTransform.blueMultiplier = multiplier;
				
				endTransform.redOffset = offset * ((properties.color >> 16) & 0xFF);
				endTransform.greenOffset = offset * ((properties.color >> 8) & 0xFF);
				endTransform.blueOffset = offset * (properties.color & 0xFF);
				
			} else {
				
				endTransform.color = properties.color;
				
			}
			
		}
		
		
		MotionInternal override function apply ():void {
			
			if ("alpha" in properties) {
				
				endTransform.alphaMultiplier = properties.alpha;
				
			} else {
				
				endTransform.alphaMultiplier = (target as DisplayObject).transform.colorTransform.alphaMultiplier;
				
			}
			
			target.transform.colorTransform = endTransform;
			
		}
		
		
		protected override function initialize ():void {
			
			var begin:ColorTransform = (target as DisplayObject).transform.colorTransform;
			tweenTransform = new ColorTransform ();
			
			if ("alpha" in properties) {
				
				endTransform.alphaMultiplier = properties.alpha;
				
			} else {
				
				endTransform.alphaMultiplier = (target as DisplayObject).transform.colorTransform.alphaMultiplier;
				
			}
			
			var propertyNames:Array = [ "alphaMultiplier", "redMultiplier", "greenMultiplier", "blueMultiplier", "redOffset", "greenOffset", "blueOffset" ];
			
			var details:PropertyDetails;
			var start:Number;
			
			for each (var propertyName:String in propertyNames) {
				
				start = Number (begin[propertyName]);
				details = new PropertyDetails (tweenTransform, propertyName, start, Number (endTransform[propertyName] - start));
				propertyDetails.push (details);
				
			}
			
			initialized = true;
			
		}
		
		
		MotionInternal override function move ():void {
			
			super.MotionInternal::move ();
			
		}
		
		
		MotionInternal override function update (elapsedTime:Number):void {
			
			super.MotionInternal::update (elapsedTime);
			
			target.transform.colorTransform = tweenTransform;
			
		}
		
		
	}
	

}