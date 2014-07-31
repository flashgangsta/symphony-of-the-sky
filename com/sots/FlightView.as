package com.sots {
	import caurina.transitions.Tweener;
	import com.sots.events.FlightEvent;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class FlightView extends Sprite {
		private const SPEED_MIN:Number = 700;
		private const SPEED_MAX:Number = 800;
		private var model:FlightModel;
		private var planeModel:PlaneModel;
		private var _inFly:Boolean = false;
		
		public function FlightView(model:FlightModel) {
			this.model = model;
			planeModel = new PlaneModel(model.planeRadius, model.planeTexture, model.sizeType);
			touchable = false;
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			super.dispose();
		}
		
		/**
		 * 
		 */
		
		public function get planeScale():Number {
			return model.scale;
		}
		
		public function get inFly():Boolean {
			return _inFly;
		}
		
		/**
		 * 
		 */
		
		public function startFly(distancePrecent:Number = 1):void {
			_inFly = true;
			
			const plane:PlaneView = new PlaneView(planeModel);
			const planeTable:PlaneTableView = new PlaneTableView(model.fromCity, model.toCity, model.number);
			const distance:Number = model.distance * distancePrecent;
			const fromPointX:Number = model.toPoint.x + ((model.fromPoint.x - model.toPoint.x) * distancePrecent);
			const fromPointY:Number = model.toPoint.y + ((model.fromPoint.y - model.toPoint.y) * distancePrecent);
			const speedInKmH:Number = SPEED_MIN + (Math.random() * (SPEED_MAX - SPEED_MIN));
			const speedInPxH:Number = speedInKmH * MapView.PX_IN_KM;
			const motionParams:Object = {
				x: model.toPoint.x,
				y: model.toPoint.y,
				time: (distance / speedInPxH) * MapView.SEC_IN_H,
				transition: "linear",
				onComplete: function():void {
					onPlaneArrival(plane);
				}
			}
			
			plane.addTable(planeTable);
			planeTable.x = Math.round( -planeTable.width / 2);
			planeTable.y = -(model.planeRadius + planeTable.height);
			
			plane.x = fromPointX;
			plane.y = fromPointY;
			
			dispatchEvent(new FlightEvent(FlightEvent.PLANE_READY_TO_FLY, false, plane));
			
			Tweener.addTween(plane, motionParams);
			
			if (Application.IS_FLIGHTS_ANOUNSING_NEED) {
				trace("Flight:", '"model.number"', "from", model.fromCity, "to", model.toCity, "in fly.");
			}
		}
		
		public function getModel():FlightModel {
			return model;
		}
		
		/**
		 * 
		 */
		
		private function onPlaneArrival(plane:PlaneView):void {
			_inFly = false;
			if (Application.IS_FLIGHTS_ANOUNSING_NEED) { 
				trace("Flight:", '"' + model.number + '"', "from", model.fromCity, "to", model.toCity, "arrived");
			}
			var arriveMotion:Object = {
				scaleX: 0,
				scaleY: 0,
				time: .5,
				delay: .25,
				transition: "easeInCubic",
				onComplete: function():void {
					plane.parent.removeChild(plane);
					plane.dispose();
					plane = null;
				}
			}
			
			Tweener.addTween(plane, arriveMotion);
			
			dispatchEvent(new FlightEvent(FlightEvent.PLANE_ARRIVED));
		}
		
	}

}