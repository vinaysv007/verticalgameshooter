package com
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Stage;

	public class Enemy extends Sprite
	{
		private var _enemy_mc:MovieClip;
		private var _callBack:Function;
		private var _stage:Stage;
		private var _bulletHolder:Sprite;

		private var _speed:int = 3;

		public function Enemy(_stage: Stage, _bulletHolder:Sprite, _callback:Function)
		{
			// constructor code
			this._enemy_mc = new enemy_mc();
			this.addChild(this._enemy_mc);

			this._callBack = _callback;
			this._stage = _stage;
			this._bulletHolder = _bulletHolder;

			this.x = Math.random() * (this._stage.stageWidth - this._enemy_mc.height);
			this.y = -1 * this._enemy_mc.height;

			this.addEventListener(Event.ENTER_FRAME, this.onEnter);

		}

		private function onEnter(e:Event):void
		{
			this.y +=  this._speed;
			if (this.y > this._stage.stageHeight)
			{
				this._callBack(this);
			}

			//check if enemy hit by bullet
			for (var i:int = 0; i<this._bulletHolder.numChildren; i++)
			{
				var _bullet:Bullet = this._bulletHolder.getChildAt(i) as Bullet;
				if (this.hitTestObject(_bullet))
				{
					this._callBack(this);
				}
			}
		}

		public function destroy()
		{
			this.removeEventListener(Event.ENTER_FRAME, this.onEnter);
			if (this._enemy_mc)
			{
				this.removeChild(this._enemy_mc);
				this._enemy_mc = null;
				this._callBack = null;
			}
		}

	}

}