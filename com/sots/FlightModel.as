package com.sots {
	import com.flashgangsta.utils.MathUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class FlightModel {
		
		private const PLANE_SHADOW:DropShadowFilter = new DropShadowFilter(11, 45, 0, 1, 13, 13, .47, BitmapFilterQuality.HIGH);
		
		private var data:XML;
		private var _fromPoint:Point;
		private var _toPoint:Point;
		private var _distance:Number;
		private var _rotation:Number;
		private var _scale:Number;
		private var _planeTexture:Texture;
		private var _planeRadius:Number;
		private var _planesSizeBySizeType:Dictionary = new Dictionary();
		
		public function FlightModel(planeBMD:BitmapData, data:XML, fromPoint:Point, toPoint:Point) {
			this.data = data;
			
			_planesSizeBySizeType.small = 33;
			_planesSizeBySizeType.middle = 37;
			_planesSizeBySizeType.big = 60;
			_distance = Point.distance(fromPoint, toPoint);
			_rotation = (Math.atan2(toPoint.y - fromPoint.y, toPoint.x - fromPoint.x));
			_scale = _planesSizeBySizeType[sizeType] / _planesSizeBySizeType.big;
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
			const planeWidth:Number = planeWithShadowBMD.width / 2;
			const planeHeight:Number = planeWithShadowBMD.height / 2;
			enabledLocationsRect.x = -planeWidth;
			enabledLocationsRect.y = -planeHeight;
			enabledLocationsRect.width = Application.MAX_TEXTURE_SIZE + planeWidth;
			enabledLocationsRect.height = Application.MAX_TEXTURE_SIZE + planeHeight;
			
			var fromX:Number = _fromPoint.x;
			var fromY:Number = _fromPoint.y;
			var toX:Number = _toPoint.x;
			var toY:Number = _toPoint.y;
			var x:Number;
			var y:Number;
			
			if (_fromPoint.x < enabledLocationsRect.x || _fromPoint.y < enabledLocationsRect.y) {
				x = enabledLocationsRect.x - _fromPoint.x;
				y = enabledLocationsRect.y - _fromPoint.y;
				
				if (x > y) {
					fromX = enabledLocationsRect.x;
					fromY = MathUtil.pointCoordinate(_fromPoint.x, _toPoint.x, fromX, _fromPoint.y, _toPoint.y, NaN);
				} else {
					fromY = enabledLocationsRect.y;
					fromX = MathUtil.pointCoordinate(_fromPoint.x, _toPoint.x, NaN, _fromPoint.y, _toPoint.y, fromY);
				}
				_fromPoint = new Point(fromX, fromY);
			}
			
			if (_fromPoint.x > enabledLocationsRect.width || _fromPoint.y > enabledLocationsRect.height) {
				x = _fromPoint.x - enabledLocationsRect.width;
				y = _fromPoint.y - enabledLocationsRect.height;
				
				if (x > y) {
					fromX = enabledLocationsRect.width;
					fromY = MathUtil.pointCoordinate(_fromPoint.x, _toPoint.x, fromX, _fromPoint.y, _toPoint.y, NaN);
				} else {
					fromY = enabledLocationsRect.height;
					fromX = MathUtil.pointCoordinate(_fromPoint.x, _toPoint.x, NaN, _fromPoint.y, _toPoint.y, fromY);
				}
				_fromPoint = new Point(fromX, fromY);
			}
			
			if (_toPoint.x < enabledLocationsRect.x || _toPoint.y < enabledLocationsRect.y) {
				x = enabledLocationsRect.x - _toPoint.x;
				y = enabledLocationsRect.y - _toPoint.y;
				
				if (x > y) {
					toX = enabledLocationsRect.x;
					toY = MathUtil.pointCoordinate(_fromPoint.x, _toPoint.x, toX, _fromPoint.y, _toPoint.y, NaN);
				} else {
					toY = enabledLocationsRect.y;
					toX = MathUtil.pointCoordinate(_fromPoint.x, _toPoint.x, NaN, _fromPoint.y, _toPoint.y, toY);
				}
				_toPoint = new Point(toX, toY);
			}
			
			if (_toPoint.x > enabledLocationsRect.width || _toPoint.y > enabledLocationsRect.height) {
				x = _toPoint.x - enabledLocationsRect.width;
				y = _toPoint.y - enabledLocationsRect.height;
				
				if (x > y) {
					toX = enabledLocationsRect.width;
					toY = MathUtil.pointCoordinate(_fromPoint.x, _toPoint.x, toX, _fromPoint.y, _toPoint.y, NaN);
				} else {
					toY = enabledLocationsRect.height;
					toX = MathUtil.pointCoordinate(_fromPoint.x, _toPoint.x, NaN, _fromPoint.y, _toPoint.y, toY);
				}
				_toPoint = new Point(toX, toY);
			}
			
			_toPoint = new Point(toX, toY);
			
			//calculate after outside ways removed
			_distance = Point.distance(_fromPoint, _toPoint);
			
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
		
		public function get sizeType():String {
			return String(data.@size).toLowerCase();
		}
		
	}

}