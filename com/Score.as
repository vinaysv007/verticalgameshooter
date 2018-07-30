package com
{
	import flash.display.Sprite;
	import flash.display.MovieClip;

	public class Score extends Sprite
	{
		private var _score_mc: MovieClip;
		
		private var _score:int;
		
		public function Score()
		{
			// constructor code
			this._score_mc = new score_mc();
			this.addChild(this._score_mc);
			
			this._score = 0;
			this._score_mc.score_txt.text = "SCORE: " + String(this._score);
		}
		
		public function updateScore() {
			this._score++;
			this._score_mc.score_txt.text = "SCORE: " + String(this._score);
		}
		
		public function getUpdatedScore(): int {
			return this._score;
		}
		
		public function destroy(): void {
			this.removeChild(this._score_mc);
			this._score_mc = null;
		}

	}

}