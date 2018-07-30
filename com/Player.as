package com
{
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.display.Stage;

	public class Player extends Sprite
	{
		private var _boundWidth:Number;
		private var _boundHeight:Number;

		private var _playerSpeed:int = 6;

		private var _leftmove:Boolean = false;
		private var _rightmove:Boolean = false;
		private var _upmove:Boolean = false;
		private var _downmove:Boolean = false;

		private var _player:MovieClip;
		private var _stage: Stage;

		public function Player(_boundWidth: Number, _boundHeight: Number, _stage:Stage)
		{
			this._player = new player_mc();
			this.addChild(this._player);
			
			this._boundWidth = _boundWidth;
			this._boundHeight = _boundHeight;
			this._stage = _stage;

			this.x = _boundWidth / 2;
			this.y = _boundHeight - this._player.height;

			this.addEventListener(Event.ENTER_FRAME, this.onPlayerMove);
			this._stage.addEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownEvent);
			this._stage.addEventListener(KeyboardEvent.KEY_UP, this.onKeyUpEvent);
		}
		
		public function get playerWidth():Number{
			return this._player.width;
		}
		
		public function get playerHeight():Number{
			return this._player.height;
		}

		private function onKeyDownEvent(e:KeyboardEvent):void
		{
			//left arrow
			if (e.keyCode == 37)
			{
				this._leftmove = true;
			}
			//up arrow
			if (e.keyCode == 38)
			{
				this._upmove = true;
			}
			//right arrow
			if (e.keyCode == 39)
			{
				this._rightmove = true;
			}
			//down arrow
			if (e.keyCode == 40)
			{
				this._downmove = true;
			}
		}

		private function onKeyUpEvent(e:KeyboardEvent):void
		{
			//left arrow
			if (e.keyCode == 37)
			{
				this._leftmove = false;
			}
			//up arrow
			if (e.keyCode == 38)
			{
				this._upmove = false;
			}
			//right arrow
			if (e.keyCode == 39)
			{
				this._rightmove = false;
			}
			//down arrow
			if (e.keyCode == 40)
			{
				this._downmove = false;
			}
		}

		private function onPlayerMove(e:Event):void
		{
			if (this.x>=0 && (this._player.x<=this._boundWidth-this._player.width/2))
			{
				if (this._leftmove)
				{
					this.x -=  this._playerSpeed;
				}
				if (this._rightmove)
				{
					this.x +=  this._playerSpeed;
				}
			}

			if (this._player.y>=0 && (this._player.y<=this._boundHeight-this._player.height/2))
			{
				if (this._upmove)
				{
					this.y -=  this._playerSpeed;
				}
				if (this._downmove)
				{
					this.y +=  this._playerSpeed;
				}
			}

			if (this.x <= this._player.width / 2)
			{
				this.x = this._player.width / 2;
			}
			if (this.x >= this._boundWidth - this._player.width / 2)
			{
				this.x = this._boundWidth - this._player.width / 2;
			}
			if (this.y <= this._player.height / 2)
			{
				this.y = this._player.height / 2;
			}
			if (this.y >= this._boundHeight - this._player.height / 2)
			{
				this.y = this._boundHeight - this._player.height / 2;
			}
		}
		
		public function destroy(): void {
			this.removeEventListener(Event.ENTER_FRAME, this.onPlayerMove);
			this._stage.removeEventListener(KeyboardEvent.KEY_DOWN, this.onKeyDownEvent);
			this._stage.removeEventListener(KeyboardEvent.KEY_UP, this.onKeyUpEvent);
			this.removeChild(this._player);
			this._player = null;
			this._stage = null;
		}
	}
}