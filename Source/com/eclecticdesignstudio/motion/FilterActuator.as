package com.eclecticdesignstudio.motion {
	
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class FilterActuator extends SimpleActuator {
		
		
		private var filter:BitmapFilter;
		private var filterIndex:uint;
		private var tweenTarget:DisplayObject;
		
		
		public function FilterActuator (target:Object, duration:Number, properties:Object, tweenProperties:Object) {
			
			super (target, duration, properties, tweenProperties);
			
			tweenTarget = target as DisplayObject;
			
			if ("filter" in properties) {
				
				filterIndex = properties.filter;
				filter = tweenTarget.filters[filterIndex];
				
				delete properties.filter;
				
			}
			
			this.target = filter;
			
		}
		
		
		public override function apply ():void {
			
			super.apply ();
			
			var filters:Array = tweenTarget.filters;
			filters[filterIndex] = filter;
			tweenTarget.filters = filters;
			
		}
		
		
		public override function move ():void {
			
			super.move ();
			
		}
		
		
		public override function update (elapsedTime:Number):void {
			
			super.update (elapsedTime);
			
			var filters:Array = tweenTarget.filters;
			filters[filterIndex] = filter;
			tweenTarget.filters = filters;
			
		}
		
		
	}
	

}