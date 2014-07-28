package com.sots {
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class SoundManager {
		
		static private var instance:SoundManager;
		
		/**
		 *
		 */
		
		public function SoundManager() {
			if (!instance) {
				instance = this;
				init();
			} else {
				throw new Error("SoundManager is singletone. Use static funtion getInstance() for get an instance of class");
			}
		}
		
		/**
		 *
		 */
		
		static public function getInstance():SoundManager {
			if (!instance) {
				instance = new SoundManager();
			}
			return instance;
		}
		
		/**
		 *
		 */
		
		private function init():void {
		
		}
		
		public function generateSound(xPrecent:Number, yPrecent:Number):void {
		
		}
	
	}

}