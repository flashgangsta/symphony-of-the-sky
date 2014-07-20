package com.sots {
	import starling.display.Sprite;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Main extends Sprite {
		
		private var map:Map = new Map();
		
		public function Main() {
			super();
		}
		
		public function startApplication():void {
			trace("RUN");
			removeChildren();
			addChild(map);
			map.init();
		}
		
		/**
		 * 
		 */
		
		public function resize():void {
			
		}
		
	}

}