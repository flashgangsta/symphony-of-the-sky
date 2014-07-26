package com.sots.events {
	import com.sots.PlaneView;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class FlightEvent extends Event {
		
		static public const PLANE_READY_TO_FLY:String = "PlaneReadyToFly";
		
		public function FlightEvent(type:String, bubbles:Boolean=false, plane:PlaneView = null) { 
			super(type, bubbles, plane);
		} 
		
		public function clone():Event { 
			return new FlightEvent(type, bubbles, plane);
		} 
		
		override public function toString():String {
			return ("FlightEvent: " + type +"; " + bubbles + "; " + data + ";");
		}
		
		/**
		 * 
		 */
		
		public function get plane():PlaneView {
			return data as PlaneView;
		}
		
	}
	
}