package com.sots.events {
	import com.sots.CircleView;
	import starling.events.Event;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CircleEvent extends Event {
		static public const UPDATED:String = "CircleUpdated";
		static public const COMPLETE:String = "CircleComplete";
		
		public function CircleEvent(type:String, bubbles:Boolean=false, data:CircleView = null) { 
			super(type, bubbles, data);
		} 
		
		public function clone():Event { 
			return new CircleEvent(type, bubbles, circle);
		} 
		
		override public function toString():String {
			return ("CircleEvent: " + type +"; " + bubbles + "; " + data + ";");
		}
		
		/**
		 * 
		 */
		
		public function get circle():CircleView {
			return super.data as CircleView;
		}
		
	}
	
}