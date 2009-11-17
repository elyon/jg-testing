package com.eclecticdesignstudio.motion.actuators {
	
	
	import com.eclecticdesignstudio.motion.actuators.MotionInternal;
	
	use namespace MotionInternal;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.1
	 */
	public class MethodActuator extends SimpleActuator {
		
		
		protected var tweenProperties:Object = new Object ();
		
		
		public function MethodActuator (target:Object, duration:Number, properties:Object) {
			
			super (target, duration, properties);
			
		}
		
		
		protected override function initialize ():void {
			
			var details:PropertyDetails;
			var propertyName:String;
			var start:Object;
			
			for (var i:uint = 0; i < (properties.start as Array).length; i++) {
				
				propertyName = "param" + i;
				start = properties.start[i];
				
				tweenProperties[propertyName] = start;
				
				if (start is Number) {
					
					details = new PropertyDetails (tweenProperties, propertyName, start as Number, Number (properties.end[i]) - (start as Number));
					propertyDetails.push (details);
					
				}
				
			}
			
			initialized = true;
			
		}
		
		
		MotionInternal override function update (elapsedTime:Number):void {
			
			super.update (elapsedTime);
			
			var parameters:Array = new Array ();
			
			for (var i:uint = 0; i < properties.start.length; i++) {
				
				parameters.push (tweenProperties["param" + i]);
				
			}
			
			(target as Function).apply (null, parameters);
			
		}
		
		
	}
	

}