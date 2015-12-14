package;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Tipyx
 */
class Main extends hxd.App {
	static var num					= 0;
	public static var DM_GAME		= num++;
	public static var DM_FX			= num++;
	public static var DM_GAMEOVER	= num++;
	
	public static var ME			: Main;
	
	var game						: Game;
	var home						: Home;
	var gameOver					: GameOver;
	
	public var tweener				: mt.motion.Tweener;
	
	override function init() {
		ME = this;
		
		Settings.INIT();
		SoundManager.INIT();
		FX.INIT();
		
		SoundManager.MUSIC();
		
		tweener = new mt.motion.Tweener();
		
	// INIT GAME
		#if debug
			launchGame();
		#else
		home = new Home();
		s2d.addChild(home);
		#end
	}
	
	public function launchGame() {
		FX.FADE(0, 1, 30, function() {
			if (home != null)
				home.destroy();
			home = null;
			
			FX.FADE(1, 0, 30);
			
			game = new Game();
			s2d.add(game, DM_GAME);
		});
	}
	
	public function resetGame() {
		FX.FADE(FX.BG_FADE.alpha, 1, 10, function() {
			if (gameOver != null)
				gameOver.destroy();
			gameOver = null;
			
			game.remove();
			game.destroy();
			
			FX.FADE(1, 0, 30);
			
			game = new Game();
			s2d.addChild(game);
		});
	}
	
	public function showGameOver() {
		gameOver = new GameOver();
		s2d.add(gameOver, DM_GAMEOVER);
	}
	
	var c = 0;
	
	override function update(dt:Float) {
		tweener.update();
		
		if (hxd.Key.isDown(hxd.Key.A)) {
			if (c == 30)
				c = 0;
			c++;
		}
		else
			c = 30;
		
		if (c % 30 == 0) {
			if (gameOver != null)
				gameOver.update();
			
			if (home != null)
				home.update();
			
			if (game != null) {
				game.update();
				
				if (hxd.Key.isReleased(hxd.Key.BACKSPACE)) {
					resetGame();
				}
			}
			
			FX.UPDATE();
			
			super.update(dt);
		}
	}
	
	static function main() {
		hxd.Res.initEmbed();
		
		DCDB.load(hxd.Res.data.entry.getBytes().toString());
		
		new Main();
	}
	
}