package com.sots.events {
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class ToolbarEvent extends Event {
		
		static public const AREA_SIZE_CHANGED:String = "areaSizeChanged";
		static public const AREA_SPEED_CHANGED:String = "areaSpeedChanged";
		
		public function ToolbarEvent(type:String, bubbles:Boolean=false, data:Object = null) { 
			super(type, bubbles, data);
			
		} 
		
		public function clone():Event { 
			return new ToolbarEvent(type, bubbles, data);
		} 
		
		override public function toString():String {
			return ("ToolbarEvent: " + type +"; " + bubbles + "; " + data + ";");
		}
		
	}
	
}