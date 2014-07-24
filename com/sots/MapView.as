package com.sots {
	import assets.bitmaps.MapBMD;
	import assets.bitmaps.PlaneBMD;
	import assets.WaypointsHolder;
	import com.flashgangsta.starling.display.Shapes;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class MapView extends Sprite {
		
		[Embed(source="../../assets/fligshts.xml", mimeType="application/octet-stream")]
		private const FLIGHTS:Class;
		
		private var flightsData:XML = new XML(new FLIGHTS().toString());
		private const flightsContainer:Sprite = new Sprite();
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
				flightModel = new FlightModel(flightData, fromPoint, toPoint);
				flight = new FlightView(planeBMD, flightModel);
				flightsContainer.addChild(flight);
				flight.startFlying();
			}
			
			//init collision texture
			collisionTexture = Shapes.getCircleTexture(Math.max(planeBMD.width, planeBMD.height) / 2 + 5, 0xff0042, 1);
			
			addChild(flightsContainer);
		}
		
		public function get activeFlightsNum():int {
			return flightsContainer.numChildren;
		}
		
		public function getFlightBoundsByIndex(index:int):Rectangle {
			var flight:FlightView = flightsContainer.getChildAt(index) as FlightView;
			return flight.collisionPlayed ? null : flight.getBounds(this);
		}
		
		public function lockFlights():void {
			removeChild(flightsContainer);
		}
		
		public function unlockFlights():void {
			addChild(flightsContainer);
		}
		
		public function playCollisionByFlightIndex(index:int):void {
			const flight:FlightView = flightsContainer.getChildAt(index) as FlightView;
			const collisionCircle:CollisionCircleView = new CollisionCircleView(collisionTexture, flight);
			flight.collisionPlayed = true;
			flight.alpha = .5;
		}
		
	}

}