package com.eclecticdesignstudio.motion.actuators {
	
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	
	use namespace MotionInternal;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class FilterActuator extends SimpleActuator {
		
		
		private var filter:BitmapFilter;
		private var tweenTarget:DisplayObject;
		
		
		public function FilterActuator (target:Object, duration:Number, properties:Object) {
			
			super (target, duration, properties);
			
		}
		
		
		MotionInternal override function apply ():void {
			
			filter = target.filters[properties.index];
			
			for (var propertyName:String in properties) {
				
				if (propertyName != "index") {
					
					filter[propertyName] = properties[propertyName];
					
				}
				
			}
			
			var filters:Array = target.filters;
			filters[properties.index] = filter;
			target.filters = filters;
			
		}
		
		
		protected override function initialize ():void {
			
			filter = target.filters[properties.index];
			
			var details:PropertyDetails;
			var start:Number;
			
			for (var propertyName:String in properties) {
				
				if (propertyName != "index") {
					
					start = Number (filter[propertyName]);
					details = new PropertyDetails (filter, propertyName, start, Number (properties[propertyName] - start));
					propertyDetails.push (details);
					
				}
				
			}
			
			initialized = true;
			
		}
		
		
		MotionInternal override function move ():void {
			
			super.move ();
			
		}
		
		
		MotionInternal override function update (elapsedTime:Number):void {
			
			super.update (elapsedTime);
			
			var filters:Array = target.filters;
			filters[properties.index] = filter;
			target.filters = filters;
			
		}
		
		
	}
	

}