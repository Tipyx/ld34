package;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Tipyx
 */
class Main  extends hxd.App {
	public static var ME			: Main;
	
	var game						: Game;
	
	override function init() {
		ME = this;
		
		Settings.INIT();
		
		game = new Game();
		s2d.addChild(game);
	}
	
	var c = 0;
	
	override function update(dt:Float) {
		if (hxd.Key.isDown(hxd.Key.A)) {
			if (c == 30)
				c = 0;
			c++;
		}
		else
			c = 30;
		
		if (c % 30 == 0) {
			game.update();
			
			super.update(dt);
			
			if (hxd.Key.isPressed(hxd.Key.BACKSPACE)) {
				game.remove();
				game.destroy();
				
				game = new Game();
				s2d.addChild(game);
			}			
		}
	}
	
	static function main() {
		hxd.Res.initEmbed();
		
		DCDB.load(hxd.Res.data.entry.getBytes().toString());
		
		new Main();
	}
	
}