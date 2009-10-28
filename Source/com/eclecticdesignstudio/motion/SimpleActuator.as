package com.eclecticdesignstudio.motion {
	
	
	import com.eclecticdesignstudio.motion.easing.Expo;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class SimpleActuator extends GenericActuator {
		
		
		public static var defaultEase:IEasing = Expo.easeOut;
		
		private static var actuators:Array = new Array ();
		private static var shape:Shape;
		
		public var timeOffset:Number;
		public var initialized:Boolean;
		
		private var active:Boolean = true;
		private var delay:Number = 0;
		private var ease:IEasing = defaultEase;
		private var paused:Boolean;
		private var pauseTime:Number;
		private var propertyDetails:Array = new Array ();
		private var sendChange:Boolean;
		private var startTime:Number = getTimer () / 1000;
		private var toggleVisible:Boolean;
		
		
		public function SimpleActuator (target:Object, duration:Number, properties:Object, tweenProperties:Object) {
			
			super (target, duration, properties, tweenProperties);
			
			if (!shape) {
				
				shape = new Shape ();
				shape.addEventListener (Event.ENTER_FRAME, shape_onEnterFrame);
				
			}
			
		}
		
		
		public override function move ():void {
			
			toggleVisible = ("alpha" in properties && target is DisplayObject);
			
			if (tweenProperties) {
				
				if ("autoVisible" in tweenProperties) { toggleVisible = tweenProperties.autoVisible; }
				if ("changeListener" in tweenProperties || "onChange" in tweenProperties) { sendChange = true; }
				if ("delay" in tweenProperties) { delay = tweenProperties.delay; initialized = false; }
				if ("ease" in tweenProperties) { ease = tweenProperties.ease; }
				
			}
			
			if (toggleVisible && properties.alpha != 0) {
				
				target.visible = true;
				
			}
			
			timeOffset = startTime + delay;
			actuators.push (this);
			
		}
		
		
		public override function pause ():void {
			
			paused = true;
			pauseTime = getTimer ();
			
		}
		
		
		public override function resume ():void {
			
			if (paused) {
				
				paused = false;
				timeOffset += (getTimer () - pauseTime) / 1000;
				
			}
			
		}
		
		
		public override function stop (properties:Object, sendEvent:Boolean):void {
			
			if (active) {
				
				for (var propertyName:String in properties) {
					
					if (propertyName in this.properties) {
						
						active = false;
						complete (sendEvent);
						return;
						
					}
					
				}
				
				if (!properties) {
					
					active = false;
					complete (sendEvent);
					return;
					
				}
				
			}
			
		}
		
		
		public function update (elapsedTime:Number):void {
			
			if (!paused) {
				
				var details:PropertyDetails;
				var tweenPosition:Number = elapsedTime / duration;
				
				if (tweenPosition > 1) {
					
					tweenPosition = 1;
					
				}
				
				if (!initialized) {
					
					var start:Number;
					
					for (var propertyName:String in properties) {
						
						start = Number (target[propertyName]);
						details = new PropertyDetails (propertyName, start, Number (properties[propertyName] - start));
						propertyDetails.push (details);
						
					}
					
					initialized = true;
					
				}
				
				var easing:Number = ease.calculate (tweenPosition);
				
				for (var i:uint = 0; i < propertyDetails.length; i++) {
					
					details = propertyDetails[i];
					target[details.propertyName] = details.start + (details.change * easing);
					
				}
				
				if (tweenPosition === 1) {
					
					active = false;
					
					if (toggleVisible && target.alpha === 0) {
						
						target.visible = false;
						
					}
					
					complete (true);
					return;
					
				}
				
				if (sendChange) {
					
					change ();
					
				}
				
			}
			
		}
		
		
		
		
		// Event Handlers
		
		
		
		
		private static function shape_onEnterFrame (event:Event):void {
			
			var currentTime:Number = getTimer () / 1000;
			
			var actuator:SimpleActuator;
			
			for (var i:uint = 0; i < actuators.length; i++) {
				
				actuator = actuators[i];
				
				if (actuator.active) {
					
					if (currentTime > actuator.timeOffset) {
						
						actuator.update (currentTime - actuator.timeOffset);
						
					}
					
				} else {
					
					actuators.splice (i, 1);
					i --;
					
				}
				
			}
			
		}
		
		
	}
	
	
}




class PropertyDetails {
	
	
	public var propertyName:String;
	public var start:Number;
	public var change:Number;
	
	
	public function PropertyDetails (propertyName:String, start:Number, change:Number):void {
		
		this.propertyName = propertyName;
		this.start = start;
		this.change = change;
		
	}
	
	
}