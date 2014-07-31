package com.flashgangsta.starling.display {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 * @version 0.02 31/07/2014
	 */
	
	public class Shapes {
		
		public function Shapes() {
			
		}
		
		static public function getCircleTexture(radius:Number, color:uint = 0x000000, alpha:Number = 1):Texture {
			const shape:Shape = new Shape();
			const graphics:Graphics = shape.graphics;
			const matrix:Matrix = new Matrix();
			const diameter:Number = radius * 2;
			var bitmapData:BitmapData = new BitmapData(diameter, diameter, true, 0x00000000);
			var texture:Texture;
			matrix.translate(radius, radius);
			graphics.beginFill(color, alpha);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
			bitmapData.draw(shape, matrix);
			texture = Texture.fromBitmapData(bitmapData);
			bitmapData.dispose();
			graphics.clear();
			
			return texture;
		}
		
		
		
		static public function getRectTexture(width:Number, height:Number, color:uint = 0x000000, alpha:Number = 1):Texture {
			const shape:Shape = new Shape();
			const graphics:Graphics = shape.graphics;
			var bitmapData:BitmapData = new BitmapData(width, height, true, 0x00000000);
			var texture:Texture;
			
			graphics.beginFill(color, alpha);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			bitmapData.draw(shape);
			texture = Texture.fromBitmapData(bitmapData);
			
			bitmapData.dispose();
			graphics.clear();
			
			return texture;
			
		}

		
	}

}