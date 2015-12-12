package;

import h2d.Sprite;

/**
 * ...
 * @author Tipyx
 */
class Room extends Sprite
{
	var hero						: Hero;
	public var wid					: Int;
	public var hei					: Int;
	
	// DEBUG
	var bmp							: h2d.Graphics;

	public function new(wid:Int, hei:Int) {
		super();

		this.wid = wid;
		this.hei = hei;
		
		bmp = new h2d.Graphics(this);
		//bmp.beginFill(0x808080);
		bmp.lineStyle(1, 0xFF0000);
		bmp.lineTo(0, 0);
		bmp.lineTo(0, hei);
		bmp.drawRect(0, 0, wid, hei);
		bmp.endFill();
		
		hero = Game.ME.hero;
	}
	
	public function load(hero:Hero) {
		hero.setActualRoom(this);
		hero.remove();
		
		this.addChild(hero);
	}
	
	public function destroy() {
		bmp.remove();
	}
	
	public function update() {
		this.x -= hero.dX;
	}
	
}