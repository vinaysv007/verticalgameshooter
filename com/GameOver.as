package com
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;

	public class GameOver extends Sprite
	{
		private var _gameover_mc:MovieClip;

		public function GameOver(_score: int)
		{
			this._gameover_mc = new gameover_mc();
			this.addChild(this._gameover_mc);
			this._gameover_mc.score_txt.text = "SCORE: " + String(_score);

			this._gameover_mc.playbtn.addEventListener(MouseEvent.CLICK, this.onPlayClicked);
		}

		public function destroy():void
		{
			this.removeChild(this._gameover_mc);
			this._gameover_mc = null;
		}

		private function onPlayClicked(e:MouseEvent):void
		{
			this._gameover_mc.playbtn.removeEventListener(MouseEvent.CLICK, this.onPlayClicked);
			this.dispatchEvent(new Event('GAME_START'));
		}

	}

}