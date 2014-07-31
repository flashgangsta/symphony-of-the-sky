package com.sots {
	import assets.sounds.BackgroundSound;
	import assets.sounds.SoundBig1;
	import assets.sounds.SoundBig2;
	import assets.sounds.SoundBig3;
	import assets.sounds.SoundBig4;
	import assets.sounds.SoundMiddle1;
	import assets.sounds.SoundMiddle2;
	import assets.sounds.SoundMiddle3;
	import assets.sounds.SoundMiddle4;
	import assets.sounds.SoundSmall1;
	import assets.sounds.SoundSmall2;
	import assets.sounds.SoundSmall3;
	import assets.sounds.SoundSmall4;
	import com.flashgangsta.utils.ArrayMixer;
	import com.flashgangsta.utils.StringUtil;
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.getDefinitionByName;
	
	/**
	 * ...
	 * @author Sergey Krivtsov (flashgangsta@gmail.com)
	 */
	
	public class SoundManager {
		static public const COLLISION_SOUNDS_NUM:int = 4;
		
		static private var instance:SoundManager;
		
		private var bgSound:BackgroundSound = new BackgroundSound();
		private var bgSoundChannel:SoundChannel;
		
		/**
		 *
		 */
		
		public function SoundManager() {
			if (!instance) {
				instance = this;
				init();
				SoundSmall1;
			SoundSmall2;
			SoundSmall3;
			SoundSmall4;
			SoundMiddle1;
			SoundMiddle2;
			SoundMiddle3;
			SoundMiddle4;
			SoundBig1;
			SoundBig2;
			SoundBig3;
			SoundBig4;
			} else {
				throw new Error("SoundManager is singletone. Use static funtion getInstance() for get an instance of class");
			}
		}
		
		/**
		 *
		 */
		
		static public function getInstance():SoundManager {
			if (!instance) {
				instance = new SoundManager();
			}
			return instance;
		}
		
		/**
		 *
		 */
		
		private function init():void {
			playBgSoundLoop();
		}
		
		private function playBgSoundLoop(event:Event = null):void {
			if(bgSoundChannel && bgSoundChannel.hasEventListener(Event.SOUND_COMPLETE)) {
				bgSoundChannel.removeEventListener(Event.SOUND_COMPLETE, playBgSoundLoop);
			}
			bgSoundChannel = bgSound.play();
			bgSoundChannel.addEventListener(Event.SOUND_COMPLETE, playBgSoundLoop);
		}
		
		public function generateSound(xPrecent:Number, yPrecent:Number):void {
		
		}
		
		public function playCollisionSound(sizeType:String):void {
			const soundClassPrefix:String = "Sound" + StringUtil.getStringWithCapitalLetter(sizeType);
			const mixedArray:Array =  ArrayMixer.getMixedNumbersArray(1, COLLISION_SOUNDS_NUM);
			const randomNumber:Number = Math.round(Math.random() * (COLLISION_SOUNDS_NUM - 1));
			const soundClassName:String = soundClassPrefix + mixedArray[randomNumber];
			const soundClass:Class = getDefinitionByName("assets.sounds." + soundClassName) as Class;
			const sound:Sound = new soundClass() as Sound;
			const channel:SoundChannel = sound.play();
		}
	
	}

}