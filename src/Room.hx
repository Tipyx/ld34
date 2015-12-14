package;

import h2d.SpriteBatch;

/**
 * ...
 * @author Tipyx
 */
class Room extends h2d.Layers
{
	static var num					= 0;
	//public static var DM_BG			= num++;
	public static var DM_TRAP		= num++;
	public static var DM_HERO		= num++;
	
	var hero						: Hero;
	
	public var initX				: Float;
	public var posY					: Int;
	public var widTile				: Int;
	public var widPix				: Int;
	public var hei					: Int;
	public var arTrap				: Array<Trap>;
	public var genDone				: Bool;
	
	var bm							: SpriteBatch;
	var arBE						: Array<BatchElement>;
	

	public function new(initX:Float, posY:Int, widTile:Int, arTrapData:Array<DCDB.RoomData_traps>) {
		super();
		
		this.initX = initX;
		this.posY = posY;
		this.widTile = widTile;
		this.widPix = widTile * Settings.WID_TILE;
		this.hei = Settings.HEI_ROOM;
		this.arTrap = [];
		this.genDone = false;
		
		hero = Game.ME.hero;
		
		bm = new h2d.SpriteBatch(Settings.SLB.mainTile);
		Game.ME.cIngame.add(bm, Game.DM_BG);
		
		// SET BG
		var group = Settings.SLB.getGroup("bg");
		
		arBE = [];
		
		for (i in 0...widTile) {
			var bg = bm.alloc(group[Std.random(group.length)]);
			bg.x = i * Settings.WID_TILE;
			arBE.push(bg);
		}
		
		// SET WALL
		var leftWall = bm.alloc(Settings.SLB.getTile("wallL"));
		arBE.push(leftWall);
		
		var rightWall = bm.alloc(Settings.SLB.getTile("wallR"));
		rightWall.x = widPix - rightWall.t.width;
		arBE.push(rightWall);
		
		// SET TRAP
		for (t in arTrapData) {
			var trap = new Trap(t.trapType);
			trap.x = t.x;
			arTrap.push(trap);
			this.add(trap, DM_TRAP);
		}
		
		bm.x = this.x = initX;
		bm.y = this.y = posY * Settings.HEI_ROOM;
	}
	
	public function load(hero:Hero, ?moveCam:Bool = true) {
		hero.setActualRoom(this);
		hero.remove();
		this.add(hero, DM_HERO);
		
		if (moveCam)
			Game.ME.moveCamera(this);
	}
	
	public function destroy() {
		for (be in arBE)
			be.remove();
		bm.remove();
		
		arBE = [];
	}
	
	public function update() {
		bm.x -= hero.dX;
		this.x -= hero.dX;
		
		for (t in arTrap) {
			if (!t.isOut && localToGlobal(new h2d.col.Point(t.x, t.y)).x < Settings.STAGE_WIDTH)
				t.popOut();
		}
	}
	
}