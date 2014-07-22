package com.sots {
	import assets.bitmaps.MapBMD;
	import assets.WaypointsHolder;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;

	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Map extends Sprite {
		
		[Embed(source="../../assets/fligshts.xml", mimeType="application/octet-stream")]
		private const FLIGHTS:Class;
		
		private var flightsData:XML = new XML(new FLIGHTS().toString());
		private const flightsContainer:Sprite = new Sprite();
		private var mapBMD:MapBMD = new MapBMD();
		private var mapImage:Image = new Image(Texture.fromBitmapData(mapBMD));
		
		public function Map() {
			var i:int;
			
			// init map
			mapBMD.dispose();
			mapBMD = null;
			mapImage.touchable = false;
			mapImage.smoothing = TextureSmoothing.TRILINEAR;
			addChild(mapImage);
			
			//init fligts model
			const flightsXMLList:XMLList = flightsData.*.flight;
			const flightsLength:int = flightsXMLList.length();
			const waypointsHolder:WaypointsHolder = new WaypointsHolder();
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
				flight = new FlightView(flightModel);
				flightsContainer.addChild(flight);
				flight.startFlying();
			}
			
			addChild(flightsContainer);
		}
		
		public function lockFlights():void {
			removeChild(flightsContainer);
		}
		
		public function unlockFlights():void {
			addChild(flightsContainer);
		}
		
	}

}