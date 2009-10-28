package com.eclecticdesignstudio.motion {
	
	
	import aze.motion.Eaze;
	import com.eclecticdesignstudio.motion.easing.Expo;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	import flash.events.Event;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class EazeActuator extends GenericActuator {
		
		
		public static var defaultEase:IEasing = Expo.easeOut;
		
		private var tween:Eaze;
		
		
		public function EazeActuator (target:Object, duration:Number, properties:Object, tweenProperties:Object) {
			
			super (target, duration, properties, tweenProperties);
			
		}
		
		
		public override function move ():void {
			
			var delay:Number = 0;
			var ease:IEasing = defaultEase;
			
			if (tweenProperties) {
				
				if ("changeListener" in tweenProperties || "onChange" in tweenProperties) { properties.onUpdate = change; }
				if ("delay" in tweenProperties) { delay = tweenProperties.delay; }
				if ("ease" in tweenProperties) { ease = tweenProperties.ease; }
				
			}
			
			tween = Eaze.delay (delay).chainTo (target, duration, properties).ease (ease.calculate).onComplete (tween_onComplete);
			
		}
		
		
		public override function pause ():void {
			
			
			
		}
		
		
		public override function resume ():void {
			
			
			
		}
		
		
		public override function stop (properties:Object, sendEvent:Boolean):void {
			
			if (tween) {
				
				for (var propertyName:String in properties) {
					
					if (propertyName in this.properties) {
						
						tween.kill ();
						tween = null;
						complete (sendEvent);
						return;
						
					}
					
				}
				
				if (!properties) {
					
					tween.kill ();
					tween = null;
					complete (sendEvent);
					
				}
				
			}
			
		}
		
		
		
		
		// Event Handlers
		
		
		
		
		private function tween_onComplete ():void {
			
			tween = null;
			complete ();
			
		}
		
		
	}
	
	
}