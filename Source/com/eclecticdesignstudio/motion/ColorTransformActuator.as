package com.eclecticdesignstudio.motion {
	
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	
	/**
	 * @author Joshua Granick
	 * @version 1.0
	 */
	public class ColorTransformActuator extends SimpleActuator {
		
		
		public var blueOffset:Number;
		public var greenOffset:Number;
		public var redOffset:Number;
		
		private var colorTransform:ColorTransform;
		private var tweenTarget:DisplayObject;
		
		
		public function ColorTransformActuator (target:Object, duration:Number, properties:Object, tweenProperties:Object) {
			
			super (target, duration, properties, tweenProperties);
			
			colorTransform = new ColorTransform ();
			tweenTarget = target as DisplayObject;
			this.target = this;
			
		}
		
		
		public override function apply ():void {
			
			if ("color" in properties) {
				
				colorTransform.color = properties.color;
				tweenTarget.transform.colorTransform = colorTransform;
				
			}
			
		}
		
		
		public override function move ():void {
			
			super.move ();
			
			if ("color" in properties) { 
				
				colorTransform = tweenTarget.transform.colorTransform;
				
				redOffset = colorTransform.redOffset;
				greenOffset = colorTransform.greenOffset;
				blueOffset = colorTransform.blueOffset;
				
				colorTransform.color = properties.color;
				
				delete properties.color;
				
				properties.redOffset = colorTransform.redOffset;
				properties.greenOffset = colorTransform.greenOffset;
				properties.blueOffset = colorTransform.blueOffset;
				
			}
			
		}
		
		
		public override function update (elapsedTime:Number):void {
			
			super.update (elapsedTime);
			
			colorTransform.redOffset = redOffset;
			colorTransform.greenOffset = greenOffset;
			colorTransform.blueOffset = blueOffset;
			tweenTarget.transform.colorTransform = colorTransform;
			
		}
		
		
	}
	

}