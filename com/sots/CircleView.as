package com.sots {
	import flash.utils.Dictionary;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CircleView extends Sprite {
		
		private var planesHistory:Dictionary = new Dictionary();
		
		public function CircleView(texture:Texture) {
			touchable = false;
			
			const image:Image = new Image(texture);
			image.touchable = false;
			image.x = image.y = -(image.width / 2);
			addChild(image);
		}
		
		override public function dispose():void {
			removeChildren();
			for (var planeID:String in planesHistory) {
				delete planesHistory[int(planeID)];
			}
			planesHistory = null;
			super.dispose();
		}
		
		public function addCollisionHistory(planeID:int):void {
			planesHistory[planeID] = true;
		}
		
		public function isPlaneExistsInHistory(planeID:int):Boolean {
			return planesHistory[planeID];
		}
		
		
		
	}

}