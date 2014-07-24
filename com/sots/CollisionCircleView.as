package com.sots {
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CollisionCircleView extends CircleView {
		private var flight:FlightView;
		
		public function CollisionCircleView(texture:Texture, flight:FlightView) {
			super(texture);
			
			//x = -(flight.width / 2);
			//y = -(flight.height / 2);
			
			trace(this, this.numChildren, this.width, this.height);
			
			flight.addChild(this);
		}
		
	}

}