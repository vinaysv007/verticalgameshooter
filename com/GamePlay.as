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

		private var _enemyDelay:int = 2000;
		private var _bossEnemyDelay:int = 8000;

		private var _player:Player;
		private var _enemyTimer:Timer;
		private var _bossEnemyTimer:Timer;

		private var _gameOver:Boolean;

		private var _playerLifeCount:int = 0;

		public function GamePlay(_boundWidth: Number, _boundHeight: Number, _stage:Stage)
		{
			var _enemyHolder: Sprite = new Sprite();
			_enemyHolder.name = "_enemyHolder";
			this.addChild(_enemyHolder);

			var _enemyBulletHolder: Sprite = new Sprite();
			_enemyBulletHolder.name = "_enemyBulletHolder";
			this.addChild(_enemyBulletHolder);

			var _bulletHolder: Sprite = new Sprite();
			_bulletHolder.name = "_bulletHolder";
			this.addChild(_bulletHolder);

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

			this._bossEnemyTimer = new Timer(this._bossEnemyDelay);
			this._bossEnemyTimer.addEventListener(TimerEvent.TIMER, this.bossEnemyTimerListener);
			this._bossEnemyTimer.start();
		}

		private function enemyTimerListener(e:TimerEvent):void
		{
			if (! this._gameOver)
			{
				var _bulletHolder:Sprite = this.getChildByName("_bulletHolder") as Sprite;
				var _enemyHolder:Sprite = this.getChildByName("_enemyHolder") as Sprite;
				var _enemyBulletHolder:Sprite = this.getChildByName("_enemyBulletHolder") as Sprite;
				var _enemy:Enemy = new Enemy(this._stage,_bulletHolder,_callback);
				_enemyHolder.addChild(_enemy);
				_enemy.startTrigger();
				var _this:Object = this;
				function _callback(_enemy_mc, _bullet=null, _incScore: Boolean = false)
				{
					if (_incScore)
					{
						_this.dispatchEvent(new Event('INCREMENT_SCORE'));
					}
					_enemy_mc.destroy();
					_enemyHolder.removeChild(_enemy_mc);
					_enemy_mc = null;

					if (_bullet)
					{
						_bullet.destroy();
						_bulletHolder.removeChild(_bullet);
						_bullet = null;
					}
				}
			}
		}

		private function bossEnemyTimerListener(e:TimerEvent):void
		{
			if (this._gameOver)
			{
				return;
			}

			var _bulletHolder:Sprite = this.getChildByName("_bulletHolder") as Sprite;
			var _enemyHolder:Sprite = this.getChildByName("_enemyHolder") as Sprite;
			var _bossEnemy:BossEnemy = new BossEnemy(this._stage,_bulletHolder,_callback,_removeBullet);
			_enemyHolder.addChild(_bossEnemy);
			_bossEnemy.startTrigger();
			function _removeBullet(_bullet)
			{
				if (_bullet)
				{
					_bullet.destroy();
					_bulletHolder.removeChild(_bullet);
					_bullet = null;
				}
			}
			var _this:Object = this;
			function _callback(_bossEnemy, _bullet=null, _incScore: Boolean = false)
			{
				if (_incScore)
				{
					_this.dispatchEvent(new Event('INCREMENT_SCORE'));
				}
				_bossEnemy.destroy();
				_enemyHolder.removeChild(_bossEnemy);
				_bossEnemy = null;

				if (_bullet)
				{
					_bullet.destroy();
					_bulletHolder.removeChild(_bullet);
					_bullet = null;
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
				var _enemy;
				if (_enemyHolder.getChildAt(i) is Enemy)
				{
					_enemy = _enemyHolder.getChildAt(i) as Enemy;

				}
				else if (_enemyHolder.getChildAt(i) is EnemyBullet)
				{
					_enemy = _enemyHolder.getChildAt(i) as EnemyBullet;
				}
				else if (_enemyHolder.getChildAt(i) is BossEnemy)
				{
					_enemy = _enemyHolder.getChildAt(i) as BossEnemy;
				}
				if (_enemy)
				{
					if (this._player && this._player.hitTestObject(_enemy))
					{
						_enemy.destroy();
						this.checkPlayerLife();
					}
				}
			}
		}

		private function checkPlayerLife():void
		{
			if (this._playerLifeCount < Config.LIFE - 1)
			{
				this._playerLifeCount++;
				this.dispatchEvent(new Event('DECREMENT_LIFE'));
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME, this.onBulletLifeCount);
				this.gameOver();
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