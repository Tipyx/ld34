package;

/**
 * ...
 * @author Tipyx
 */

class Game extends h2d.Layers
{
	public static var ME			: Game;
	
	static var num					= 0;
	public static var DM_ROOM		= num;
	public static var DM_HERO		= num;
	
	var cIngame						: h2d.Layers;
	
	var tweener						: mt.motion.Tweener;
	
	public var hero					: Hero;
	
	public var arRoom				: Array<Room>;
	
	var roomUnder					: Room;

	public function new() {
		super();
		
		ME = this;
		
		tweener = new mt.motion.Tweener();
		
		cIngame = new h2d.Layers();
		cIngame.scaleX = cIngame.scaleY = 3;
		this.addChild(cIngame);
		
		hero = new Hero();
		
		arRoom = [];
		
		//createRoom(0, 0, 1000, []);
		//createRoom(400, 1, 1000);
		
		for (r in DCDB.roomData.all) {
			var arTrap = [];
			for (t in r.traps)
				arTrap.push(t);
			createRoom(0, 0, r.width, arTrap);
		}
		
		//createRoom(0, Std.int((Settings.STAGE_HEIGHT - Settings.HEI_ROOM) * 0.25), 1000, Settings.HEI_ROOM);
		//createRoom(200, Std.int(arRoom[0].y + Settings.HEI_ROOM), 1000, Settings.HEI_ROOM);
		//createRoom(1100, Std.int(arRoom[0].y), 1000, Settings.HEI_ROOM);
		//createRoom(200, Std.int(arRoom[0].y - Settings.HEI_ROOM), 1000, Settings.HEI_ROOM);
		
		init();
	}
	
	function init() {
		arRoom[0].load(hero, false);
		hero.setCoord(50, arRoom[0].hei);
		
		cIngame.y = Std.int(Settings.STAGE_HEIGHT * 0.5- (hero.actualRoom.posY * Settings.HEI_ROOM) * cIngame.scaleY);
	}
	
	function createRoom(x:Int, y:Int, wid:Int, arTrap:Array < DCDB.RoomData_traps > ) {
		var room = new Room(y, wid, arTrap);
		room.x = x;
		room.y = y * Settings.HEI_ROOM;
		arRoom.push(room);
		cIngame.add(room, DM_ROOM);
	}
	
	public function destroy() {
		for (r in arRoom)
			r.destroy();
			
		hero.destroy();
		
		arRoom = [];
	}
	
	public function moveCamera(r:Room) {
		tweener.create().to(10, cIngame.y = Std.int(Settings.STAGE_HEIGHT * 0.5 - (hero.actualRoom.posY * Settings.HEI_ROOM) * cIngame.scaleY));
	}
	
	public function update() {
		tweener.update();
		
		hero.update();
		
		for (r in arRoom.copy()) {
			r.update();
			if (r.x + r.wid < 0) {
				r.destroy();
				arRoom.remove(r);
			}
		}
			
		// GENERATE NEW ROOM
	}
	
}