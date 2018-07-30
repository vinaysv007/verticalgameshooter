package com
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;

	public class GamePlay extends Sprite
	{
		private var _canBulletTrigger:Boolean;
		private var _stage:Stage;

		private var _bulletDelay:int = 20;
		private var _bulletDelayCount:int = 0;

		private var _enemyDelay:int = 1000;

		private var _player:Player;
		private var _enemyTimer:Timer;

		private var _gameOver:Boolean;

		public function GamePlay(_boundWidth: Number, _boundHeight: Number, _stage:Stage)
		{
			var _bulletHolder: Sprite = new Sprite();
			_bulletHolder.name = "_bulletHolder";
			this.addChild(_bulletHolder);

			var _enemyHolder: Sprite = new Sprite();
			_enemyHolder.name = "_enemyHolder";
			this.addChild(_enemyHolder);

			//this._enemyHolder = [];
			this._bulletDelayCount = 0;

			this._player = new Player(_boundWidth,_boundHeight,_stage);
			this.addChild(this._player);

			this._stage = _stage;
			this._canBulletTrigger = true;
			this._gameOver = false;

			this._stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownEvent);
			this.addEventListener(Event.ENTER_FRAME, this.onBulletLifeCount);

			this.enemyCreation();
		}

		private function enemyCreation():void
		{
			this._enemyTimer = new Timer(this._enemyDelay);
			this._enemyTimer.addEventListener(TimerEvent.TIMER, this.enemyTimerListener);
			this._enemyTimer.start();
		}

		private function enemyTimerListener(e:TimerEvent):void
		{
			if (! this._gameOver)
			{
				var _bulletHolder:Sprite = this.getChildByName("_bulletHolder") as Sprite;
				var _enemyHolder:Sprite = this.getChildByName("_enemyHolder") as Sprite;
				var _enemy:Enemy = new Enemy(this._stage,_bulletHolder,_callback);
				_enemyHolder.addChild(_enemy);
				//this._enemyHolder.push(_enemy);
				var _this:Object = this;
				function _callback(_enemy_mc)
				{
					_this.dispatchEvent(new Event('INCREMENT_SCORE'));
					_enemy_mc.destroy();
					_enemyHolder.removeChild(_enemy_mc);
					_enemy_mc = null;
				}
			}
		}

		private function onKeyDownEvent(e:KeyboardEvent):void
		{
			if (e.keyCode == 32 && ! this._gameOver && this._canBulletTrigger)
			{
				this._canBulletTrigger = false;

				//create bullet
				var _bulletHolder:Sprite = this.getChildByName("_bulletHolder") as Sprite;

				var _bullet:Bullet = new Bullet(_callBack);
				_bullet.x = this._player.x;
				_bullet.y = this._player.y - this._player.playerHeight / 2;
				_bulletHolder.addChild(_bullet);

				function _callBack(_bullet_mc)
				{
					_bullet_mc.destroy();
					_bulletHolder.removeChild(_bullet_mc);
					_bullet_mc = null;
				}
			}
		}

		private function onBulletLifeCount(e:Event):void
		{
			if (this._gameOver)
			{
				return;
			}

			//bullet enable
			if (this._bulletDelayCount < this._bulletDelay)
			{
				this._bulletDelayCount++;
			}
			else
			{
				this._canBulletTrigger = true;
				this._bulletDelayCount = 0;
			}

			//check if enemy hits player
			var _enemyHolder:Sprite = this.getChildByName("_enemyHolder") as Sprite;
			for (var i:int = 0; i<_enemyHolder.numChildren; i++)
			{
				var _enemy:Enemy = _enemyHolder.getChildAt(i) as Enemy;
				if (this._player && this._player.hitTestObject(_enemy))
				{
					this.removeEventListener(Event.ENTER_FRAME, this.onBulletLifeCount);
					this.gameOver();
				}
			}

		}

		private function gameOver():void
		{
			this._gameOver = true;
			this._player.destroy();
			this.removeEventListener(Event.ENTER_FRAME, this.onBulletLifeCount);
			this._stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownEvent);

			this._enemyTimer.stop();
			this._enemyTimer.removeEventListener(TimerEvent.TIMER, this.enemyTimerListener);
			this._enemyTimer = null;

			var _enemyHolder:Sprite = this.getChildByName("_enemyHolder") as Sprite;
			for (var i:int = 0; i<_enemyHolder.numChildren; i++)
			{
				var _enemy_mc:Enemy = _enemyHolder.getChildAt(j) as Enemy;
				if (_enemy_mc)
				{
					_enemy_mc.destroy();
					_enemyHolder.removeChild(_enemy_mc);
				}
				_enemy_mc = null;
			}

			var _bulletHolder:Sprite = this.getChildByName("_bulletHolder") as Sprite;
			for (var j:int = 0; j<_bulletHolder.numChildren; j++)
			{
				var _bullet_mc:Bullet = _bulletHolder.getChildAt(j) as Bullet;
				if (_bullet_mc)
				{
					_bullet_mc.destroy();
					_bulletHolder.removeChild(_bullet_mc);
				}
				_bullet_mc = null;
			}

			this.removeChild(_bulletHolder);
			this.removeChild(this._player);
			this._player = null;
			this._stage = null;
			_bulletHolder = null;
			_enemyHolder = null;

			this.dispatchEvent(new Event('GAME_OVER'));
		}

	}

}