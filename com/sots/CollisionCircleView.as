package com.sots {
	import caurina.transitions.Tweener;
	import flash.geom.Point;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CollisionCircleView extends CircleView {
		static public const FADE_IN_TIME:Number = .4;
		
		public function CollisionCircleView(texture:Texture, plane:PlaneView, planeLocation:Point) {
			super(texture);
			const localPoint:Point = globalToLocal(planeLocation);
			x = localPoint.x;
			y = localPoint.y;
			alpha = .25;
			scaleX = scaleY = 0;
			Tweener.addTween(this, {
				scaleX: 1,
				scaleY: 1,
				transition: "easeOutCubic",
				time: FADE_IN_TIME
			});
			
			Tweener.addTween(this, {
				alpha: 0,
				time: FADE_IN_TIME * .5,
				delay: FADE_IN_TIME * .7,
				onComplete: function():void {
					dispatchEventWith(Event.COMPLETE, true, plane);
					parent.removeChild(this);
					dispose();
				}
			});
		}
		
	}

}