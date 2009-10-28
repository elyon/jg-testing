package com.eclecticdesignstudio.motion {
	
	
	import com.eclecticdesignstudio.motion.easing.Expo;
	import com.eclecticdesignstudio.motion.easing.IEasing;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class TweenProperties {
		
		
		public var autoRotation:Boolean = false;
		public var autoVisible:Boolean = true;
		public var changeListener:Function = null;
		public var completeListener:Function = null;
		public var delay:Number = 0;
		public var ease:IEasing = Expo.easeOut;
		public var reflect:Boolean = false;
		public var repeat:Boolean = false;
		public var onChange:Function = null;
		public var onChangeParams:Array = new Array ();
		public var onComplete:Function = null;
		public var onCompleteParams:Array = new Array ();
		public var overwrite:Boolean = true;
		public var snapping:Boolean = false;
		
		
		public function TweenProperties (ease:Boolean = Expo.easeOut, delay:Number = 0, onComplete:Function = null, onCompleteParams:Array = new Array (), overwrite:Boolean = false) {
			
			this.ease = ease;
			this.delay = delay;
			this.onComplete = onComplete;
			this.onCompleteParams = onCompleteParams;
			this.overwrite = overwrite;
			
		}
		
		
	}
	

}