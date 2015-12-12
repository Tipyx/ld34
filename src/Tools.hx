package;

/**
 * ...
 * @author Tipyx
 */
class Tools
{

	public static function IS_ROOM_UNDER_HERO():Room {
		var hero = Game.ME.hero;
		
		for (r in Game.ME.arRoom) {
			if (hero.actualRoom != r
			&&	0 < hero.wX + (hero.actualRoom.x - r.x) && r.wid > hero.wX + (hero.actualRoom.x - r.x)
			&&	r.y == hero.actualRoom.y + Settings.HEI_ROOM)
				return r;
		}
		
		return null;
	}

	public static function IS_ROOM_ABOVE_HERO():Room {
		var hero = Game.ME.hero;
		
		for (r in Game.ME.arRoom) {
			if (hero.actualRoom != r
			&&	0 < hero.wX + (hero.actualRoom.x - r.x) && r.wid > hero.wX + (hero.actualRoom.x - r.x)
			&&	r.y == hero.actualRoom.y - Settings.HEI_ROOM)
				return r;
		}
		
		return null;
	}
	
}