package com.sots {
	import assets.bitmaps.MapBMD;
	import assets.WaypointsHolder;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Map extends Sprite {
		
		[Embed(source="../../assets/data/fligshts.xml", mimeType="application/octet-stream")]
		private const FLIGHTS:Class;
		
		private var flightsData:XML = new XML(new FLIGHTS().toString());
		private var mapBMD:MapBMD = new MapBMD();
		private var mapImage:Image = new Image(Texture.fromBitmapData(mapBMD));
		private var flightsModelsList:Vector.<FlightModel> = new Vector.<FlightModel>();
		
		
		public function Map() {
			super();
		}
		
		public function init():void {
			var i:int;
			
			// init map
			mapBMD.dispose();
			mapBMD = null;
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
			
			for (i = 0; i < flightsLength; i++) {
				flightData = flightsXMLList[i];
				fromMarker = waypointsHolder.getChildByName(flightData.@from);
				toMarker = waypointsHolder.getChildByName(flightData.@to);
				fromPoint = new Point(int(fromMarker.x), int(fromMarker.y));
				toPoint = new Point(int(toMarker.x), int(toMarker.y));
				flightModel = new FlightModel(flightData, fromPoint, toPoint);
				flightsModelsList.push(flightModel);
			}
			
			// moscow - minsk
			var flight:FlightView = new FlightView(flightsModelsList[0]);
			addChild(flight);
			flight.startFly();
			
			// laliningrad - moscow
			flight = new FlightView(flightsModelsList[16]);
			addChild(flight);
			flight.startFly();
			
			//rome - moscow
			flight = new FlightView(flightsModelsList[14]);
			addChild(flight);
			flight.startFly();
			
			//london - moscow
			flight = new FlightView(flightsModelsList[13]);
			addChild(flight);
			flight.startFly();
			
		}
		
	}

}