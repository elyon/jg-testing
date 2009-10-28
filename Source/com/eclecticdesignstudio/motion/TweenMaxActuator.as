package com.eclecticdesignstudio.motion {
	
	
	import com.eclecticdesignstudio.motion.easing.Expo;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	import com.greensock.OverwriteManager;
	import com.greensock.TweenMax;
	import flash.events.Event;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class TweenMaxActuator extends GenericActuator {
		
		
		public static var defaultEase:IEasing = Expo.easeOut;
		
		private var tween:TweenMax;
		
		
		public function TweenMaxActuator (target:Object, duration:Number, properties:Object, tweenProperties:Object) {
			
			super (target, duration, properties, tweenProperties);
			
		}
		
		
		public override function move ():void {
			
			properties.ease = defaultEase.ease;
			properties.onComplete = tween_onComplete;
			
			if ("alpha" in properties) {
				
				properties.shortAlpha = properties.alpha;
				delete properties.alpha;
				
			}
			
			if (tweenProperties) {
				
				if ("autoRotation" in tweenProperties && "rotation" in properties) {
					
					properties.shortRotation = properties.rotation;
					delete properties.rotation;
					
				}
				
				if ("autoVisible" in tweenProperties && !tweenProperties.autoVisible && "alpha" in properties) {
					
					properties.alpha = properties.autoAlpha;
					delete properties.autoAlpha;
					
				}
				
				if ("changeListener" in tweenProperties || "onChange" in tweenProperties) { properties.onUpdate = change; }
				if ("delay" in tweenProperties) { properties.delay = tweenProperties.delay; }
				if ("ease" in tweenProperties) { properties.ease = tweenProperties.ease.ease; }
				if ("reflect" in tweenProperties) { properties.yoyo = tweenProperties.reflect; }
				if ("repeat" in tweenProperties) { properties.repeat = tweenProperties.repeat; }
				
				if ("snapping" in tweenProperties) { 
					
					var roundProps:Array = new Array ();
					
					for (var propertyName:String in properties) {
						
						roundProps.push (propertyName);
						
					}
					
					properties.roundProps = roundProps;
					
				}
				
			}
			
			tween = new TweenMax (target, duration, properties);
			
		}
		
		
		public override function pause ():void {
			
			tween.pause ();
			
		}
		
		
		public override function resume ():void {
			
			tween.resume ();
			
		}
		
		
		public override function stop (properties:Object, sendEvent:Boolean):void {
			
			if (tween) {
				
				tween.killVars (properties);
				
				for (var propertyName:String in tween.propTweenLookup) {
					
					return;
					
				}
				
			}
			
			tween = null;
			
		}
		
		
		
		
		// Event Handlers
		
		
		
		
		private function tween_onComplete ():void {
			
			tween = null;
			complete ();
			
		}
		
		
	}
	
	
}