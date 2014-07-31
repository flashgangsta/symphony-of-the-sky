package com.sots {
	import assets.bitmaps.LaunchImageBMD;
	import com.flashgangsta.managers.MappingManager;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureSmoothing;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	[Frame(factoryClass="com.sots.Preloader")]
	
	public class Main extends Sprite {
		
		private var _starling:Starling;
		private var launchImage:Bitmap = new Bitmap(new LaunchImageBMD());
		private var main:Application;
		
		/**
		 * 
		 */
		
		public function Main() {
			super();
			addEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:flash.events.Event):void {
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, onAddedToStage);
			launchImage.smoothing = true;
			addChild(launchImage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(flash.events.Event.RESIZE, onStageRisized);
			
			Starling.handleLostContext = true;
			
			_starling = new Starling(Application, stage);
			_starling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
			_starling.start();
			stage.addEventListener(flash.events.Event.DEACTIVATE, onStageDeactivate);
			
			onStageRisized();
			
		}
		
		private function onStageDeactivate(event:flash.events.Event):void {
			stage.addEventListener(flash.events.Event.ACTIVATE, onStageActivate);
			stage.removeEventListener(flash.events.Event.DEACTIVATE, onStageDeactivate);
			
			_starling.stop();
			SoundManager.getInstance().setVolume(0);
		}
		
		private function onStageActivate(event:flash.events.Event):void {
			stage.addEventListener(flash.events.Event.DEACTIVATE, onStageDeactivate);
			stage.removeEventListener(flash.events.Event.ACTIVATE, onStageActivate);
			_starling.start();
			SoundManager.getInstance().setVolume(1);
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onRootCreated(event:starling.events.Event):void {
			main = _starling.root as Application;
			onStageRisized();
			//_starling.showStats = true;
			
			const launchImage:Image = new Image(Texture.fromBitmapData(this.launchImage.bitmapData));
			launchImage.scaleX = this.launchImage.scaleX;
			launchImage.scaleY = this.launchImage.scaleY;
			launchImage.touchable = false;
			launchImage.smoothing = TextureSmoothing.TRILINEAR;
			
			main.addChild(launchImage);
			removeChild(this.launchImage);
			this.launchImage.bitmapData.dispose();
			this.launchImage = null;
			
			if (_starling.context.driverInfo.toLowerCase().indexOf("disabled") !== -1) {
				stage.frameRate = 31;
			}
			
			setTimeout(main.startApplication, Math.max(0, 4000 - getTimer()));
		}
		
		/**
		 * 
		 * @param	event
		 */
		
		private function onStageRisized(event:flash.events.Event = null):void {
			Application.STAGE_RECT = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			if (_starling) {
				_starling.viewPort.x = Application.STAGE_RECT.x;
				_starling.viewPort.y = Application.STAGE_RECT.y;
				_starling.viewPort.width = Application.STAGE_RECT.width;
				_starling.viewPort.height = Application.STAGE_RECT.height;
				_starling.stage.stageWidth = Application.STAGE_RECT.width;
				_starling.stage.stageHeight = Application.STAGE_RECT.height;
			}
			
			if (main) {
				main.resize();
			}
			
			if(this.launchImage) {
				MappingManager.setScaleFillArea(launchImage, Application.STAGE_RECT);
			}
		}
		
	}
	
}