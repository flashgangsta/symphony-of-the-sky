package com.sots {
	import starling.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class Dispatcher extends EventDispatcher {
		
		static private var instance:Dispatcher;
		
		/**
		 * 
		 */
		
		public function Dispatcher() {
			if(!instance) {
				instance = this;
				init();
			} else {
				throw new Error("Dispatcher is singletone. Use static funtion getInstance() for get an instance of class");
			}
		}
		
		/**
		 * 
		 */
		
		static public function getInstance():Dispatcher {
			if(!instance) {
				instance = new Dispatcher();
			}
			return instance;
		}
		
		/**
		 * 
		 */
		
		private function init():void {
			
		}
		
	}
	
}