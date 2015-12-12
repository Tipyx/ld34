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
	
	public var hero					: Hero;
	
	public var arRoom				: Array<Room>;
	
	var roomUnder					: Room;

	public function new() {
		super();
		
		ME = this;
		
		hero = new Hero();
		
		arRoom = [];
		
		createRoom(0, Std.int((Settings.STAGE_HEIGHT - Settings.HEI_ROOM) * 0.25), 1000, Settings.HEI_ROOM);
		//createRoom(200, Std.int(arRoom[0].y + Settings.HEI_ROOM), 1000, Settings.HEI_ROOM);
		//createRoom(1100, Std.int(arRoom[0].y), 1000, Settings.HEI_ROOM);
		//createRoom(200, Std.int(arRoom[0].y - Settings.HEI_ROOM), 1000, Settings.HEI_ROOM);
		
		init();
		
		this.scaleX = this.scaleY = 2;
	}
	
	function init() {
		arRoom[0].load(hero);
		hero.setCoord(150, arRoom[0].hei);
	}
	
	function createRoom(x, y, wid, hei) {
		var room = new Room(wid, hei);
		room.x = x;
		room.y = y;
		arRoom.push(room);
		this.add(room, DM_ROOM);
	}
	
	public function destroy() {
		for (r in arRoom)
			r.destroy();
			
		hero.destroy();
		
		arRoom = [];
	}
	
	public function update() {
		hero.update();
		
		for (r in arRoom)
			r.update();
			
		// GENERATE NEW ROOM
	}
	
}