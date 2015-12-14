package;

/**
 * ...
 * @author Tipyx
 */
class Settings
{
	public static var STAGE_WIDTH			: Int;
	public static var STAGE_HEIGHT			: Int;
	
	public static var HEI_ROOM				= 38;
	public static var WID_TILE				= 200;
	
	public static var SLB					: h2d.TileSheet;
	
	public static var FONT_2				: h2d.Font;
	public static var FONT_8				: h2d.Font;
	
	public static var SHOW_TUTO				= false;
	//public static var SHOW_TUTO				= true;
	
	public static var AR_ROOM_DATA			: Array<DCDB.RoomData>;
	
	public static function INIT() {
		STAGE_WIDTH = flash.Lib.current.stage.stageWidth;
		STAGE_HEIGHT = flash.Lib.current.stage.stageHeight;
		
		SLB = hxd.Res.ss.toTileSheet();
		//trace(SLB.getTile("bg);
		
		FONT_2 = hxd.Res.rainyhearts.build(32, { antiAliasing:false } );	// MULTIPLE DE 16
		FONT_8 = hxd.Res.rainyhearts.build(128, { antiAliasing:false } );	// MULTIPLE DE 16
		//FONT_20 = hxd.Res.wendy.build(20, { antiAliasing:false } );		// MULTIPLE DE 10
		
		AR_ROOM_DATA = [];
		AR_ROOM_DATA.push(DCDB.roomData.get(DCDB.RoomDataKind.room1));
		AR_ROOM_DATA.push(DCDB.roomData.get(DCDB.RoomDataKind.room2));
		AR_ROOM_DATA.push(DCDB.roomData.get(DCDB.RoomDataKind.room3));
		AR_ROOM_DATA.push(DCDB.roomData.get(DCDB.RoomDataKind.room4));
		AR_ROOM_DATA.push(DCDB.roomData.get(DCDB.RoomDataKind.room5));
		AR_ROOM_DATA.push(DCDB.roomData.get(DCDB.RoomDataKind.room6));
		//AR_ROOM_DATA.push(DCDB.roomData.get(DCDB.RoomDataKind.room1));
		//AR_ROOM_DATA.push(DCDB.roomData.get(DCDB.RoomDataKind.room1));
	}
}