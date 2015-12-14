package;

/**
 * ...
 * @author Tipyx
 */
class LevelManager
{
	var hero 				: Hero;
	var arRoom 				: Array<Room>;
	
	var rnd					: mt.Rand;

	public function new() {
		hero = Game.ME.hero;
		arRoom = Game.ME.arRoom;
		
		var seed = Std.random(9999);
		//seed = 3072;
		trace(seed);
		rnd = new mt.Rand(seed);
	}
	
	public function init() {
		// DEBUG TEST ROOM
		//var arTrap = [];
			//for (t in DCDB.roomData.get(DCDB.RoomDataKind.room8).traps)
				//arTrap.push(t);
		//createRoom(0, 0, DCDB.roomData.get(DCDB.RoomDataKind.room8).widTile, arTrap);
		//createRoom(0, 0, DCDB.roomData.get(DCDB.RoomDataKind.room8).widTile, []);
		//createRoom(0, -1, DCDB.roomData.get(DCDB.RoomDataKind.room8).widTile, []);
		//return;
		
		
		
		if (Settings.SHOW_TUTO) {
			var firstRoom = createRoom(0, 0, DCDB.roomData.get(DCDB.RoomDataKind.first).widTile, []);
		
			// TUTO BLOC BOT
			var arTrap = [];
				for (t in DCDB.roomData.get(DCDB.RoomDataKind.tuto1).traps)
					arTrap.push(t);
			var tuto1 = createRoom(firstRoom.x + firstRoom.widPix - Settings.WID_TILE * 4, 1, DCDB.roomData.get(DCDB.RoomDataKind.tuto1).widTile, arTrap);
			tuto1.genDone = true;
			
			// TUTO BLOC TOP
			arTrap = [];
				for (t in DCDB.roomData.get(DCDB.RoomDataKind.tuto2).traps)
					arTrap.push(t);
			var tuto2 = createRoom(tuto1.x + tuto1.widPix - Settings.WID_TILE * 4, 2, DCDB.roomData.get(DCDB.RoomDataKind.tuto2).widTile, arTrap);
			tuto2.genDone = true;
			
			// TUTO PLANTS
			var arTrap = [];
				for (t in DCDB.roomData.get(DCDB.RoomDataKind.tuto3).traps)
					arTrap.push(t);
			var tuto3 = createRoom(tuto2.x + tuto2.widPix - Settings.WID_TILE * 4, 3, DCDB.roomData.get(DCDB.RoomDataKind.tuto3).widTile, arTrap);
			tuto3.genDone = true;
			
			// TUTO FINAL TUTO
			var tuto4 = createRoom(tuto3.x + tuto3.widPix - Settings.WID_TILE * 4, 2, DCDB.roomData.get(DCDB.RoomDataKind.first).widTile, []);
		}
		else {
			var firstRoom = createRoom(0, 0, DCDB.roomData.get(DCDB.RoomDataKind.first).widTile, []);
			createRoom(firstRoom.x + firstRoom.widPix - Settings.WID_TILE * 4, 1, DCDB.roomData.get(DCDB.RoomDataKind.first).widTile, []);
		}
	}
	
	function checkGeneration() {
		var dist = 0;
		
		//for (r in arRoom.copy()) {
		for (r in arRoom) {
			dist = (hero.actualRoom.posY - r.posY) * (hero.actualRoom.posY - r.posY);
			if (!r.genDone
			&&	dist < 25			// 5 * 5
			&&	r.x > Settings.STAGE_WIDTH
			&&	r.x < Settings.STAGE_WIDTH * 3) {
				// CREATE TOP
				var rndX = r.x + rnd.random(r.widPix - 2 * Settings.WID_TILE);
				var rndRD = Settings.AR_ROOM_DATA[rnd.random(Settings.AR_ROOM_DATA.length)];
				var numTry = 0;
				while (numTry < 20 && (isRoomAt(rndX, r.posY - 1, rndRD.widTile * Settings.WID_TILE) || rndX + rndRD.widTile * Settings.WID_TILE < r.x + r.widPix + 2 * Settings.WID_TILE)) {
					rndX = r.x + rnd.random(r.widPix - 2 * Settings.WID_TILE);
					rndRD = Settings.AR_ROOM_DATA[rnd.random(Settings.AR_ROOM_DATA.length)];
					numTry++;
				}
				if (!isRoomAt(rndX, r.posY - 1, rndRD.widTile * Settings.WID_TILE) && rndX + rndRD.widTile * Settings.WID_TILE >= r.x + r.widPix + 2 * Settings.WID_TILE) {
					r.genDone = true;
					var arTrap = [];
					for (t in rndRD.traps)
						arTrap.push(t);
					createRoom(rndX, r.posY - 1, rndRD.widTile, arTrap);
				}
				
				// CREATE DOWN
				rndX = r.x + rnd.random(r.widPix - 2 * Settings.WID_TILE);
				rndRD = Settings.AR_ROOM_DATA[rnd.random(Settings.AR_ROOM_DATA.length)];
				numTry = 0;
				while (numTry < 20 && (isRoomAt(rndX, r.posY + 1, rndRD.widTile * Settings.WID_TILE) || rndX + rndRD.widTile * Settings.WID_TILE < r.x + r.widPix + 2 * Settings.WID_TILE)) {
					rndX = r.x + rnd.random(r.widPix - 2 * Settings.WID_TILE);
					rndRD = Settings.AR_ROOM_DATA[rnd.random(Settings.AR_ROOM_DATA.length)];
					numTry++;
				}
				if (!isRoomAt(rndX, r.posY + 1, rndRD.widTile * Settings.WID_TILE) && rndX + rndRD.widTile * Settings.WID_TILE >= r.x + r.widPix + 2 * Settings.WID_TILE) {
					r.genDone = true;
					var arTrap = [];
					for (t in rndRD.traps)
						arTrap.push(t);
					createRoom(rndX, r.posY + 1, rndRD.widTile, arTrap);
				}
			}
		}
	}
	
	function createRoom(x:Float, y:Int, widTile:Int, arTrap:Array < DCDB.RoomData_traps > ):Room {
		var room = new Room(x, y, widTile, arTrap);
		arRoom.push(room);
		Game.ME.cIngame.add(room, Game.DM_ROOM);
		
		return room;
	}
	
	function isRoomAt(x:Float, y:Int, widPix:Int):Bool {
		for (r in arRoom) {
			if (y == r.posY
			&&	x < r.x + r.widPix
			&&	x + widPix > r.x)
				return true;
		}
		
		return false;
	}
	
	public function update() {
		checkGeneration();
	}
}