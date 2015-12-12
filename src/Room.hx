package;

import h2d.SpriteBatch;

/**
 * ...
 * @author Tipyx
 */
class Room extends h2d.Layers
{
	static var num					= 0;
	public static var DM_BG			= num++;
	public static var DM_TRAP		= num++;
	public static var DM_HERO		= num++;
	
	var hero						: Hero;
	
	public var wid					: Int;
	public var hei					: Int;
	public var arTrap				: Array<Trap>;
	
	public var posY					: Int;
	
	var bm							: SpriteBatch;
	var arBE						: Array<BatchElement>;
	

	public function new(posY:Int, wid:Int, arTrapData:Array<DCDB.RoomData_traps>) {
		super();
		
		this.posY = posY;
		this.wid = wid;
		this.hei = Settings.HEI_ROOM;
		this.arTrap = [];
		
		hero = Game.ME.hero;
		
		// SET BG
		var tile = hxd.Res.BG_test.toTile();
		
		var bm = new h2d.SpriteBatch(tile);
		this.add(bm, DM_BG);
		
		arBE = [];
		
		for (i in 0...Std.int(wid / tile.width)) {
			var bg = bm.alloc(tile);
			bg.x = i * tile.width;
			arBE.push(bg);
		}
		
		// SET TRAP
		for (t in arTrapData) {
			var trap = new Trap(t.trapType);
			trap.x = t.x;
			trap.y = Settings.HEI_ROOM;
			arTrap.push(trap);
			this.add(trap, DM_TRAP);
		}
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
		this.x -= hero.dX;
	}
	
}