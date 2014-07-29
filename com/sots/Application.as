package com.sots {
	import com.flashgangsta.managers.MappingManager;
	import com.sots.events.CircleEvent;
	import com.sots.events.ToolbarEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Application extends Sprite {
		
		static public var STAGE_RECT:Rectangle;
		static public var nextPlaneID:int = 1;
		static public const MAX_TEXTURE_SIZE:int = 2048;
		static public const IS_FLIGHTS_ANOUNSING_NEED:Boolean = false;
		private var map:MapView = new MapView();
		private var toolbar:ToolbarView = new ToolbarView();
		private var circlesContainer:CirclesContainerView = new CirclesContainerView();
		private var soundManager:SoundManager = SoundManager.getInstance();
		
		public function Application() {
			super();
			//new AeonDesktopTheme();
		}
		
		public function startApplication():void {
			removeChildren();
			addChild(map);
			addChild(circlesContainer);
			addChild(toolbar);
			
			toolbar.addEventListener(ToolbarEvent.AREA_SIZE_CHANGED, updateCircleSize);
			toolbar.addEventListener(ToolbarEvent.AREA_SPEED_CHANGED, updateCircleSpeed);
			
			circlesContainer.setPreviewSize(toolbar.circleSize, false);
			circlesContainer.setPreviewSpeed(toolbar.circleSpeed, false);
			circlesContainer.addEventListener(CircleEvent.UPDATED, onCircleUpdated);
			
			map.addEventListener(TouchEvent.TOUCH, onTouchOnMap);
			
			resize();
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onCircleUpdated(event:CircleEvent):void {
			const planesNum:int = map.planesInFlyNum;
			if (!planesNum) return;
			var planeModel:PlaneModel;
			var distance:Number;
			const planeLocation:Point = new Point();
			const circle:CircleView = event.circle;
			const circleBounds:Rectangle = circle.getBounds(map);
			const circleLocation:Point = new Point();
			const circleRadius:Number = circleBounds.width / 2;
			circleLocation.x = circleBounds.x + circleRadius;
			circleLocation.y = circleBounds.y + circleRadius;
			
			for (var i:int = 0; i < planesNum; i++) {
				planeModel = map.getPlaneModelByIndex(i);
				if (circle.isPlaneExistsInHistory(planeModel.planeID)) {
					continue;
				}
				planeLocation.x = planeModel.centerX;
				planeLocation.y = planeModel.centerY;
				distance = Point.distance(planeLocation, circleLocation);
				
				if (distance < circleRadius + planeModel.radius - 4) {
					planesNum--;
					map.playCollision(i);
					circle.addCollisionHistory(planeModel.planeID);
					soundManager.generateSound(planeLocation.x / toolbar.x, planeLocation.y / stage.stageHeight);
				}
			}
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onTouchOnMap(event:TouchEvent):void {
			var touch:Touch = event.getTouch(map);
			if(touch && touch.phase === TouchPhase.BEGAN) {
				circlesContainer.addCircle(touch.getLocation(circlesContainer));
			}
		}
		
		/**
		 * 
		 */
		
		public function resize():void {
			const mapDisplayRect:Rectangle = Application.STAGE_RECT.clone();
			toolbar.height = mapDisplayRect.height;
			toolbar.scaleX = toolbar.scaleY;
			MappingManager.roundObjectSides(toolbar, Math.ceil);
			mapDisplayRect.width = Application.STAGE_RECT.width - toolbar.width;
			toolbar.x = mapDisplayRect.width;
			
			map.lockFlights();
			MappingManager.setScaleFillArea(map, mapDisplayRect);
			MappingManager.alignToCenter(map, mapDisplayRect);
			map.unlockFlights();
			
			circlesContainer.setViewArea(mapDisplayRect.width, mapDisplayRect.height);
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function updateCircleSize(event:ToolbarEvent):void {
			circlesContainer.setPreviewSize(toolbar.circleSize);
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function updateCircleSpeed(event:ToolbarEvent):void {
			circlesContainer.setPreviewSpeed(toolbar.circleSpeed);
		}
	}

}