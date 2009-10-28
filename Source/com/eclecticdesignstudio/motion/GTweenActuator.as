package com.eclecticdesignstudio.motion {
	
	
	import com.eclecticdesignstudio.motion.easing.Expo;
	import com.gskinner.motion.GTween;
	import flash.events.Event;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class GTweenActuator extends GenericActuator {
		
		
		public static const TIME:String = "time";
		public static const FRAME:String = "frame";
		public static const HYBRID:String = "hybrid";
		
		public static var defaultEase:IEasing = Expo.easeOut;
		
		private var tween:GTween;
		
		
		public function GTweenActuator (target:Object, duration:Number, properties:Object, tweenProperties:Object) {
			
			super (target, duration, properties, tweenProperties);
			
		}
		
		
		public override function move ():void {
			
			var instanceProperties:Object = { completeListener: tween_onComplete, ease: defaultEase.ease };
			
			if (tweenProperties) {
				
				if ("autoRotation" in tweenProperties) { instanceProperties.autoRotation = tweenProperties.autoRotation; }
				if ("autoVisible" in tweenProperties) { instanceProperties.autoVisible = tweenProperties.autoVisible; }
				if ("changeListener" in tweenProperties || "onChange" in tweenProperties) { instanceProperties.changeListener = tween_onChange }
				if ("delay" in tweenProperties) { instanceProperties.delay = tweenProperties.delay; }
				if ("ease" in tweenProperties) { instanceProperties.ease = tweenProperties.ease.easing; }
				if ("reflect" in tweenProperties) { instanceProperties.reflect = tweenProperties.reflect; }
				if ("repeat" in tweenProperties) { instanceProperties.repeat = tweenProperties.repeat; }
				if ("snapping" in tweenProperties) { instanceProperties.snapping = tweenProperties.snapping; }
				
			}
			
			tween = new GTween (target, duration, properties, instanceProperties);
			
		}
		
		
		public override function pause ():void {
			
			tween.pause ();
			
		}
		
		
		public override function resume ():void {
			
			tween.play ();
			
		}
		
		
		public override function stop (properties:Object, sendEvent:Boolean):void {
			
			for (var propertyName:String in properties) {
				
				if (!properties || (tween && propertyName in this.properties)) {
					
					tween.deleteProperty (propertyName);
					
				}
				
			}
			
			if (tween) {
				
				return;
				
			}
			
			complete (sendEvent);
			
		}
		
		
		
		
		// Event Handlers
		
		
		
		
		private function tween_onChange (event:Event):void {
			
			change ();
			
		}
		
		
		private function tween_onComplete (event:Event):void {
			
			complete ();
			
		}
		
		
		
		
		// Get & Set Methods
		
		
		
		
		public static function get timingMode ():String {
			
			return GTween.timingMode;
			
		}
		
		
		public static function set timingMode (value:String):void {
			
			GTween.timingMode = value;
			
		}
		
		
	}
	
	
}