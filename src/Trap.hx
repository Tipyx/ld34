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
	public var isOut				: Bool;
	
	// BMP
	var bmp							: ASprite;

	public function new(type:DCDB.TrapType) 
	{
		super();
		
		this.type = type;
		
		isOut = false;
		
		switch (type) {
			case DCDB.TrapType.TTBlocBot :
				wid = 10;
				hei = 15;
				y = Settings.HEI_ROOM - hei;
				
				bmp = new ASprite(Settings.SLB, "plant_down");
				bmp.togglePauseAnim();
				bmp.loop = false;
				bmp.setGeneralSpeed(40);
				this.addChild(bmp);
			case DCDB.TrapType.TTBlocTop :
				wid = 10;
				hei = 20;
				y = 0;
				bmp = new ASprite(Settings.SLB, "plant_up");
				bmp.togglePauseAnim();
				bmp.loop = false;
				bmp.setGeneralSpeed(30);
				this.addChild(bmp);
			case DCDB.TrapType.TTPlantBot :
				wid = 10;
				hei = 15;
				y = Settings.HEI_ROOM - hei;
				var bmpT = new h2d.Bitmap(h2d.Tile.fromColor(0xFF0000, wid, hei), this);
			case DCDB.TrapType.TTPlantTop :
				wid = 10;
				hei = 20;
				y = 0;
				var bmpT = new h2d.Bitmap(h2d.Tile.fromColor(0xFF0000, wid, hei), this);
			case DCDB.TrapType.TTPlantBoth :
				wid = 10;
				hei = 30;
				y = 0;
				y = Settings.HEI_ROOM - hei;
				var bmpT = new h2d.Bitmap(h2d.Tile.fromColor(0xFF0000, wid, hei), this);
		}
		
		isEnable = true;
	}
	
	public function isHit(hero:Hero):Bool {
		if (hero.wX + 0.25 * wid < x + wid * 0.75
		&&	hero.wX + hero.wid * 0.75 > x
		&&	hero.wY >= y
		&&	hero.wY - hero.hei <= y + hei) {
			return true;
		}
		
		return false;
	}
	
	public function doEffect(hero:Hero) {
		isEnable = false;
		switch (type) {
			case DCDB.TrapType.TTBlocBot, DCDB.TrapType.TTBlocTop :
				hero.dX = 0;
				FX.SHAKE_CAM(0, 5, 0.85);
			case DCDB.TrapType.TTPlantBot, DCDB.TrapType.TTPlantTop, DCDB.TrapType.TTPlantBoth :
				hero.lock(this);
				Game.ME.ui.showGauge(type);
				FX.SHAKE_CAM(0, 5, 0.85);
		}
	}
	
	public function popOut() {
		isOut = true;
		
		switch (type) {
			case DCDB.TrapType.TTBlocBot, DCDB.TrapType.TTBlocTop :
				bmp.togglePauseAnim();
			case DCDB.TrapType.TTPlantBot :
			case DCDB.TrapType.TTPlantTop :
			case DCDB.TrapType.TTPlantBoth :
		}
	}
}