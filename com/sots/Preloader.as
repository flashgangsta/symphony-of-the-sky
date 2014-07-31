package com.sots {
	import assets.fonts.HelveticaNeueBold;
	import com.flashgangsta.managers.MappingManager;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class Preloader extends MovieClip {
		
		private var font:HelveticaNeueBold = new HelveticaNeueBold();
		private var textField:TextField;
		private var textFieldContainer:Sprite = new Sprite();
		
		public function Preloader() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			// TODO show loader
			
			const textFormat:TextFormat = new TextFormat(font.fontName, null, null, true);
			
			textField = new TextField();
			textField.text = "0%";
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.setTextFormat(textFormat);
			textField.defaultTextFormat = textFormat;
			textField.embedFonts = true;
			textField.selectable = false;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textFieldContainer.addChild(textField);
			addChild(textFieldContainer);
			updatePreloader();
		}
		
		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, onResize);
			updatePreloader();
		}
		
		private function onResize(event:Event):void {
			updatePreloader();
		}
		
		private function updatePreloader():void {
			const area:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			textFieldContainer.height = area.height;
			textFieldContainer.scaleX = textFieldContainer.scaleY;
			MappingManager.alignToCenter(textFieldContainer, area);
		}
		
		private function ioError(e:IOErrorEvent):void {
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void {
			textField.text = int(e.bytesLoaded / e.bytesTotal * 100) + "%";
			updatePreloader();
		}
		
		private function checkFrame(e:Event):void {
			if (currentFrame === totalFrames) {
				stop();
				loadingFinished();
			}
		}
		
		private function loadingFinished():void {
			removeEventListener(Event.ENTER_FRAME, checkFrame);
			loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
			stage.removeEventListener(Event.RESIZE, onResize);
			removeChild(textFieldContainer);
			
			// TODO hide loader
			
			startup();
		}
		
		private function startup():void {
			var mainClass:Class = getDefinitionByName("com.sots.Main") as Class;
			addChild(new mainClass() as DisplayObject);
		}
		
	}
	
}