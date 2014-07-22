package com.sots {
	import com.flashgangsta.managers.MappingManager;
	import flash.geom.Rectangle;
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Main extends Sprite {
		
		static public var STAGE_RECT:Rectangle;
		private var map:Map = new Map();
		private var toolbar:ToolbarView = new ToolbarView();
		
		public function Main() {
			super();
			//new AeonDesktopTheme();
		}
		
		public function startApplication():void {
			removeChildren();
			addChild(map);
			addChild(toolbar);
			resize();
		}
		
		/**
		 * 
		 */
		
		public function resize():void {
			const mapDisplayRect:Rectangle = Main.STAGE_RECT.clone();
			toolbar.height = mapDisplayRect.height;
			toolbar.scaleX = toolbar.scaleY;
			MappingManager.roundObjectSides(toolbar, Math.ceil);
			mapDisplayRect.width = Main.STAGE_RECT.width - toolbar.width;
			toolbar.x = mapDisplayRect.width;
			
			map.lockFlights();
			MappingManager.setScaleFillArea(map, mapDisplayRect);
			MappingManager.alignToCenter(map, mapDisplayRect);
			map.unlockFlights();
		}
		
	}

}