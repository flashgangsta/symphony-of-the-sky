package com.sots {
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PlaneView extends Sprite {
		
		public function PlaneView(texture:Texture) {
			const image:Image = new Image(texture);
			image.x = -Math.round(image.width / 2);
			image.y = -Math.round(image.height / 2);
			addChild(image);
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			
		}
		
	}

}