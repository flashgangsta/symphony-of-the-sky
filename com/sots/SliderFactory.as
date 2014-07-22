package com.sots {
	import assets.bitmaps.SliderThumbDefault;
	import assets.bitmaps.SliderThumbDown;
	import feathers.controls.Slider;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class SliderFactory {
		
		static private var instance:SliderFactory;
		private const WIDTH:int = 554;
		private const HEIGHT:int = 35;
		private var thumbDefaultScale9Texture:Scale9Textures;
		private var thumbDownScale9Texture:Scale9Textures;
		
		/**
		 * 
		 */
		
		public function SliderFactory() {
			if(!instance) {
				instance = this;
				init();
			} else {
				throw new Error("SliderFactory is singletone. Use static funtion getInstance() for get an instance of class");
			}
		}
		
		/**
		 * 
		 */
		
		static public function getInstance():SliderFactory {
			if(!instance) {
				instance = new SliderFactory();
			}
			return instance;
		}
		
		/**
		 * 
		 */
		
		private function init():void {
			const thumbDefaultBMD:BitmapData = new SliderThumbDefault();
			const thumbDownBMD:BitmapData = new SliderThumbDown();
			const thumbDefaultTexture:Texture = Texture.fromBitmapData(thumbDefaultBMD);
			const thumbDownTexture:Texture = Texture.fromBitmapData(thumbDownBMD);
			const thumbDefaultScale9Grid:Rectangle = new Rectangle(0, 0, thumbDefaultBMD.width, thumbDefaultBMD.height);
			const thumbDownScale9Grid:Rectangle = new Rectangle(0, 0, thumbDownBMD.width, thumbDownBMD.height)
			thumbDefaultScale9Texture = new Scale9Textures(thumbDefaultTexture, thumbDefaultScale9Grid);
			thumbDownScale9Texture = new Scale9Textures(thumbDownTexture, thumbDownScale9Grid);
			thumbDefaultBMD.dispose();
			thumbDownBMD.dispose();
		}
		
		/**
		 * 
		 * @return
		 */
		
		public function getNewSlider():Slider {
			var slider:Slider = new Slider();
			slider.setSize(WIDTH, HEIGHT);
			slider.thumbProperties.defaultSkin = new Scale9Image(thumbDefaultScale9Texture);
			slider.thumbProperties.downSkin = new Scale9Image(thumbDownScale9Texture);
			return slider;
		}
		
	}
	
}