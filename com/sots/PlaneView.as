package com.sots {
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class PlaneView extends Sprite {
		private var model:PlaneModel;
		private var _id:Number;
		private var table:PlaneTableView;
		
		public function PlaneView(model:PlaneModel) {
			_id = Application.nextPlaneID++;
			this.model = model;
			const image:Image = new Image(model.texture);
			image.touchable = false;
			image.x = -Math.round(image.width / 2);
			image.y = -Math.round(image.height / 2);
			addChild(image);
			touchable = false;
		}
		
		public function addTable(table:PlaneTableView):void {
			this.table = table;
			addChild(table);
		}
		
		public function getModel():PlaneModel {
			return model;
		}
		
		public function get id():Number {
			return _id;
		}
		
		override public function dispose():void {
			removeChild(table);
			table.dispose();
			model = null;
			table = null;
			super.dispose();
		}
		
		public function playCollision():void {
			table.playCollision();
		}
		
		public function stopCollision():void {
			table.stopCollision();
		}
		
	}

}