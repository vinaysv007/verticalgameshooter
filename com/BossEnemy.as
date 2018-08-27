package com
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class BossEnemy extends Sprite
	{
		private var _bossEnemy_mc:MovieClip;
		private var _callBack:Function;
		private var _removeBullet:Function;
		private var _callbackLifeCount:Function;
		private var _stage:Stage;
		private var _bulletHolder:Sprite;

		private var _lifeDecreseDelay:int = 5;
		private var _lifeDecreseDelayCount:int = 0;

		private var _speed:int = 2;
		private var _lifeCount:int = 4;

		private var _canDecraeseLife: Boolean = true;
		private var _canTrigger:Boolean = true;
		private var _waitTimer:Timer;

		public function BossEnemy(_stage: Stage, _bulletHolder:Sprite, _callback:Function, _removeBullet: Function)
		{
			this._bossEnemy_mc = new bossenemy_mc();
			this.addChild(this._bossEnemy_mc);

			this._stage = _stage;
			this._callBack = _callback;
			this._removeBullet = _removeBullet;
			this._callbackLifeCount = _callbackLifeCount;
			this._bulletHolder = _bulletHolder;

			this.x = Math.random() * (this._stage.stageWidth - this._bossEnemy_mc.height);
			this.y = -1 * this._bossEnemy_mc.height;
		}

		public function startTrigger():void
		{
			this.addEventListener(Event.ENTER_FRAME, this.onEnter);
		}

		private function startWaitTimer():void
		{
			this._waitTimer = new Timer(1000,1);
			this._waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onWaitTimerComplete);
			this._waitTimer.start();
		}

		private function onWaitTimerComplete(e: TimerEvent):void
		{
			if (this._waitTimer)
			{
				this._waitTimer.stop();
				this._waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onWaitTimerComplete);
				this._waitTimer = null;
				this._canTrigger = true;
			}
		}

		private function onEnter(e:Event):void
		{
			this.y +=  this._speed;

			if (this.y > 10 && this._canTrigger)
			{
				this._canTrigger = false;
				this.startWaitTimer();
				var _ebullet:EnemyBullet = new EnemyBullet(this._stage,_callback);
				this.parent.addChild(_ebullet);
				_ebullet.x = this.x;
				_ebullet.y = this.y;

				function _callback(_ebullet_mc)
				{
					_ebullet_mc.destroy();
					this.parent.removeChild(_ebullet_mc);
					_ebullet_mc = null;
				}
				this.startWaitTimer();
			}

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
					this.decreseLife(_bullet);
				}
			}

			if (this._lifeDecreseDelayCount < this._lifeDecreseDelay)
			{
				this._lifeDecreseDelayCount++;
			}
			else
			{
				this._canDecraeseLife = true;
				this._lifeDecreseDelayCount = 0;
			}
		}

		private function decreseLife(_bullet: Bullet):void
		{
			if (this._lifeCount > 0)
			{
				if (this._canDecraeseLife)
				{
					this._canDecraeseLife = false;
					this._lifeCount--;
					this._removeBullet(_bullet);
				}
			}
			else
			{
				this._callBack(this, _bullet, true);
			}
		}

		public function destroy()
		{
			this.removeEventListener(Event.ENTER_FRAME, this.onEnter);
			if (this._bossEnemy_mc)
			{
				this.removeChild(this._bossEnemy_mc);
				this._bossEnemy_mc = null;
				this._callBack = null;
				this._lifeCount = 4;
			}
			if (this._waitTimer)
			{
				this._waitTimer.stop();
				this._waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onWaitTimerComplete);
				this._waitTimer = null;
			}
		}

	}
}