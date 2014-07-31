package com.sots {
	import caurina.transitions.Tweener;
	import com.flashgangsta.starling.display.Shapes;
	import com.sots.events.CircleEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class CirclesContainerView extends Sprite {
		private const MAX_TIME:Number = 2;
		
		private const RADIUS:int = 1024;
		private const SCALE_TRANSITION:String = "easeOutCubic";
		
		private var texture:Texture;
		private var previewCircle:CircleView;
		private var hidePreviewTimeout:uint;
		private var scale:Number;
		private var speed:Number;
		
		public function CirclesContainerView() {
			super();
			touchable = false;
			texture = Shapes.getCircleTexture(RADIUS, 0xFF0042, .15);
			previewCircle = new CircleView(texture);
			previewCircle.visible = false;
			addChild(previewCircle);
			
			touchable = false;
		}
		
		/**
		 * 
		 * @param	width
		 * @param	height
		 */
		
		public function setViewArea(width:Number, height:Number):void {
			previewCircle.x = width/ 2;
			previewCircle.y = height / 2;
		}
		
		/**
		 * 
		 * @param	scale
		 */
		
		public function setPreviewSize(scale:Number, showPreview:Boolean = true):void {
			this.scale = scale;
			if (!showPreview) return;
			previewCircle.scaleX = previewCircle.scaleY = scale;
			preparePreview();
			hidePreviewTimeout = setTimeout(hidePreview, 1000);
		}
		
		/**
		 * 
		 * @param	speed
		 */
		
		public function setPreviewSpeed(speed:Number, showPreview:Boolean = true):void {
			this.speed = speed;
			if (!showPreview) return;
			preparePreview();
			previewCircle.scaleX = previewCircle.scaleY = 0;
			Tweener.addTween(previewCircle, {
				scaleX: scale,
				scaleY: scale,
				transition: SCALE_TRANSITION,
				time: MAX_TIME * speed,
				delay: .1,
				onComplete: hidePreview
			});
			
		}
		
		/**
		 * 
		 * @param	location
		 */
		
		public function addCircle(location:Point):void {
			const circle:CircleView = new CircleView(texture);
			const motionTime:Number = MAX_TIME * speed;
			
			circle.scaleX = circle.scaleY = 0;
			circle.x = location.x;
			circle.y = location.y;
			
			Tweener.addTween(circle, {
				scaleX: scale,
				scaleY: scale,
				transition: SCALE_TRANSITION,
				time: motionTime,
				onUpdate: function():void {
					dispatchCircleUpdated(circle);
				}
			});
			
			Tweener.addTween(circle, {
				alpha: 0,
				transition: "easeOutCubic",
				time: motionTime / 2,
				delay: motionTime / 2,
				onComplete: function():void {
					removeChild(circle, true);
				}
			});
			
			addChild(circle);
		}
		
		/**
		 * 
		 * @param	circle
		 */
		
		private function dispatchCircleUpdated(circle:CircleView):void {
			dispatchEvent(new CircleEvent(CircleEvent.UPDATED, false, circle));
		}
		
		/**
		 * 
		 */
		
		private function preparePreview():void {
			if (Tweener.isTweening(previewCircle)) {
				Tweener.removeTweens(previewCircle);
			}
			
			previewCircle.visible = true;
			previewCircle.alpha = 1;
			
			clearTimeout(hidePreviewTimeout);
		}
		
		/**
		 * 
		 */
		
		private function hidePreview(target:CircleView = null):void {
			Tweener.addTween(previewCircle, {
				alpha:0,
				transition: "easeInCubic",
				time: .6,
				onComplete: function():void {
					previewCircle.visible = false;
				}
			});
		}
		
	}

}