package com.eclecticdesignstudio.motion {
	
	
	import com.eclecticdesignstudio.motion.easing.Expo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class GenericActuator extends EventDispatcher {
		
		
		public var duration:Number;
		public var initProperties:Object;
		public var properties:Object;
		public var target:Object;
		public var tweenProperties:Object;
		
		
		public function GenericActuator (target:Object, duration:Number, properties:Object, tweenProperties:Object) {
			
			this.target = target;
			this.properties = properties;
			this.duration = duration;
			this.tweenProperties = tweenProperties;
			
			if (tweenProperties) {
				
				if ("changeListener" in tweenProperties) { addEventListener (Event.CHANGE, tweenProperties.changeListener); }
				if ("completeListener" in tweenProperties) { addEventListener (Event.COMPLETE, tweenProperties.completeListener); }
				
			}
			
		}
		
		
		public function apply ():void {
			
			for (var propertyName:String in properties) {
				
				target[propertyName] = properties[propertyName];
				
			}
			
		}
		
		
		protected function change ():void {
			
			dispatchEvent (new Event (Event.CHANGE));
			
			if (tweenProperties && "onChange" in tweenProperties) {
				
				if ("onChangeParams" in tweenProperties) {
					
					tweenProperties.onChange.apply (null, tweenProperties.onCompleteParams);
					
				} else {
					
					tweenProperties.onChange ();
					
				}
				
			}
			
		}
		
		
		protected function complete (sendEvent:Boolean = true):void {
			
			if (sendEvent) {
				
				dispatchEvent (new Event (Event.COMPLETE));
				
				if (tweenProperties && "onComplete" in tweenProperties) {
					
					if ("onCompleteParams" in tweenProperties) {
						
						tweenProperties.onComplete.apply (null, tweenProperties.onCompleteParams);
						
					} else {
						
						tweenProperties.onComplete ();
						
					}
					
				}
				
			}
			
			dispatchEvent (new Event (Event.UNLOAD));
			
		}
		
		
		public function move ():void {
			
			
			
		}
		
		
		public function pause ():void {
			
			
			
		}
		
		
		public function resume ():void {
			
			
			
		}
		
		
		public function stop (properties:Object, sendEvent:Boolean):void {
			
			
			
		}
		
		
	}
	
	
}