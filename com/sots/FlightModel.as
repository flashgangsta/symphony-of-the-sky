package com.sots {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class FlightModel {
		
		private const MAX_PLANE_SIZE:int = 60;
		private const PLANE_SHADOW:DropShadowFilter = new DropShadowFilter(11, 45, 0, 1, 13, 13, .47, BitmapFilterQuality.HIGH);
		
		private var data:XML;
		private var _fromPoint:Point;
		private var _toPoint:Point;
		private var _distance:Number;
		private var _rotation:Number;
		private var _scale:Number;
		private var _planeTexture:Texture;
		private var _planeRadius:Number;
		
		public function FlightModel(planeBMD:BitmapData, data:XML, fromPoint:Point, toPoint:Point) {
			this.data = data;
			
			_distance = Point.distance(fromPoint, toPoint);
			_rotation = (Math.atan2(toPoint.y - fromPoint.y, toPoint.x - fromPoint.x));
			_scale = Number(data.@size) / MAX_PLANE_SIZE;
			
			//DrawPlane
			var planeBitmap:Bitmap = new Bitmap(planeBMD, PixelSnapping.NEVER);
			var planeContainer:flash.display.Sprite = new flash.display.Sprite();
			var shadowMargin:int = Math.max(PLANE_SHADOW.blurX, PLANE_SHADOW.blurY, PLANE_SHADOW.distance);
			var matrix:Matrix = new Matrix();
			var planeBounds:Rectangle;
			var planeWithShadowBMD:BitmapData;
			
			planeBitmap.scaleX = planeBitmap.scaleY = _scale;
			planeBitmap.rotation = _rotation * (180 / Math.PI);
			planeBitmap.filters = [PLANE_SHADOW];
			planeBitmap.smoothing = true;
			planeContainer.addChild(planeBitmap);
			
			_planeRadius = Math.min(planeContainer.width, planeContainer.height) / 2;
			
			planeBounds = planeContainer.getBounds(planeContainer);
			planeBounds.x = Math.floor(planeBounds.x);
			planeBounds.y = Math.floor(planeBounds.y);
			planeBounds.width = Math.ceil(planeBounds.width + shadowMargin * 2);
			planeBounds.height = Math.ceil(planeBounds.height + shadowMargin * 2);
			
			matrix.identity();
			matrix.translate(Math.ceil(-planeBounds.x + shadowMargin), Math.ceil( -planeBounds.y + shadowMargin));
			
			planeWithShadowBMD = new BitmapData(planeBounds.width, planeBounds.height, true, 0x00000000);
			planeWithShadowBMD.lock();
			planeWithShadowBMD.draw(planeContainer, matrix);
			planeWithShadowBMD.unlock();
			
			_planeTexture = Texture.fromBitmapData(planeWithShadowBMD);
			
			// remove ways outside visible map
			
			_toPoint = toPoint;
			_fromPoint = fromPoint;
			
			const enabledLocationsRect:Rectangle = new Rectangle();
			enabledLocationsRect.x = -planeWithShadowBMD.width;
			enabledLocationsRect.y = -planeWithShadowBMD.height;
			enabledLocationsRect.width = Application.MAX_TEXTURE_SIZE + planeWithShadowBMD.width;
			enabledLocationsRect.height = Application.MAX_TEXTURE_SIZE + planeWithShadowBMD.height;
			
			//to x_left
			/*if (_toPoint.x < enabledLocationsRect.x) {
				_toPoint.x = enabledLocationsRect.x;
			}
			
			//to x_right
			if (_toPoint.x > enabledLocationsRect.width) {
				_toPoint.x = enabledLocationsRect.width;
			}
			
			
			//form x_left
			if (_fromPoint.x < enabledLocationsRect.x) {
				_fromPoint.x = enabledLocationsRect.x;
			}
			
			//from x_right
			if (_fromPoint.x > enabledLocationsRect.width) {
				_fromPoint.x = enabledLocationsRect.width;
			}
			
			//to y_top
			if (_toPoint.y < enabledLocationsRect.y) {
				_toPoint.y = enabledLocationsRect.y;
			}
			
			//from y_yop
			if (_fromPoint.y < enabledLocationsRect.y) {
				_fromPoint.y = enabledLocationsRect.y;
			}
			
			//to y_bottom
			if (_toPoint.y > enabledLocationsRect.height) {
				_toPoint.y = enabledLocationsRect.height;
			}
			
			//from y_bottom
			if (_fromPoint.y > enabledLocationsRect.height) {
				_fromPoint.y = enabledLocationsRect.height;
			}
			
			//calculate after outside ways removed
			_distance = Point.distance(fromPoint, toPoint);*/
			
			//remove garbage
			planeWithShadowBMD.dispose();
			planeWithShadowBMD = null;
			
			planeBitmap.filters = [];
			planeBitmap = null;
			
			planeBounds = null;
			
			planeContainer.removeChildren();
			planeContainer = null;
			
			matrix = null;
		}
		
		public function get fromCity():String {
			return data.@from;
		}
		
		public function get toCity():String {
			return data.@to;
		}
		
		public function get type():String {
			return data.@type;
		}
		
		public function get size():String {
			return data.@size;
		}
		
		public function get number():String {
			return data.@number;
		}
		
		public function get fromPoint():Point {
			return _fromPoint;
		}
		
		public function get toPoint():Point {
			return _toPoint;
		}
		
		public function get distance():Number {
			return _distance;
		}
		
		public function get speed():Number {
			return 20;
		}
		
		public function get rotation():Number {
			return _rotation;
		}
		
		public function get scale():Number {
			return _scale;
		}
		
		public function get planeRadius():Number {
			return _planeRadius;
		}
		
		public function get planeTexture():Texture {
			return _planeTexture;
		}
		
	}

}