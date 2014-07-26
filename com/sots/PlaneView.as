package com.sots {
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class PlaneView extends Sprite {
		private var model:PlaneModel;
		
		public function PlaneView(model:PlaneModel) {
			this.model = model;
			const image:Image = new Image(model.texture);
			image.x = -Math.round(image.width / 2);
			image.y = -Math.round(image.height / 2);
			addChild(image);
			touchable = false;
		}
		
		public function getModel():PlaneModel {
			return model;
		}
		
	}

}