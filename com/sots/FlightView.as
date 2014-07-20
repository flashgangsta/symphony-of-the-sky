package com.sots {
	import assets.bitmaps.PlaneBMD;
	import assets.Plane;
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class FlightView extends Sprite {
		private const planeShadow:DropShadowFilter = new DropShadowFilter(11, 45, 0, 1, 13, 13, .47, BitmapFilterQuality.HIGH);
		private var model:FlightModel;
		private var flightTexture:Texture;
		
		public function FlightView(model:FlightModel) {
			this.model = model;
			
			var planeBMD:PlaneBMD = new PlaneBMD();
			var planeBitmap:Bitmap = new Bitmap(planeBMD, PixelSnapping.NEVER);
			var planeContainer:flash.display.Sprite = new flash.display.Sprite();
			var shadowMargin:int = Math.max(planeShadow.blurX, planeShadow.blurY, planeShadow.distance);
			var matrix:Matrix = new Matrix();
			var planeBounds:Rectangle;
			var planeWithShadowBMD:BitmapData;
			var plane:Image;
			
			planeBitmap.scaleX = planeBitmap.scaleY = model.scale;
			planeBitmap.rotation = model.rotation * (180 / Math.PI);
			planeBitmap.filters = [planeShadow];
			planeBitmap.smoothing = true;
			planeContainer.addChild(planeBitmap);
			
			planeBounds = planeContainer.getBounds(planeContainer);
			planeBounds.x = Math.floor(planeBounds.x);
			planeBounds.y = Math.floor(planeBounds.y);
			planeBounds.width = Math.ceil(planeBounds.width + shadowMargin * 2);
			planeBounds.height = Math.ceil(planeBounds.height + shadowMargin * 2);
			
			matrix.identity();
			matrix.translate(Math.ceil(-planeBounds.x + shadowMargin), Math.ceil( -planeBounds.y + shadowMargin));
			
			planeWithShadowBMD = new BitmapData(planeBounds.width, planeBounds.height, true, 0x00000000);
			planeWithShadowBMD.lock();
			planeWithShadowBMD.draw(planeContainer, matrix);
			planeWithShadowBMD.unlock();
			
			flightTexture = Texture.fromBitmapData(planeWithShadowBMD);
			
			//dispose
			
			planeBMD.dispose();
			planeBMD = null;
			
			planeWithShadowBMD.dispose();
			planeWithShadowBMD = null;
			
			planeBitmap.filters = [];
			planeBitmap = null;
			
			planeBounds = null;
			
			planeContainer.removeChildren();
			planeContainer = null;
			
			matrix = null;
		}
		
		/**
		 * 
		 */
		
		override public function dispose():void {
			super.dispose();
		}
		
		/**
		 * 
		 */
		
		public function startFly():void {
			trace("Flight:", '"model.number"', "from", model.fromCity, "to", model.toCity, "in fly");
			const plane:PlaneView = new PlaneView(flightTexture);
			const motionParams:Object = {
				x: model.toPoint.x,
				y: model.toPoint.y,
				time: model.distance / model.speed,
				transition: "linear",
				onComplete: function():void {
					onPlaneArrival(plane);
				}
			}
			
			plane.x = model.fromPoint.x;
			plane.y = model.fromPoint.y;
			
			addChild(plane);
			
			Tweener.addTween(plane, motionParams);
		}
		
		/**
		 * 
		 */
		
		private function onPlaneArrival(plane:PlaneView):void {
			trace("Flight:", '"model.number"', "from", model.fromCity, "to", model.toCity, "arrived");
			var arriveMotion:Object = {
				scaleX: 0,
				scaleY: 0,
				time: .5,
				delay: .25,
				transition: "easeInCubic",
				onComplete: function():void {
					removeChild(plane);
					plane.dispose();
					plane = null;
				}
			}
			Tweener.addTween(plane, arriveMotion);
		}
		
	}

}