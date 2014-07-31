package com.sots {
	import assets.fonts.HelveticaNeueBold;
	import com.flashgangsta.starling.display.Shapes;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	public class PlaneTableView extends Sprite {
		private const BG_MARGIN:int = 14;
		private const FONT:HelveticaNeueBold = new HelveticaNeueBold();
		private const DEFAULT_COLOR:uint = 0x0079b2;
		private const COLLISION_COLOR:uint = 0xff0042;
		
		private var message:TextField;
		private var title:TextField;
		private var bgDefault:Image;
		private var bgCollision:Image;
		
		public function PlaneTableView(from:String, to:String, number:String) {
			super();
			
			title = new TextField(1, 1, number, FONT.fontName, 14, 0xFFFFFF, true);
			message = new TextField(1, 1, from + "—" + to, FONT.fontName, 16, 0xFFFFFF, true);
			title.autoSize = message.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
			
			title.y = BG_MARGIN / 2;
			title.x = message.x = BG_MARGIN / 2;
			
			message.y = title.y + title.height;
			addChild(title);
			addChild(message);
			
			bgDefault = new Image(Shapes.getRectTexture(Math.max(title.width, message.width) + BG_MARGIN, message.y + message.height + BG_MARGIN, DEFAULT_COLOR));
			bgCollision = new Image(Shapes.getRectTexture(Math.max(title.width, message.width) + BG_MARGIN, message.y + message.height + BG_MARGIN, COLLISION_COLOR));
			
			bgCollision.visible = false;
			
			title.touchable = false;
			message.touchable = false;
			bgDefault.touchable = false;
			
			touchable = false;
			
			addChildAt(bgDefault, 0);
			addChildAt(bgCollision, 0);
		}
		
		override public function dispose():void {
			message.dispose();
			title.dispose();
			bgDefault.texture.dispose();
			bgCollision.texture.dispose();
			bgDefault.dispose();
			bgCollision.dispose();
			super.dispose();
		}
		
		public function playCollision():void {
			bgDefault.visible = false;
			bgCollision.visible = true;
		}
		
		public function stopCollision():void {
			bgCollision.visible = false;
			bgDefault.visible = true;
		}
		
	}

}