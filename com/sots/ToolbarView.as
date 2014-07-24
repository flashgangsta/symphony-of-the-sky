package com.sots {
	import assets.bitmaps.SliderThumbDefault;
	import assets.bitmaps.SliderThumbDown;
	import assets.bitmaps.ToolbarBGBottom;
	import assets.bitmaps.ToolbarBGCenter;
	import assets.bitmaps.ToolbarBGTop;
	import com.flashgangsta.managers.MappingManager;
	import com.sots.events.ToolbarEvent;
	import feathers.controls.Slider;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class ToolbarView extends Sprite {
		
		private var sizeSlider:Slider = new Slider();
		private var speedSlider:Slider = new Slider();
		
		public function ToolbarView() {
			super();
			var bgTop:Image = new Image(Texture.fromBitmapData(new ToolbarBGTop()));
			var bgCenter:Image = new Image(Texture.fromBitmapData(new ToolbarBGCenter()));
			var bgBottom:Image = new Image(Texture.fromBitmapData(new ToolbarBGBottom()));
			
			bgTop.touchable = false;
			bgCenter.touchable = false;
			bgBottom.touchable = false;
			
			bgCenter.y = bgTop.bounds.bottom;
			bgBottom.y = bgCenter.bounds.bottom;
			
			addChild(bgTop);
			addChild(bgCenter);
			addChild(bgBottom);
			
			const sliderFactory:SliderFactory = SliderFactory.getInstance();
			
			sizeSlider = sliderFactory.getNewSlider();
			speedSlider = sliderFactory.getNewSlider();
			
			sizeSlider.step = speedSlider.step = .005;
			sizeSlider.page = speedSlider.page = 1;
			
			sizeSlider.x = speedSlider.x = MappingManager.getCentricPoint(bgBottom.width, sizeSlider.width);
			speedSlider.addEventListener(Event.CHANGE, changeSpeed);
			sizeSlider.addEventListener(Event.CHANGE, changeRadius);
			
			sizeSlider.minimum = .1;
			sizeSlider.maximum = 1;
			sizeSlider.value = .5;
			sizeSlider.y = bgBottom.y + 388;
			addChild(sizeSlider);
			
			speedSlider.minimum = .1;
			speedSlider.maximum = 1;
			speedSlider.value = .5;
			speedSlider.y = bgBottom.y + 552;
			addChild(speedSlider);
			
			trace(sizeSlider.value);
		}
		
		public function get circleSize():Number {
			return sizeSlider.value;
		}
		
		public function get circleSpeed():Number {
			return speedSlider.value;
		}
		
		private function changeSpeed(event:Event):void {
			trace("Change speed to:", speedSlider.value);
			dispatchEvent(new ToolbarEvent(ToolbarEvent.AREA_SPEED_CHANGED));
		}
		
		private function changeRadius(event:Event):void {
			trace("Change radius to:", sizeSlider.value);
			dispatchEvent(new ToolbarEvent(ToolbarEvent.AREA_SIZE_CHANGED));
		}
		
	}

}