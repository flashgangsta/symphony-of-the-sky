package com.sots {
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CircleView extends Sprite {
		
		public function CircleView(texture:Texture) {
			touchable = false;
			
			const image:Image = new Image(texture);
			image.touchable = false;
			image.x = image.y = -(image.width / 2);
			trace(image.x, image.y);
			addChild(image);
		}
		
		
		
	}

}