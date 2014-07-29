package com.sots {
	import assets.bitmaps.MapBMD;
	import assets.bitmaps.PlaneBMD;
	import assets.WaypointsHolder;
	import com.flashgangsta.starling.display.Shapes;
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
		static public const SEC_IN_H:Number = (60 * 60) / 450;
		
		private var flightsData:XML = new XML(new FLIGHTS().toString());
		private const planesContainer:Sprite = new Sprite();
		private const collisionPlanesContainer:Sprite = new Sprite();
		private const collisionsContainer:Sprite = new Sprite();
		private var mapBMD:MapBMD = new MapBMD();
		private var mapImage:Image = new Image(Texture.fromBitmapData(mapBMD));
		private var collisionTexture:Texture;
		
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
			var flightModel:FlightModel;
			var flightData:XML;
			var fromMarker:DisplayObject;
			var toMarker:DisplayObject;
			var fromPoint:Point;
			var toPoint:Point;
			var flight:FlightView;
			
			for (i = 0; i < flightsLength; i++) {
				flightData = flightsXMLList[i];
				fromMarker = waypointsHolder.getChildByName(flightData.@from);
				toMarker = waypointsHolder.getChildByName(flightData.@to);
				fromPoint = new Point(int(fromMarker.x), int(fromMarker.y));
				toPoint = new Point(int(toMarker.x), int(toMarker.y));
				flightModel = new FlightModel(planeBMD, flightData, fromPoint, toPoint);
				flight = new FlightView(flightModel);
				flight.addEventListener(FlightEvent.PLANE_READY_TO_FLY, addPlane);
				flight.startFlying();
			}
			
			//init collision texture
			collisionTexture = Shapes.getCircleTexture(Math.max(planeBMD.width, planeBMD.height) / 2 + 5, 0xff0042, 1);
			
			collisionsContainer.addEventListener(Event.COMPLETE, onCollisionSircleComplete);
			
			addChild(planesContainer);
			addChild(collisionsContainer);
		}
		
		private function addPlane(event:FlightEvent):void {
			planesContainer.addChild(event.plane);
		}
		
		public function get planesInFlyNum():int {
			return planesContainer.numChildren;
		}
		
		public function getPlaneModelByIndex(index:int):PlaneModel {
			const plane:PlaneView = planesContainer.getChildAt(index) as PlaneView;
			const planeModel:PlaneModel = plane.getModel();
			const planeBounds:Rectangle = plane.getBounds(this);
			planeModel.centerX = planeBounds.x + (planeBounds.width / 2)
			planeModel.centerY = planeBounds.y + (planeBounds.height / 2);
			planeModel.planeID = plane.id;
			return planeModel;
		}
		
		public function lockFlights():void {
			removeChild(planesContainer);
			removeChild(collisionPlanesContainer);
		}
		
		public function unlockFlights():void {
			addChild(planesContainer);
			//addChild(collisionPlanesContainer);
		}
		
		public function playCollision(index:int):void {
			const plane:PlaneView = planesContainer.getChildAt(index) as PlaneView;
			//collisionPlanesContainer.addChild(plane);
			const collisionCircle:CollisionCircleView = new CollisionCircleView(collisionTexture, plane, new Point(plane.x, plane.y));
			collisionsContainer.addChild(collisionCircle);
		}
		
		private function onCollisionSircleComplete(event:Event):void {
			const plane:PlaneView = event.data as PlaneView;
			event.stopImmediatePropagation();
			
		}
		
	}

}