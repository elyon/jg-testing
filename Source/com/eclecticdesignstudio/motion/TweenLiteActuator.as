package com.eclecticdesignstudio.motion {
	
	
	import com.eclecticdesignstudio.motion.easing.Expo;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenLite;
	import flash.events.Event;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class TweenLiteActuator extends GenericActuator {
		
		
		public static var defaultEase:IEasing = Expo.easeOut;
		
		private var tween:TweenLite;
		
		
		public function TweenLiteActuator (target:Object, duration:Number, properties:Object, tweenProperties:Object) {
			
			super (target, duration, properties, tweenProperties);
			
		}
		
		
		public override function move ():void {
			
			properties.ease = defaultEase.ease;
			properties.onComplete = tween_onComplete;
			
			if (tweenProperties) {
				
				if ("changeListener" in tweenProperties || "onChange" in tweenProperties) { properties.onUpdate = change; }
				if ("delay" in tweenProperties) { properties.delay = tweenProperties.delay; }
				if ("ease" in tweenProperties) { properties.ease = tweenProperties.ease.ease; }
				
			}
			
			tween = new TweenLite (target, duration, properties);
			
		}
		
		
		public override function pause ():void {
			
			
			
		}
		
		
		public override function resume ():void {
			
			
			
		}
		
		
		public override function stop (properties:Object, sendEvent:Boolean):void {
			
			if (tween) {
				
				tween.killVars (properties);
				
				for (var propertyName:String in tween.propTweenLookup) {
					
					return;
					
				}
				
			}
			
			tween = null;
			
			complete (sendEvent);
			
		}
		
		
		
		
		// Event Handlers
		
		
		
		
		private function tween_onComplete ():void {
			
			tween = null;
			complete ();
			
		}
		
		
	}
	
	
}