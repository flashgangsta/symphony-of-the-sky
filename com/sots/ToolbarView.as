package com.sots {
	import assets.bitmaps.SliderThumbDefault;
	import assets.bitmaps.SliderThumbDown;
	import assets.bitmaps.ToolbarBGBottom;
	import assets.bitmaps.ToolbarBGCenter;
	import assets.bitmaps.ToolbarBGTop;
	import com.flashgangsta.managers.MappingManager;
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
		
		private var radiusSlider:Slider = new Slider();
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
			
			radiusSlider = sliderFactory.getNewSlider();
			speedSlider = sliderFactory.getNewSlider();
			
			radiusSlider.step = speedSlider.step = 1;
			radiusSlider.page = speedSlider.page = 1;
			
			radiusSlider.x = speedSlider.x = MappingManager.getCentricPoint(bgBottom.width, radiusSlider.width);
			speedSlider.addEventListener(Event.CHANGE, changeSpeed);
			radiusSlider.addEventListener(Event.CHANGE, changeRadius);
			
			radiusSlider.minimum = 50;
			radiusSlider.maximum = 500;
			radiusSlider.value = 250;
			radiusSlider.y = bgBottom.y + 552;
			addChild(radiusSlider);
			
			speedSlider.minimum = 10;
			speedSlider.maximum = 100;
			speedSlider.value = 50;
			speedSlider.y = bgBottom.y + 388;
			addChild(speedSlider);
			
		}
		
		private function changeSpeed(event:Event):void {
			trace("Change speed to:", speedSlider.value);
		}
		
		private function changeRadius(event:Event):void {
			trace("Change radius to:", radiusSlider.value);
		}
		
	}

}