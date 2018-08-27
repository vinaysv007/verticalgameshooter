package com
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class Enemy extends Sprite
	{
		private var _enemy_mc:MovieClip;
		private var _callBack:Function;
		private var _stage:Stage;
		private var _bulletHolder:Sprite;

		private var _speed:int = 2;
		private var _canTrigger:Boolean = true;
		private var _waitTimer:Timer;

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
		}

		public function startTrigger():void
		{
			this.addEventListener(Event.ENTER_FRAME, this.onEnter);
		}

		private function startWaitTimer():void
		{
			this._waitTimer = new Timer(1000,1);
			this._waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.onWaitTimerComplete1);
			this._waitTimer.start();
		}

		private function onWaitTimerComplete1(e: TimerEvent):void
		{
			if (this._waitTimer)
			{
				this._waitTimer.stop();
				this._waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onWaitTimerComplete1);
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
					this._callBack(this, _bullet, true);
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

			if (this._waitTimer)
			{
				this._waitTimer.stop();
				this._waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, this.onWaitTimerComplete1);
				this._waitTimer = null;
			}
		}

	}

}