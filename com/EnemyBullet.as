package com
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Stage;

	public class EnemyBullet extends Sprite
	{
		private var _bullet:MovieClip;
		private var _bullet_speed:int = 4;
		private var _callBack:Function;
		private var _stage: Stage;

		public function EnemyBullet(_stage: Stage, _callback:Function)
		{
			// constructor code
			this._bullet = new enemybullet_mc();
			this.addChild(this._bullet);
			
			this._callBack = _callback;
			this._stage = _stage;

			this.addEventListener(Event.ENTER_FRAME, this.onEnter);
		}

		private function onEnter(e:Event):void
		{
			this.y +=  this._bullet_speed;

			if (this.y > this._stage.stageHeight)
			{
				this.removeEventListener(Event.ENTER_FRAME, this.onEnter);
				this._callBack(this);
			}
		}
		
		public function destroy(): void {
			this.removeEventListener(Event.ENTER_FRAME, this.onEnter);
			this.removeChild(this._bullet);
			this._bullet = null;
		}

	}

}