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
	
	public static var SLB					: h2d.TileSheet;
	
	public static function INIT() {
		STAGE_WIDTH = flash.Lib.current.stage.stageWidth;
		STAGE_HEIGHT = flash.Lib.current.stage.stageHeight;
		
		SLB = hxd.Res.ss.toTileSheet();
	}
	
}