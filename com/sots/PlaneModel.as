package com.sots {
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PlaneModel {
		
		private var _planeID:int;
		private var _radius:Number;
		private var _texture:Texture;
		private var _centerX:Number;
		private var _centerY:Number;
		
		public function PlaneModel(radius:Number, texture:Texture) {
			_radius = radius;
			_texture = texture;
		}
		
		public function get radius():Number {
			return _radius;
		}
		
		public function get texture():Texture {
			return _texture;
		}
		
		public function get centerX():Number {
			return _centerX;
		}
		
		public function set centerX(value:Number):void {
			_centerX = value;
		}
		
		public function get centerY():Number {
			return _centerY;
		}
		
		public function set centerY(value:Number):void {
			_centerY = value;
		}
		
		public function get planeID():int {
			return _planeID;
		}
		
		public function set planeID(value:int):void {
			_planeID = value;
		}
		
	}

}