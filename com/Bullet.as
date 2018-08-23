package com
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;

	public class Bullet extends Sprite
	{
		private var _bullet_mc:MovieClip;
		private var _callBack:Function;
		private var _speed: int = 6;

		public function Bullet(callback: Function)
		{
			// constructor code
			this._callBack = callback;
			this._bullet_mc = new bullet_mc();
			this.addChild(this._bullet_mc);
			this.addEventListener(Event.ENTER_FRAME, this.onBulletAction);
		}

		private function onBulletAction(e:Event):void
		{
			this.y -=  this._speed;
			if (this.y < -1)
			{
				this._callBack(this);
			}
		}

		public function destroy()
		{
			this.removeEventListener(Event.ENTER_FRAME, this.onBulletAction);
			if (this._bullet_mc)
			{
				this.removeChild(this._bullet_mc);
				this._bullet_mc = null;
				this._callBack = null;
			}
		}

	}

}