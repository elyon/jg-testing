package com.eclecticdesignstudio.motion {
	
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import org.libspark.betweenas3.BetweenAS3;
	import com.eclecticdesignstudio.motion.easing.Expo;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	import org.libspark.betweenas3.easing.Custom;
	import org.libspark.betweenas3.tweens.ITween;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class BetweenAS3Actuator extends GenericActuator {
		
		
		protected static var _defaultEase:IEasing = Expo.easeOut;
		protected static var _defaultEaseFunction:org.libspark.betweenas3.easing.IEasing = Custom.func (Expo.easeOut.ease);
		
		private var toggleVisibleOnComplete:Boolean;
		private var tween:ITween;
		
		
		public function BetweenAS3Actuator (target:Object, duration:Number, properties:Object, tweenProperties:Object) {
			
			super (target, duration, properties, tweenProperties);
			
		}
		
		
		public override function move ():void {
			
			var cacheProperties:Object;
			var ease:org.libspark.betweenas3.easing.IEasing = _defaultEaseFunction;
			var delay:Number = 0;
			var toggleVisible:Boolean = ("alpha" in properties && target is DisplayObject);
			
			if (tweenProperties) {
				
				if ("ease" in tweenProperties) { ease = Custom.func (tweenProperties.ease.easing); }
				if ("delay" in tweenProperties) { delay = tweenProperties.delay; }
				
			}
			
			tween = BetweenAS3.tween (target, properties, initProperties, duration, ease, delay);
			
			if (tweenProperties) {
				
				if ("autoVisible" in tweenProperties) { toggleVisible = tweenProperties.autoVisible; }
				if ("changeListener" in tweenProperties || "onChange" in tweenProperties) { tween.onUpdate = change; }
				if ("repeat" in tweenProperties) { BetweenAS3.repeat (tween, tweenProperties.repeat); }
				
				if ("overwrite" in tweenProperties && !tweenProperties.overwrite) {
					
					cacheProperties = new Object ();
					
					for (var property:String in properties) {
						
						cacheProperties[property] = target[property];
						
					}
					
				}
				
			}
			
			if (toggleVisible && properties.alpha > 0) {
				
				target.visible = true;
				toggleVisibleOnComplete = true;
				
			}
			
			tween.play ();
			
			if (cacheProperties) {
				
				for (property in cacheProperties) {
					
					target[property] = cacheProperties[property];
					
				}
				
			}
			
			tween.onComplete = tween_onComplete;
			
		}
		
		
		public override function pause ():void {
			
			tween.stop ();
			
		}
		
		
		public override function resume ():void {
			
			if (!tween.isPlaying) {
				
				tween.play ();
				
			}
			
		}
		
		
		public override function stop (properties:Object, sendEvent:Boolean):void {
			
			for (var propertyName:String in properties) {
				
				if (propertyName in this.properties) {
					
					if (tween && tween.isPlaying) {
						
						tween.stop ();
						tween = null;
						complete (sendEvent);
						
					}
					
					return;
					
				}
				
			}
			
			if (!properties) {
				
				if (tween && tween.isPlaying) {
					
					tween.stop ();
					tween = null;
					complete (sendEvent);
					
				}
				
				return;
				
			}
			
		}
		
		
		
		
		// Event Handlers
		
		
		
		
		private function tween_onComplete ():void {
			
			if (toggleVisibleOnComplete && target.alpha == 0) {
				
				target.visible = false;
				
			}
			
			tween = null;
			complete ();
			
		}
		
		
		
		
		// Get & Set Methods
		
		
		
		
		public static function get defaultEase ():IEasing {
			
			return _defaultEase;
			
		}
		
		
		public static function set defaultEase (value:IEasing):void {
			
			_defaultEase = value;
			_defaultEaseFunction = Custom.func (_defaultEase.ease);
			
		}
		
		
	}
	
	
}