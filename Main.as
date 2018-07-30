package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import com.GamePlay;
	import com.GameOver;
	import com.Score;

	public class Main extends Sprite
	{
		private var _gamePlay:GamePlay;
		private var _gameOver:GameOver;
		private var _score:Score;

		public function Main()
		{
			// constructor code
			this._gamePlay = null;
			this._gameOver = null;
			this._score = null;
			this.initGame();
		}

		private function initGame():void
		{
			this._gamePlay = new GamePlay(stage.stageWidth,stage.stageHeight,stage);
			this.addChild(this._gamePlay);
			
			this._gamePlay.addEventListener('GAME_OVER', this.onGameOver);
			this._gamePlay.addEventListener('INCREMENT_SCORE', this.updateScore);

			this._score = new Score();
			this.addChild(this._score);
		}

		private function updateScore(e:Event):void
		{
			this._score.updateScore();
		}

		private function onGameOver(e:Event):void
		{
			var _latestScore:int = this._score.getUpdatedScore();
			this._score.destroy();
			this._gamePlay.removeEventListener('GAME_OVER', this.onGameOver);
			this._gamePlay.removeEventListener('INCREMENT_SCORE', this.updateScore);
			this.removeChild(this._gamePlay);
			this.removeChild(this._score);
			this._gamePlay = null;
			this._score = null;

			this._gameOver = new GameOver(_latestScore);
			this._gameOver.addEventListener('GAME_START', this.onGameStarts);
			this.addChild(this._gameOver);
		}

		private function onGameStarts(e:Event):void
		{
			this._gameOver.removeEventListener('GAME_START', this.onGameStarts);
			this.removeChild(this._gameOver);
			this._gameOver = null;

			this.initGame();
		}
	}
}