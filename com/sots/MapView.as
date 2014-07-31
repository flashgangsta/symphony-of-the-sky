package com.sots {
	import assets.bitmaps.MapBMD;
	import assets.bitmaps.PlaneBMD;
	import assets.WaypointsHolder;
	import com.flashgangsta.starling.display.Shapes;
	import com.flashgangsta.utils.ArrayMixer;
	import com.sots.events.FlightEvent;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MapView extends Sprite {
		
		[Embed(source="../../assets/fligshts.xml", mimeType="application/octet-stream")]
		private const FLIGHTS:Class;
		
		static public const PX_IN_KM:Number = 2.473924256135846;
		static public const SEC_IN_H:Number = (60 * 60) / 15;
		static public const DISPLAYED_PLANES_NUM:Number = 15;
		
		private var flightsData:XML = new XML(new FLIGHTS().toString());
		private const planesContainer:Sprite = new Sprite();
		private const collisionsContainer:Sprite = new Sprite();
		private var mapBMD:MapBMD = new MapBMD();
		private var mapImage:Image = new Image(Texture.fromBitmapData(mapBMD));
		private var collisionTexture:Texture;
		private var flightIndexesQueue:Array;
		private var flightsList:Vector.<FlightView> = new Vector.<FlightView>();
		private var planeTablesContainer:Sprite = new Sprite();
		
		public function MapView() {
			var i:int;
			
			// init map
			mapBMD.dispose();
			mapBMD = null;
			mapImage.smoothing = TextureSmoothing.TRILINEAR;
			addChild(mapImage);
			
			
			//init fligts model
			const flightsXMLList:XMLList = flightsData.*.flight;
			const flightsLength:int = flightsXMLList.length();
			const waypointsHolder:WaypointsHolder = new WaypointsHolder();
			const planeBMD:PlaneBMD = new PlaneBMD();
			var fromMarkerName:String;
			var toMarkerName:String;
			var flightModel:FlightModel;
			var flightData:XML;
			var fromMarker:DisplayObject;
			var toMarker:DisplayObject;
			var fromPoint:Point;
			var toPoint:Point;
			var flight:FlightView;
			
			for (i = 0; i < flightsLength; i++) {
				flightData = flightsXMLList[i];
				fromMarkerName = (String(flightData.@from).charAt(0).toLocaleLowerCase() + String(flightData.@from).substr(1)).replace(" ", "");
				toMarkerName = (String(flightData.@to).charAt(0).toLocaleLowerCase() + String(flightData.@to).substr(1)).replace(" ", "");
				fromMarker = waypointsHolder.getChildByName(fromMarkerName);
				toMarker = waypointsHolder.getChildByName(toMarkerName);
				fromPoint = new Point(int(fromMarker.x), int(fromMarker.y));
				toPoint = new Point(int(toMarker.x), int(toMarker.y));
				flightModel = new FlightModel(planeBMD, flightData, fromPoint, toPoint);
				flight = new FlightView(flightModel);
				flight.addEventListener(FlightEvent.PLANE_READY_TO_FLY, addPlane);
				flight.addEventListener(FlightEvent.PLANE_ARRIVED, onPlaneArrived);
				flightsList.push(flight);
			}
			
			flightIndexesQueue = ArrayMixer.getMixedNumbersArray(0, flightsLength - 1);
			
			for (i = 0; i < DISPLAYED_PLANES_NUM; i++) {
				var currentIndex:int = flightIndexesQueue.pop();
				flightsList[currentIndex].startFly(Math.random());
			}
			
			//init collision texture
			collisionTexture = Shapes.getCircleTexture(Math.max(planeBMD.width, planeBMD.height) / 2 + 5, 0xff0042, 1);
			
			collisionsContainer.addEventListener(Event.COMPLETE, onCollisionSircleComplete);
			
			addChild(planesContainer);
			addChild(planeTablesContainer);
			addChild(collisionsContainer);
		}
		
		public function get planesInFlyNum():int {
			return planesContainer.numChildren;
		}
		
		public function getPlaneModelByIndex(index:int):PlaneModel {
			const plane:PlaneView = planesContainer.getChildAt(index) as PlaneView;
			const planeModel:PlaneModel = plane.getModel();
			planeModel.centerX = plane.x;
			planeModel.centerY = plane.y;
			planeModel.planeID = plane.id;
			return planeModel;
		}
		
		public function lockFlights():void {
			removeChild(planesContainer);
		}
		
		public function unlockFlights():void {
			addChild(planesContainer);
		}
		
		public function playCollision(index:int):void {
			const plane:PlaneView = planesContainer.getChildAt(index) as PlaneView;
			const collisionCircle:CollisionCircleView = new CollisionCircleView(collisionTexture, plane, new Point(plane.x, plane.y));
			plane.playCollision();
			collisionsContainer.addChild(collisionCircle);
			SoundManager.getInstance().playCollisionSound(plane.getModel().sizeType);
			plane.getModel().sizeType
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onPlaneArrived(event:FlightEvent):void {
			var currentIndex:int = flightIndexesQueue.pop();
			var flight:FlightView = flightsList[currentIndex];
			
			while (flight.inFly) {
				currentIndex = getFlightIndexesQueue().pop();
				flight = flightsList[currentIndex];
			}
			
			flight.startFly();
		}
		
		/**
		 * 
		 * @return
		 */
		
		private function getFlightIndexesQueue():Array {
			if (!flightIndexesQueue.length) {
				flightIndexesQueue = ArrayMixer.getMixedNumbersArray(0, flightsList.length - 1);
			}
			return flightIndexesQueue;
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function addPlane(event:FlightEvent):void {
			planesContainer.addChild(event.plane);
		}
		
		private function onCollisionSircleComplete(event:Event):void {
			const plane:PlaneView = event.data as PlaneView;
			event.stopImmediatePropagation();
			plane.stopCollision();
			
		}
		
	}

}