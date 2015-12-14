package;

import h2d.Layers;

/**
 * ...
 * @author Tipyx
 */
class GameOver extends Layers
{
	var keyEnable			: Bool;
	
	var gameOverTxt			: h2d.Text;
	var metersTxt			: h2d.Text;
	var roomsTxt			: h2d.Text;
	var trapsTxt			: h2d.Text;
	var pressUpText			: h2d.Text;
	var pressDownText		: h2d.Text;
	var creditsText			: h2d.Text;

	public function new() 
	{
		super();
		
		Settings.SHOW_TUTO = false;
		
		keyEnable = false;
		
		var game = Game.ME;
		
		var t  : mt.motion.Tween = Main.ME.tweener.create();
		
		gameOverTxt = new h2d.Text(Settings.FONT_8, this);
		gameOverTxt.text = "Game Over !";
		gameOverTxt.maxWidth = Settings.STAGE_WIDTH;
		gameOverTxt.textAlign = Center;
		gameOverTxt.y = Std.int(Settings.STAGE_HEIGHT * 0.1);
		gameOverTxt.alpha = 0;
		
		t.to(10, gameOverTxt.alpha = 1);
		t.delay(5);
		
		metersTxt = new h2d.Text(Settings.FONT_2, this);
		metersTxt.text = Std.int(game.maxDist) + " meters covered";
		metersTxt.maxWidth = Settings.STAGE_WIDTH;
		metersTxt.textAlign = Center;
		metersTxt.y = Std.int(Settings.STAGE_HEIGHT * 0.4);
		metersTxt.alpha = 0;
		
		t.to(10, metersTxt.alpha = 1);
		t.delay(5);
		
		roomsTxt = new h2d.Text(Settings.FONT_2, this);
		roomsTxt.text = game.hero.arRoomDone.length + " room" + (game.hero.arRoomDone.length > 1 ? "s" : "") + " visited";
		roomsTxt.maxWidth = Settings.STAGE_WIDTH;
		roomsTxt.textAlign = Center;
		roomsTxt.y = Std.int(Settings.STAGE_HEIGHT * 0.45);
		roomsTxt.alpha = 0;
		
		t.to(10, roomsTxt.alpha = 1);
		t.delay(5);
		
		trapsTxt = new h2d.Text(Settings.FONT_2, this);
		trapsTxt.text = game.hero.trapsHit + " trap" + (game.hero.trapsHit > 1 ? "s" : "") + " hit";
		trapsTxt.maxWidth = Settings.STAGE_WIDTH;
		trapsTxt.textAlign = Center;
		trapsTxt.y = Std.int(Settings.STAGE_HEIGHT * 0.5);
		trapsTxt.alpha = 0;
		
		t.to(10, trapsTxt.alpha = 1);
		t.delay(10);
		
		pressUpText = new h2d.Text(Settings.FONT_2, this);
		pressUpText.text = "Press UP to tweet your score!";
		pressUpText.maxWidth = Settings.STAGE_WIDTH;
		pressUpText.textAlign = Center;
		pressUpText.y = Std.int(Settings.STAGE_HEIGHT * 0.7);
		pressUpText.alpha = 0;
		
		t.to(10, pressUpText.alpha = 1).onComplete = function () {
			keyEnable = true;
		};
		t.delay(5);
		
		pressDownText = new h2d.Text(Settings.FONT_2, this);
		pressDownText.text = "Press DOWN to retry!";
		pressDownText.maxWidth = Settings.STAGE_WIDTH;
		pressDownText.textAlign = Center;
		pressDownText.y = Std.int(Settings.STAGE_HEIGHT * 0.75);
		pressDownText.alpha = 0;
		
		t.to(10, pressDownText.alpha = 1);
		
		creditsText = new h2d.Text(Settings.FONT_2, this);
		creditsText.text = "Code : @Tipyx_FR - Art : @Sentsu_Actu";
		creditsText.x = Std.int(Settings.STAGE_WIDTH - creditsText.textWidth - 10);
		creditsText.y = Std.int(Settings.STAGE_HEIGHT - creditsText.textHeight - 10);
		creditsText.alpha = 0;
		
		t.to(10, creditsText.alpha = 1);
	}
	
	public function destroy() {
		gameOverTxt.remove();
		metersTxt.remove();
		roomsTxt.remove();
		trapsTxt.remove();
		pressUpText.remove();
		pressDownText.remove();
		creditsText.remove();
		
		super.remove();
	}
	
	public function update() {
		if (keyEnable) {
			if (hxd.Key.isReleased(hxd.Key.UP)) {
				flash.Lib.getURL(new flash.net.URLRequest("http://twitter.com/home?status=I made " + Std.int(Game.ME.maxDist) + " meters at 'Mystic Door', the %23LDJam %23LD34 game by @Tipyx_FR and @Sentsu_actu ! Play it ! Share it ! Rate it ! %23gamedev"));
			}
			else if (hxd.Key.isReleased(hxd.Key.DOWN)) {
				keyEnable = false;
				Main.ME.tweener.create().to(10, gameOverTxt.alpha = 0, metersTxt.alpha = 0, roomsTxt.alpha = 0, trapsTxt.alpha = 0, pressUpText.alpha = 0, pressDownText.alpha = 0, creditsText.alpha = 0).onComplete = function () {
					Main.ME.resetGame();					
				}
			}			
		}
	}
}