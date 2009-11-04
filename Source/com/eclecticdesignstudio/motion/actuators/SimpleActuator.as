package com.eclecticdesignstudio.motion.actuators {
	
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	use namespace MotionInternal;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class SimpleActuator extends GenericActuator {
		
		
		MotionInternal var timeOffset:Number;
		
		protected static var actuators:Array = new Array ();
		protected static var shape:Shape;
		
		protected var active:Boolean = true;
		protected var cacheVisible:Boolean;
		protected var initialized:Boolean;
		protected var paused:Boolean;
		protected var pauseTime:Number;
		protected var propertyDetails:Array = new Array ();
		protected var sendChange:Boolean;
		protected var setVisible:Boolean;
		protected var startTime:Number = getTimer () / 1000;
		protected var toggleVisible:Boolean;
		
		
		public function SimpleActuator (target:Object, duration:Number, properties:Object) {
			
			super (target, duration, properties);
			
			if (!shape) {
				
				shape = new Shape ();
				shape.addEventListener (Event.ENTER_FRAME, shape_onEnterFrame);
				
			}
			
		}
		
		
		/**
		 * @inheritDoc
		 */
		public override function autoVisible (value:Boolean = true):GenericActuator {
			
			MotionInternal::autoVisible = value;
			
			if (!value) {
				
				toggleVisible = false;
				
				if (setVisible) {
					
					target.visible = cacheVisible;
					
				}
				
			}
			
			return this;
			
		}
		
		
		/**
		 * @inheritDoc
		 */
		public override function delay (duration:Number):GenericActuator {
			
			MotionInternal::delay = duration;
			timeOffset = startTime + duration;
			
			return this;
			
		}
		
		
		protected function initialize ():void {
			
			var details:PropertyDetails;
			var start:Number;
			
			for (var propertyName:String in properties) {
				
				start = Number (target[propertyName]);
				details = new PropertyDetails (target, propertyName, start, Number (properties[propertyName] - start));
				propertyDetails.push (details);
				
			}
			
			initialized = true;
			
		}
		
		
		MotionInternal override function move ():void {
			
			toggleVisible = ("alpha" in properties && target is DisplayObject);
			
			if (toggleVisible && properties.alpha != 0) {
				
				setVisible = true;
				cacheVisible = target.visible;
				target.visible = true;
				
			}
			
			timeOffset = startTime;
			actuators.push (this);
			
		}
		
		
		/**
		 * @inheritDoc
		 */
		public override function onChange (handler:Function, ... parameters:Array):GenericActuator {
			
			MotionInternal::onChange = handler;
			MotionInternal::onChangeParams = parameters;
			sendChange = true;
			
			return this;
			
		}
		
		
		MotionInternal override function pause ():void {
			
			paused = true;
			pauseTime = getTimer ();
			
		}
		
		
		MotionInternal override function resume ():void {
			
			if (paused) {
				
				paused = false;
				timeOffset += (getTimer () - pauseTime) / 1000;
				
			}
			
		}
		
		
		MotionInternal override function stop (properties:Object, sendEvent:Boolean):void {
			
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
		
		
		MotionInternal function update (elapsedTime:Number):void {
			
			if (!paused) {
				
				var details:PropertyDetails;
				var easing:Number;
				var i:int;
				
				var tweenPosition:Number = elapsedTime / duration;
				
				if (tweenPosition > 1) {
					
					tweenPosition = 1;
					
				}
				
				if (!initialized) {
					
					initialize ();
					
				}
				
				if (!MotionInternal::reverse) {
					
					easing = MotionInternal::ease.calculate (tweenPosition);
					
				} else {
					
					easing = MotionInternal::ease.calculate (1 - tweenPosition);
					
				}
				
				if (!MotionInternal::snapping) {
					
					for (i = 0; i < propertyDetails.length; i++) {
						
						details = propertyDetails[i];
						details.target[details.propertyName] = details.start + (details.change * easing);
						
					}
					
				} else {
					
					for (i = 0; i < propertyDetails.length; i++) {
						
						details = propertyDetails[i];
						details.target[details.propertyName] = Math.round (details.start + (details.change * easing));
						
					}
					
				}
				
				if (tweenPosition === 1) {
					
					if (MotionInternal::repeat === 0) {
						
						active = false;
						
						if (toggleVisible && target.alpha === 0) {
							
							target.visible = false;
							
						}
						
						complete (true);
						return;
						
					} else {
						
						if (MotionInternal::reflect) {
							
							MotionInternal::reverse = !MotionInternal::reverse;
							
						}
						
						startTime = getTimer () / 1000;
						timeOffset = startTime + MotionInternal::delay;
						
						if (MotionInternal::repeat > 0) {
							
							MotionInternal::repeat --;
							
						}
						
					}
					
				}
				
				if (sendChange) {
					
					change ();
					
				}
				
			}
			
		}
		
		
		
		
		// Event Handlers
		
		
		
		
		protected static function shape_onEnterFrame (event:Event):void {
			
			var currentTime:Number = getTimer () / 1000;
			
			var actuator:SimpleActuator;
			
			for (var i:int = 0; i < actuators.length; i++) {
				
				actuator = actuators[i];
				
				if (actuator.active) {
					
					if (currentTime > actuator.timeOffset) {
						
						actuator.MotionInternal::update (currentTime - actuator.timeOffset);
						
					}
					
				} else {
					
					actuators.splice (i, 1);
					i --;
					
				}
				
			}
			
		}
		
		
	}
	
	
}