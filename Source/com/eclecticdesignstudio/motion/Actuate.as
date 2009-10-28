package com.eclecticdesignstudio.motion {
	
	
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class Actuate {
		
		
		public static var defaultActuator:Class = SimpleActuator;
		private static var targetLibraries:Dictionary = new Dictionary (true);
		
		
		/**
		 * Copies properties from one object to another. Conflicting tweens are stopped automatically
		 * @example		<code>Actuate.apply (MyClip, { alpha: 1 } );</code>
		 * @param	target		The object to copy to
		 * @param	properties		The object to copy from
		 * @param	customActuator		A custom actuator to use instead of the default (Optional)
		 */
		public static function apply (target:Object, properties:Object, customActuator:Class = null):void {
			
			stop (target, properties);
			
			var actuateClass:Class = customActuator || defaultActuator;
			var actuator:GenericActuator = new actuateClass (target, 0, properties, null);
			
			actuator.apply ();
			
		}
		
		
		private static function getInitProperties (target:Object, properties:Object, duration:Number, tweenProperties:Object):Object {
			
			var library:Dictionary = getLibrary (target);
			var initProperties:Object;
			var startTime:Number = duration;
			
			if (tweenProperties && "delay" in tweenProperties) {
				
				startTime += tweenProperties.delay;
				
			}
			
			for (var propertyName:String in properties) {
				
				var lastMatch:Object;
				var lastMatchEndTime:Number = 0;
				
				for each (var actuator:GenericActuator in library) {
					
					if (propertyName in actuator.properties) {
						
						var endTime:Number = actuator.duration;
						
						if (actuator.tweenProperties && "delay" in actuator.tweenProperties) {
							
							endTime += actuator.tweenProperties.delay;
							
						}
						
						if (endTime >= lastMatchEndTime && endTime <= startTime) {
							
							lastMatch = actuator.properties[propertyName];
							lastMatchEndTime = endTime;
							
						}
						
					}
					
				}
				
				if (lastMatch != null) {
					
					if (initProperties == null) {
						
						initProperties = new Object ();
						
					}
					
					initProperties[propertyName] = lastMatch;
					
				}
				
			}
			
			return initProperties;
			
		}
		
		
		private static function getLibrary (target:Object):Dictionary {
			
			if (!targetLibraries[target]) {
				
				targetLibraries[target] = new Dictionary (true);
				
			}
			
			return targetLibraries[target];
			
		}
		
		
		/**
		 * Pauses tweens for the specified target objects
		 * @param	... targets		The target objects which will have their tweens paused. Passing no value pauses tweens for all objects
		 */
		public static function pause (... targets:Array):void {
			
			var actuator:GenericActuator;
			var library:Dictionary;
			
			if (targets.length > 0) {
				
				for each (var target:Object in targets) {
					
					library = getLibrary (target);
					
					for each (actuator in library) {
						
						actuator.pause ();
						
					}
					
				}
				
			} else {
				
				for each (library in targetLibraries) {
					
					for each (actuator in library) {
						
						actuator.pause ();
						
					}
					
				}
				
			}
			
		}
		
		
		private static function register (actuator:GenericActuator, overwrite:Boolean = true):void {
			
			var library:Dictionary = getLibrary (actuator.target);
			
			if (overwrite) {
				
				for each (var childActuator:GenericActuator in library) {
					
					childActuator.stop (actuator.properties, false);
					
				}
				
			}
			
			actuator.addEventListener (Event.UNLOAD, Actuator_onUnload);
			library[actuator] = actuator;
			
		}
		
		
		/**
		 * Resets Actuate by stopping and removing tweens for all objects
		 */
		public static function reset ():void {
			
			var actuator:GenericActuator;
			var library:Dictionary;
			
			for each (library in targetLibraries) {
				
				for each (actuator in library) {
					
					actuator.stop (null, false);
					
				}
				
			}
			
			targetLibraries = new Dictionary (true);
			
		}
		
		
		/**
		 * Resumes paused tweens for the specified target objects
		 * @param	... targets		The target objects which will have their tweens resumed. Passing no value resumes tweens for all objects
		 */
		public static function resume (... targets:Array):void {
			
			var actuator:GenericActuator;
			var library:Dictionary;
			
			if (targets.length > 0) {
				
				for each (var target:Object in targets) {
					
					library = getLibrary (target);
					
					for each (actuator in library) {
						
						actuator.resume ();
						
					}
					
				}
				
			} else {
				
				for each (library in targetLibraries) {
					
					for each (actuator in library) {
						
						actuator.resume ();
						
					}
					
				}
				
			}
			
		}
		
		
		/**
		 * Stops all tweens for an individual object
		 * @param	target		The target object which will have its tweens stopped
		 * @param  properties		An array or an object which contains the properties you wish to stop, like [ "alpha" ] or { alpha: null }. Passing no value removes all tweens for the object (Optional)
		 */
		public static function stop (target:Object, properties:Object = null):void {
			
			if (target) {
				
				var actuator:GenericActuator;
				var library:Dictionary = getLibrary (target);
				
				if (properties is Array) {
					
					var newProperties:Object = new Object ();
					
					for each (var propertyName:String in properties) {
						
						newProperties[propertyName] = null;
						
					}
					
					properties = newProperties;
					
				}
				
				for each (actuator in library) {
					
					actuator.stop (properties, true);
					
				}
				
			}
			
		}
		
		
		/**
		 * Creates a tween-based timer, which is useful for synchronizing function calls with other animations
		 * @example		<code>Actuate.timer (1, { onComplete: trace, onCompleteParams: [ "Timer is now complete" ] } );</code>
		 * @param	duration		The length of the timer in seconds
		 * @param	tweenProperties		Tween specific properties such as delay, onChange, onChangeParams, onComplete, onCompleteParams, changeListener or completeListener (Optional)
		 * @param	customActuator		A custom actuator to use instead of the default (Optional)
		 * @return		The generated target object, which you can use if you need to pause or resume your timer
		 */
		public static function timer (duration:Number, tweenProperties:Object, customActuator:Class = null):Object {
			
			var target:Object = { progress: 0 };
			var properties:Object = { progress: 1 };
			
			tween (target, duration, properties, tweenProperties, customActuator);
			
			return target;
			
		}
		
		
		/**
		 * Creates a new tween
		 * @example		<code>Actuate.tween (MyClip, 1, { alpha: 1 }, { onComplete: trace, onCompleteParams: [ "MyClip is now visible" ] }, SimpleActuator);</code>
		 * @param	target		The object to tween
		 * @param	duration		The length of the tween in seconds
		 * @param	properties		The end values to tween the target to
		 * @param	tweenProperties		Tween specific properties such as autoVisible, completeListener, delay, onComplete, onCompleteParams or snapping (Optional)
		 * @param	customActuator		A custom actuator to use instead of the default (Optional)
		 */
		public static function tween (target:Object, duration:Number, properties:Object, tweenProperties:Object = null, customActuator:Class = null):void {
			
			if (target) {
				
				if (duration > 0) {
					
					var actuateClass:Class = customActuator || defaultActuator;
					var actuator:GenericActuator = new actuateClass (target, duration, properties, tweenProperties);
					
					if (tweenProperties && "overwrite" in tweenProperties) {
						
						if (actuateClass.needsInitProperties) {
							
							actuator.initProperties = getInitProperties (target, properties, duration, tweenProperties);
							
						}
						
						register (actuator, false);
						
					} else {
						
						register (actuator);
						
					}
					
					actuator.move ();
					
				} else {
					
					apply (target, properties, customActuator);
					
				}
				
			}
			
		}
		
		
		
		
		// Event Handlers
		
		
		
		
		private static function Actuator_onUnload (event:Event):void {
			
			var actuator:GenericActuator = event.currentTarget as GenericActuator;
			var library:Dictionary = getLibrary (actuator.target);
			delete library[actuator];
			
		}
		
		
	}
	
	
}