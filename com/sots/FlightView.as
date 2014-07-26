package com.sots {
	import caurina.transitions.Tweener;
	import com.sots.events.FlightEvent;
	import flash.utils.setTimeout;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class FlightView extends Sprite {
		private const MIN_FLIGHT_DELAY:Number = 10000;
		private const MAX_FLIGHT_DELAY:Number = 40000;
		private var model:FlightModel;
		private var planeModel:PlaneModel;
		
		public function FlightView(model:FlightModel) {
			this.model = model;
			planeModel = new PlaneModel(model.planeRadius, model.planeTexture);
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
		
		public function startFlying():void {
			startFly(numChildren ? 1 : Math.random());
		}
		
		/**
		 * 
		 */
		
		public function get planeScale():Number {
			return model.scale;
		}
		
		/**
		 * 
		 */
		
		private function startFly(distancePrecent:Number = 1):void {
			const plane:PlaneView = new PlaneView(planeModel);
			const distance:Number = model.distance * distancePrecent;
			const fromPointX:Number = model.toPoint.x + ((model.fromPoint.x - model.toPoint.x) * distancePrecent);
			const fromPointY:Number = model.toPoint.y + ((model.fromPoint.y - model.toPoint.y) * distancePrecent);
			const motionParams:Object = {
				x: model.toPoint.x,
				y: model.toPoint.y,
				time: distance / model.speed,
				transition: "linear",
				onComplete: function():void {
					onPlaneArrival(plane);
				}
			}
			
			plane.x = fromPointX;
			plane.y = fromPointY;
			
			dispatchEvent(new FlightEvent(FlightEvent.PLANE_READY_TO_FLY, false, plane));
			
			Tweener.addTween(plane, motionParams);
			
			const flightDelay:Number = MIN_FLIGHT_DELAY + Math.random() * (MAX_FLIGHT_DELAY - MIN_FLIGHT_DELAY);
			setTimeout(startFly, flightDelay);
			
			if (Application.IS_FLIGHTS_ANOUNSING_NEED) {
				trace("Flight:", '"model.number"', "from", model.fromCity, "to", model.toCity, "in fly. Next flight through", flightDelay);
			}
		}
		
		/**
		 * 
		 */
		
		private function onPlaneArrival(plane:PlaneView):void {
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
					removeChild(plane);
					plane.dispose();
					plane = null;
				}
			}
			Tweener.addTween(plane, arriveMotion);
		}
		
	}

}