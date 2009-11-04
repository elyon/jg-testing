package com.eclecticdesignstudio.motion {
	
	
	import com.eclecticdesignstudio.motion.actuators.ColorTransformActuator;
	import com.eclecticdesignstudio.motion.actuators.FilterActuator;
	import com.eclecticdesignstudio.motion.actuators.GenericActuator;
	import com.eclecticdesignstudio.motion.actuators.MotionInternal;
	import com.eclecticdesignstudio.motion.actuators.MotionPathActuator;
	import com.eclecticdesignstudio.motion.actuators.SimpleActuator;
	import com.eclecticdesignstudio.motion.easing.Expo;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	
	use namespace MotionInternal;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class Actuate {
		
		
		public static var defaultActuator:Class = SimpleActuator;
		public static var defaultEase:IEasing = Expo.easeOut;
		private static var targetLibraries:Dictionary = new Dictionary (true);
		
		
		/**
		 * Copies properties from one object to another. Conflicting tweens are stopped automatically
		 * @example		<code>Actuate.apply (MyClip, { alpha: 1 } );</code>
		 * @param	target		The object to copy to
		 * @param	properties		The object to copy from
		 * @param	customActuator		A custom actuator to use instead of the default (Optional)
		 * @return		The current actuator instance, which can be used to apply properties like onComplete or onChange handlers
		 */
		public static function apply (target:Object, properties:Object, customActuator:Class = null):GenericActuator {
			
			stop (target, properties);
			
			var actuateClass:Class = customActuator || defaultActuator;
			var actuator:GenericActuator = new actuateClass (target, 0, properties);
			
			actuator.MotionInternal::apply ();
			
			return actuator;
			
		}
		
		
		/**
		 * Creates a new BitmapFilter tween 
		 * @param	target		The object to tween
		 * @param	duration		The length of the tween in seconds
		 * @param	properties		The end values to tween the filter to
		 * @param	index		The index of the filter within the target's filter array (Default is 0)
		 * @param	overwrite		Sets whether previous tweens for the same target will be overwritten (Default is true)
		 * @return		The current actuator instance, which can be used to apply properties like ease, delay, onComplete or onChange
		 */
		public static function filter (target:Object, duration:Number, properties:Object, index:uint = 0, overwrite:Boolean = true):GenericActuator {
			
			properties.index = index;
			return tween (target, duration, properties, overwrite, FilterActuator);
			
		}
		
		
		private static function getLibrary (target:Object):Dictionary {
			
			if (!targetLibraries[target]) {
				
				targetLibraries[target] = new Dictionary (true);
				
			}
			
			return targetLibraries[target];
			
		}
		
		
		/**
		 * Creates a new MotionPath tween
		 * @param	target		The object to tween
		 * @param	duration		The length of the tween in seconds
		 * @param	properties		An object containing a motion path for each property you wish to tween
		 * @param	overwrite		Sets whether previous tweens for the same target and properties will be overwritten (Default is true)
		 * @return		The current actuator instance, which can be used to apply properties like ease, delay, onComplete or onChange
		 */
		public static function path (target:Object, duration:Number, properties:Object, overwrite:Boolean = true):GenericActuator {
			
			return tween (target, duration, properties, overwrite, MotionPathActuator);
			
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
						
						actuator.MotionInternal::pause ();
						
					}
					
				}
				
			} else {
				
				for each (library in targetLibraries) {
					
					for each (actuator in library) {
						
						actuator.MotionInternal::pause ();
						
					}
					
				}
				
			}
			
		}
		
		
		/**
		 * Resets Actuate by stopping and removing tweens for all objects
		 */
		public static function reset ():void {
			
			var actuator:GenericActuator;
			var library:Dictionary;
			
			for each (library in targetLibraries) {
				
				for each (actuator in library) {
					
					actuator.MotionInternal::stop (null, false);
					
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
						
						actuator.MotionInternal::resume ();
						
					}
					
				}
				
			} else {
				
				for each (library in targetLibraries) {
					
					for each (actuator in library) {
						
						actuator.MotionInternal::resume ();
						
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
					
					actuator.MotionInternal::stop (properties, true);
					
				}
				
			}
			
		}
		
		
		/**
		 * Creates a tween-based timer, which is useful for synchronizing function calls with other animations
		 * @example		<code>Actuate.timer (1).onComplete (trace).onCompleteParams ("Timer is now complete");</code>
		 * @param	duration		The length of the timer in seconds
		 * @param	customActuator		A custom actuator to use instead of the default (Optional)
		 * @return		The current actuator instance, which can be used to apply properties like onComplete or to gain a reference to the target timer object
		 */
		public static function timer (duration:Number, customActuator:Class = null):GenericActuator {
			
			return tween (new TweenTimer (0), duration, new TweenTimer (1), false, customActuator);
			
		}
		
		
		/**
		 * Creates a new ColorTransform tween
		 * @param	target		The object to tween
		 * @param	duration		The length of the tween in seconds
		 * @param	color		The color to tint the target to (Default is 0x000000)
		 * @param	amount		The degree of tinting that should be applied to the target (Default is 1)
		 * @param	alpha		The end alpha value to tween the target to. This property is necessary to be able to tween the alpha and the tint of your target simultaneously (Default is 1) 
		 * @param	overwrite		Sets whether previous tweens for the same target will be overwritten (Default is true)
		 * @return		The current actuator instance, which can be used to apply properties like ease, delay, onComplete or onChange
		 */
		public static function tint (target:Object, duration:Number, color:Number = 0x000000, amount:Number = 1, alpha:Number = 1, overwrite:Boolean = true):GenericActuator {
			
			return tween (target, duration, { color: color, amount: amount, alpha: alpha }, overwrite, ColorTransformActuator);
			
		}
		
		
		/**
		 * Creates a new tween
		 * @example		<code>Actuate.tween (MyClip, 1, { alpha: 1 } ).delay (1).onComplete (trace).onCompleteParams ("MyClip is now visible");</code>
		 * @param	target		The object to tween
		 * @param	duration		The length of the tween in seconds
		 * @param	properties		The end values to tween the target to
		 * @param	overwrite			Sets whether previous tweens for the same target and properties will be overwritten (Default is true)
		 * @param	customActuator		A custom actuator to use instead of the default (Optional)
		 * @return		The current actuator instance, which can be used to apply properties like ease, delay, onComplete or onChange
		 */ 
		public static function tween (target:Object, duration:Number, properties:Object, overwrite:Boolean = true, customActuator:Class = null):GenericActuator {
			
			if (target) {
				
				if (duration > 0) {
					
					var actuateClass:Class = customActuator || defaultActuator;
					var actuator:GenericActuator = new actuateClass (target, duration, properties);
					
					var library:Dictionary = getLibrary (actuator.target);
					
					if (overwrite) {
						
						for each (var childActuator:GenericActuator in library) {
							
							childActuator.MotionInternal::stop (actuator.properties, false);
							
						}
						
					}
					
					library[actuator] = actuator;
					actuator.MotionInternal::move ();
					
					return actuator;
					
				} else {
					
					return apply (target, properties, customActuator);
					
				}
				
			}
			
			return null;
			
		}
		
		
		MotionInternal static function unload (actuator:GenericActuator):void {
			
			var library:Dictionary = getLibrary (actuator.target);
			delete library[actuator];
			
		}
		
		
	}
	
	
}




class TweenTimer {
	
	
	public var progress:Number;
	
	
	public function TweenTimer (progress:Number):void {
		
		this.progress = progress;
		
	}
	
	
}