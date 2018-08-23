package com
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Stage;

	public class BossEnemy extends Sprite
	{
		private var _bossEnemy_mc:MovieClip;
		private var _callBack:Function;
		private var _stage:Stage;
		private var _bulletHolder:Sprite;

		private var _speed:int = 3;
		private var _lifeCount:int = 4;

		public function BossEnemy(_stage: Stage, _bulletHolder:Sprite, _callback:Function)
		{
			this._bossEnemy_mc = new bossenemy_mc();
			this.addChild(this._bossEnemy_mc);

			this._stage = _stage;
			this._callBack = _callback;
			this._bulletHolder = _bulletHolder;

			this.x = Math.random() * (this._stage.stageWidth - this._bossEnemy_mc.height);
			this.y = -1 * this._bossEnemy_mc.height;

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
				if (_bullet && this.hitTestObject(_bullet))
				{
					this._callBack(this);
				}
			}
		}

		public function destroy()
		{
			if (this._lifeCount > 0)
			{
				this._lifeCount--;
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, this.onEnter);
				if (this._bossEnemy_mc)
				{
					this.removeChild(this._bossEnemy_mc);
					this._bossEnemy_mc = null;
					this._callBack = null;
					this._lifeCount = 4;
				}
			}

		}

	}

}