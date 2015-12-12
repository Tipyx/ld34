package;

import h2d.Sprite;

/**
 * ...
 * @author Tipyx
 */
class Trap extends Sprite
{
	public var type					: DCDB.TrapType;
	
	public var wid					: Int;
	public var hei					: Int;
	
	public var isEnable				: Bool;

	public function new(type:DCDB.TrapType) 
	{
		super();
		this.type = type;
		
		wid = 10;
		hei = 15;
		
		var bmp = new h2d.Bitmap(h2d.Tile.fromColor(0xFF0000, wid, hei), this);
		bmp.y = -hei;
		
		isEnable = true;
	}
	
}