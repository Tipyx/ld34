package;

/**
 * ...
 * @author Tipyx
 */

class Game extends h2d.Layers
{
	public static var SCALE_GAME		= 3;
	public static var MAX_SPEED_PLANT	= 6;
	public static var ME			: Game;
	
	static var num					= 0;
	public static var DM_BG			= num++;
	public static var DM_ROOM		= num++;
	
	public var cIngame				: h2d.Layers;
	public var ui					: UIGame;
	public var hero					: Hero;
	var boss:Boss;
	
	public var arRoom				: Array<Room>;
	
	var roomUnder					: Room;
	
	var lm							: LevelManager;
	
	public var maxDist				: Float;
	public var distEnd				: Float;
	var speedPlant					: Float;
	var gameIsEndend				: Bool;

	public function new() {
		super();
		
		ME = this;
		
		cIngame = new h2d.Layers();
		cIngame.scaleX = cIngame.scaleY = SCALE_GAME;
		this.addChild(cIngame);
		
		ui = new UIGame();
		this.addChild(ui);
		
		boss = new Boss();
		//boss.x = -60 * SCALE_GAME;
		boss.y = Std.int(Settings.STAGE_HEIGHT * 0.5);
		boss.scaleX = boss.scaleY = SCALE_GAME;
		this.addChild(boss);
		
		hero = new Hero();
		hero.dX = Hero.MAX_SPEED * 0.5;
		
		arRoom = [];
		
		lm = new LevelManager();
		
		gameIsEndend = false;
		
		lm.init();
		init();
		
		// FILTER
		//var bd = new hxd.BitmapData(Std.int(Settings.STAGE_WIDTH / SCALE_GAME), Std.int(Settings.STAGE_HEIGHT/ SCALE_GAME));
		//bd.lock();
		//for (i in 0...bd.width) {
			//for (j in 0...bd.height) {
				//if (j % 4 == 0)
					//bd.setPixel(i, j, 0x22000000);
				//else if (j % 4 == 1)
					//bd.setPixel(i, j, 0x22FFFFFF);
			//}
		//}
		//bd.unlock();
		//
		//var bmp = new h2d.Bitmap(h2d.Tile.fromBitmap(bd), this);
		//bmp.scaleX = bmp.scaleY = SCALE_GAME;
	}
	
	function init() {
		#if debug
		distEnd = 1000;
		#else
		distEnd = 100;
		#end
		maxDist = 0;
		speedPlant = 2;
		
		arRoom[0].load(hero, false);
		hero.setCoord(40, arRoom[0].hei);
		//hero.setCoord(50, arRoom[0].hei);
		
		cIngame.y = Std.int(Settings.STAGE_HEIGHT * 0.5 - (hero.actualRoom.posY * Settings.HEI_ROOM) * cIngame.scaleY);
		
		FX.SHAKE_CAM(0, 10, 0.95);
	}
	
	public function destroy() {
		for (r in arRoom)
			r.destroy();
			
		hero.destroy();
		
		arRoom = [];
		
		cIngame.remove();
		ui.destroy();
	}
	
	public function moveCamera(r:Room) {
		Main.ME.tweener.create().to(10, cIngame.y = Std.int(Settings.STAGE_HEIGHT * 0.5 - (hero.actualRoom.posY * Settings.HEI_ROOM) * cIngame.scaleY));
	}
	
	function endGame() {
		gameIsEndend = true;
		FX.FADE(0, 0.96, 10, function() { Main.ME.showGameOver(); });
	}
	
	public function update() {
		if (!gameIsEndend) {
			hero.update();
			
			for (r in arRoom.copy()) {
				r.update();
				if (r.x + r.widPix < 0) {
					r.destroy();
					arRoom.remove(r);
				}
			}
				
			lm.update();
			
			// GP END
			
			speedPlant += 0.001;
			if (speedPlant > MAX_SPEED_PLANT)
				speedPlant = MAX_SPEED_PLANT;
			//trace(speedPlant);
			
			maxDist += hero.dX;
			
			distEnd += hero.dX;
			distEnd -= speedPlant;
			
			boss.x = -(distEnd / 2000) * 60 * SCALE_GAME;
			
			if (distEnd <= 0) {
				distEnd = 0;
				endGame();
			}
		}
		
		ui.update();
	}
	
}