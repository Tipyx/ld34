package;

/**
 * ...
 * @author Tipyx
 */
class FX
{
	public static var BG_FADE		: h2d.Bitmap;
	
	public static function INIT() {
		BG_FADE = new h2d.Bitmap(h2d.Tile.fromColor(0x000000, Settings.STAGE_WIDTH, Settings.STAGE_HEIGHT));
		BG_FADE.alpha = 0;
		Main.ME.s2d.add(BG_FADE, Main.DM_FX);
	}
	
	public static function FADE(start:Float, end:Float, duration:Int, ?onEnd:Void->Void = null) {
		BG_FADE.alpha = start;
		Main.ME.tweener.create().to(duration, BG_FADE.alpha = end).onComplete = function () {
			if (onEnd != null)
				onEnd();
		};
	}
	
	static private var friction		: Float;
	static private var dsX			: Null<Float>		= null;
	static private var dsY			: Null<Float>		= null;
	static private var bX			: Float;
	static private var bY			: Float;
	
	public static function SHAKE_CAM(dX:Float, dY:Float, frict:Float) {
		if (dsX != null || dsY != null)
			return;
		
		dsX = dX;
		dsY = dY;
		friction = frict;
		
		bX = Main.ME.s2d.x;
		bY = Main.ME.s2d.y;
	}
	
	public static function UPDATE() {
		if (dsX != null) {
			dsX *= -friction;
			
			Main.ME.s2d.x = bX + dsX;
			
			if (dsX > -1 && dsX < 1) {
				dsX = null;
				Main.ME.s2d.x = bX;
			}
		}
		
		if (dsY != null) {
			dsY *= -friction;
			
			Main.ME.s2d.y = bY + dsY;
			
			if (dsY > -1 && dsY < 1) {
				dsY = null;
				Main.ME.s2d.y = bY;
			}
		}
	}
}