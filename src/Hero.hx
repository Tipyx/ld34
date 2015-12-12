package;

import h2d.Sprite;

/**
 * ...
 * @author Tipyx
 */
class Hero extends Sprite
{
	static var CROUNCH_DURATION		= 10;
	
	// PHYSIX
	public var dX					: Float;
	public var dY					: Float;
	public var wX					: Float;
	public var wY					: Float;
	
	var wid							: Int;
	var hei							: Int;
	
	public var isOnGround			: Bool;
	public var isDoubleJumpEnable	: Bool;
	public var isCrounched			: Bool;
	var counterCrounch				: Int;
	
	public var actualRoom			: Room;
	
	// DEBUG
	var bmp							: ASprite;
	//var bmp							: h2d.Bitmap;

	public function new() {
		super();
		
		wid = 15;
		hei = 20;
		
		wX = wY = 0;
		dX = dY = 0;
		
		//bmp = new h2d.Bitmap(hxd.Res.player.toTile(), this);
		
		bmp = new ASprite(Settings.SLB, "player");
		bmp.addBehaviour(0, "player", function () { return true; }, 0);
		bmp.addBehaviour(1, "anim_player_run", function () { return dX != 0; }, 20);
		this.addChild(bmp);
		
		isOnGround = true;
		isDoubleJumpEnable = false;
		isCrounched = false;
		
		//var bmpBox = new h2d.Graphics(this);
		//bmpBox.beginFill(0xFF0000, 0.75);
		//bmpBox.drawRect(0 , -hei, wid, hei);
	}
	
	public function setActualRoom(newRoom:Room) {
		actualRoom = newRoom;
	}
	
	public function setCoord(newX:Int, newY:Int) {
		wX = newX;
		wY = newY;
	}
	
	public function destroy() {
		bmp.remove();
	}
	
	public function update() {
	// PHYSIX
		//X
		//if (dX == 0)
			//dX = 3;
		//dX += 0.2;
		//dX *= 0.98;
		
		if (hxd.Key.isDown(hxd.Key.RIGHT)) {
			if (dX == 0)
				dX = 1;
				//dX = 3;
			dX += 0.15;
			dX *= 0.98;
		}
		else
			dX *= 0.80;
		
		for (t in actualRoom.arTrap) {
			if (t.isEnable
			&&	wX + 0.25 * wid < t.x + t.wid
			&&	wX + wid * 0.75 > t.x
			&&	wY >= t.y - t.hei
			&&	wY <= t.y) {
				//trace("trololo");
				t.isEnable = false;
				dX = 0;
			}
		}
		
		if (dX < 0.05)
			dX = 0;
			
		if (wX + dX < actualRoom.wid - wid)
			wX += dX;
		else {
			wX = actualRoom.wid - wid;
			dX = 0;
		}
		
		//Y
		if (hxd.Key.isPressed(hxd.Key.UP) && (isOnGround || isDoubleJumpEnable)) {
			if (!isOnGround)
				isDoubleJumpEnable = false;
			dY = -8;
		}
		else if (isOnGround && hxd.Key.isPressed(hxd.Key.DOWN)) {
			var roomUnder = Tools.IS_ROOM_UNDER_HERO();
			if (isCrounched && roomUnder != null) {
				isCrounched = false;
				setCoord(Std.int(wX + (actualRoom.x - roomUnder.x)), Std.int(wY + (actualRoom.y - roomUnder.y)));
				dY = 20;
				roomUnder.load(this);
			}
			else {
				counterCrounch = 0;
				isCrounched = true;
			}
		}
		
		if (isCrounched) {
			counterCrounch++;
			if (counterCrounch >= CROUNCH_DURATION)
				isCrounched = false;
		}
		
		dY += 1;
		//dY += 1.2;
		if (dY > 0)
			dY *= 0.90;
		else
			dY *= 0.95;
		
		if (dY > -0.05 && dY < 0.05)
			dY = 0;
		
		var roomAbove = Tools.IS_ROOM_ABOVE_HERO();
		
		if (wY + dY < 0 + hei && roomAbove == null && dY < 0) { // HIT CEILING
			wY = 0 + hei;
			dY = 0;
			isOnGround = false;
			isDoubleJumpEnable = false;
		}
		else if (wY + dY < 0  && roomAbove != null) { // CHANGE FLOOR UP
		//if (wY + dY < 0  && roomAbove != null) { // CHANGE FLOOR UP
			setCoord(Std.int(wX + (actualRoom.x - roomAbove.x)), Std.int(wY + (actualRoom.y - roomAbove.y)));
			roomAbove.load(this);
			wY += dY;
		}
		else if (wY + dY >= actualRoom.hei) {
			wY = actualRoom.hei;
			dY = 0;
			isOnGround = true;
			isDoubleJumpEnable = true;
		}
		else {
			wY += dY;
			isOnGround = false;
		}
		
		bmp.setGeneralSpeed(25 * (dX / 9));
		if (bmp.speed < 10)
			bmp.setGeneralSpeed(10);
		bmp.scaleY = isCrounched ? 0.5 : 1;
		bmp.y = -hei * bmp.scaleY - 5;
		bmp.update();
		
		this.x = wX;
		this.y = wY;
	}
}