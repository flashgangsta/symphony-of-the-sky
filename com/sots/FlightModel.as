package com.sots {
	import flash.geom.Point;
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class FlightModel {
		
		static private const MAX_SIZE:int = 60;
		
		private var data:XML;
		private var _fromPoint:Point;
		private var _toPoint:Point;
		private var _distance:Number;
		private var _rotation:Number;
		private var _scale:Number;
		
		public function FlightModel(data:XML, fromPoint:Point, toPoint:Point) {
			this.data = data;
			_toPoint = toPoint;
			_fromPoint = fromPoint;
			_distance = Point.distance(fromPoint, toPoint);
			_rotation = (Math.atan2(toPoint.y - fromPoint.y, toPoint.x - fromPoint.x));
			_scale = Number(data.@size) / MAX_SIZE;
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
		
	}

}