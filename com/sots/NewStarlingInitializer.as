package com.sots {
	import assets.bitmaps.LaunchImageBMD;
	import com.flashgangsta.managers.MappingManager;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class NewStarlingInitializer extends Sprite {
		
		private var _starling:Starling;
		private var launchImage:Bitmap = new Bitmap(new LaunchImageBMD());
		private var main:Main;
		
		/**
		 * 
		 */
		
		public function NewStarlingInitializer() {
			super();
			
			launchImage.smoothing = true;
			addChild(launchImage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(flash.events.Event.RESIZE, onStageRisized);
			
			Starling.handleLostContext = true;
			
			_starling = new Starling(Main, stage);
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			_starling.start();
			
			onStageRisized();
			
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRootCreated(event:starling.events.Event):void {
			main = _starling.root as Main;
			onStageRisized();
			_starling.showStats = true;
			
			const launchImage:Image = new Image(Texture.fromBitmapData(this.launchImage.bitmapData));
			launchImage.scaleX = this.launchImage.scaleX;
			launchImage.scaleY = this.launchImage.scaleY;
			
			main.addChild(launchImage);
			removeChild(this.launchImage);
			this.launchImage.bitmapData.dispose();
			this.launchImage = null;
			
			if (_starling.context.driverInfo.toLowerCase().indexOf("disabled") !== -1) {
				stage.frameRate = 31;
			}
			
			setTimeout(main.startApplication, Math.max(0, 1/*3000 - getTimer()*/));
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onStageRisized(event:flash.events.Event = null):void {
			Main.STAGE_RECT = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			if (_starling) {
				_starling.viewPort.x = Main.STAGE_RECT.x;
				_starling.viewPort.y = Main.STAGE_RECT.y;
				_starling.viewPort.width = Main.STAGE_RECT.width;
				_starling.viewPort.height = Main.STAGE_RECT.height;
				_starling.stage.stageWidth = Main.STAGE_RECT.width;
				_starling.stage.stageHeight = Main.STAGE_RECT.height;
			}
			
			if (main) {
				main.resize();
			}
			
			if(this.launchImage) {
				MappingManager.setScaleFillArea(launchImage, Main.STAGE_RECT);
			}
		}
		
	}
	
}