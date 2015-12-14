package;

import h2d.Sprite;

/**
 * ...
 * @author Tipyx
 */
class Hero extends Sprite
{
	static var CROUNCH_DURATION		= 10;
	public static var MAX_SPEED		= 8;
	
	// PHYSIX
	public var dX					: Float;
	public var dY					: Float;
	public var wX					: Float;
	public var wY					: Float;
	
	public var wid					: Int;
	public var hei					: Int;
	
	public var isOnGround			: Bool;
	public var isDoubleJumpEnable	: Bool;
	public var isCrounched			: Bool;
	var counterCrounch				: Int;
	public var arRoomDone			: Array<Room>;
	public var isLocked				: Bool;
	public var trapsHit				: Int;
	
	public var actualRoom			: Room;
	
	var tweenGauge					: mt.motion.Tween;
	
	// BMP
	var bmp							: ASprite;
	var bgGauge						: h2d.Bitmap;
	var gauge						: h2d.Bitmap;
	public var btnGauge1			: ASprite;
	public var btnGauge2			: ASprite;

	public function new() {
		super();
		
		wid = 15;
		hei = 20;
		
		wX = wY = 0;
		dX = dY = 0;
		
		bmp = new ASprite(Settings.SLB, "player_iddle");
		bmp.addBehaviour(0, "player_iddle", function () { return true; }, 0);
		bmp.addBehaviour(1, "anim_player_run", function () { return dX != 0; }, 20);
		bmp.addBehaviour(2, "player_sweep", function () { return isCrounched; }, 0);
		bmp.addBehaviour(3, "player_jump", function () { return dY < 0; }, 0);
		bmp.addBehaviour(3, "player_fall", function () { return dY > 0; }, 0);
		this.addChild(bmp);
		
		isOnGround = true;
		isDoubleJumpEnable = false;
		isCrounched = false;
		counterCrounch = 0;
		isLocked = false;
		arRoomDone = [];
		trapsHit = 0;
		
		//var bmpBox = new h2d.Graphics(this);
		//bmpBox.beginFill(0xFF0000, 0.75);
		//bmpBox.drawRect(0 , -hei, wid, hei);
		
		bgGauge = new h2d.Bitmap(Settings.SLB.getTile("gauge"));
		bgGauge.x = - 10;
		bgGauge.y = -bgGauge.tile.height - 5;
		this.addChild(bgGauge);
		
		gauge = new h2d.Bitmap(h2d.Tile.fromColor(0x00C100, 2, 14), this);
		gauge.x = bgGauge.x + 2;
		gauge.y = bgGauge.y + 2;
		gauge.scaleY = 0;
		
		gauge.alpha = 0;
		bgGauge.alpha = 0;
	}
	
	public function setActualRoom(newRoom:Room) {
		actualRoom = newRoom;
		
		for (r in arRoomDone) {
			if (r == newRoom)
				return;
		}
		arRoomDone.push(newRoom);
	}
	
	public function updateGauge(ratio:Float) {
		gauge.scaleY = ratio;
	}
	
	public function lock(trap:Trap) {
		switch (trap.type) {
			case DCDB.TrapType.TTPlantBot :
				wY = actualRoom.hei;
				btnGauge1 = new ASprite(Settings.SLB, "btn_up");
				btnGauge1.setGeneralSpeed(30);
				btnGauge1.x = bgGauge.x - btnGauge1.wid - 1;
				btnGauge1.y = -btnGauge1.hei - 5;
				this.addChild(btnGauge1);
				
				gauge.rotation = Math.PI;
				gauge.x = bgGauge.x + 4;
				gauge.y = bgGauge.y + bgGauge.tile.height - 2;
			case DCDB.TrapType.TTPlantTop :
				btnGauge1 = new ASprite(Settings.SLB, "btn_down");
				btnGauge1.setGeneralSpeed(30);
				btnGauge1.x = bgGauge.x - btnGauge1.wid - 1;
				btnGauge1.y = -btnGauge1.hei - 5;
				this.addChild(btnGauge1);
				
				gauge.rotation = 0;
				gauge.x = bgGauge.x + 2;
				gauge.y = bgGauge.y + 2;
			case DCDB.TrapType.TTPlantBoth :
				btnGauge1 = new ASprite(Settings.SLB, "btn_down");
				btnGauge1.setGeneralSpeed(30);
				btnGauge1.x = bgGauge.x - btnGauge1.wid - 1;
				btnGauge1.y = -btnGauge1.hei - 5;
				btnGauge1.alpha = 0.5;
				this.addChild(btnGauge1);
				
				btnGauge2 = new ASprite(Settings.SLB, "btn_up");
				btnGauge2.setGeneralSpeed(30);
				btnGauge2.x = btnGauge1.x - btnGauge1.wid - 1;
				btnGauge2.y = -btnGauge2.hei - 5;
				this.addChild(btnGauge2);
				
				gauge.rotation = 0;
				gauge.x = bgGauge.x + 2;
				gauge.y = bgGauge.y + 2;
			case DCDB.TrapType.TTBlocBot, DCDB.TrapType.TTBlocTop :
		}
		if (tweenGauge != null) {
			tweenGauge.dispose();
			tweenGauge = null;
		}
		gauge.alpha = 1;
		bgGauge.alpha = 1;
		isLocked = true;
		dX = 0;
		updateGauge(0);
	}
	
	public function unlock() {
		if (btnGauge1 != null)
			btnGauge1.remove();
		if (btnGauge2 != null)
			btnGauge2.remove();
		isLocked = false;
		updateGauge(1);
		tweenGauge = Main.ME.tweener.create().to(10, gauge.alpha = 0, bgGauge.alpha = 0);
	}
	
	public function setCoord(newX:Float, newY:Float) {
		wX = newX;
		wY = newY;
	}
	
	public function destroy() {
		bmp.remove();
	}
	
	public function update() {
	// PHYSIX
		if (isLocked) {
			dX = 0;
			dY = 0;
		}
		else {
		//X
			//dX = 0;
			dX += 0.2;
			dX *= 0.98;
			
			for (t in actualRoom.arTrap) {
				if (t.isEnable
				&&	t.isHit(this)) {
					trapsHit++;
					t.doEffect(this);
				}
			}
			
			if (dX < 0.05)
				dX = 0;
				
			if (wX + dX >= actualRoom.widPix - wid - 10) { // HIT WALL
				if (this.x != wY)
					FX.SHAKE_CAM(5, 0, 0.85);
					
				dX = 0;
			}
		
			//Y
			
			dY += 1;
			
			if (dY > 0)
				dY *= 0.90;
			else
				dY *= 0.95;
			
			if (dY > -0.05 && dY < 0.05)
				dY = 0;
			
			if (hxd.Key.isPressed(hxd.Key.UP) && (isOnGround || isDoubleJumpEnable)) {
				isCrounched = false;
				SoundManager.JUMP();
				if (!isOnGround) { // MAKE DOUBLE JUMP
					isDoubleJumpEnable = false;
					SoundManager.DJUMP();
				}
				dY = -7;
			}
			else if (isOnGround) {
				if (hxd.Key.isDown(hxd.Key.DOWN)) {
					if (!isCrounched) {
						counterCrounch = 0;
						isCrounched = true;
					}
				}
				else if (hxd.Key.isReleased(hxd.Key.DOWN)) {
					var roomUnder = Tools.IS_ROOM_UNDER_HERO();
					if (counterCrounch < 5 && roomUnder != null) {
						setCoord(this.x + (actualRoom.x - roomUnder.x), this.y + (actualRoom.y - roomUnder.y));
						dY = 10;
						roomUnder.load(this);
					}
					isCrounched = false;
				}
			}
			
			if (isCrounched) {
				hei = 10;
				counterCrounch++;
				dX *= 0.95;
			}
			else {
				hei = 20;
			}
			
			var roomAbove = Tools.IS_ROOM_ABOVE_HERO();
			
			if (wY + dY < 0 + hei * 0.75 && roomAbove == null && dY < 0) { // HIT CEILING
				wY = 0 + hei * 0.75;
				dY = 0;
				isOnGround = false;
				//isDoubleJumpEnable = false;
			}
			else if (wY + dY < 0  && roomAbove != null) { // CHANGE FLOOR UP
				setCoord(this.x + (actualRoom.x - roomAbove.x), this.y + (actualRoom.y - roomAbove.y));
				roomAbove.load(this);
			}
			else if (wY + dY >= actualRoom.hei) {
				wY = actualRoom.hei;
				dY = 0;
				isOnGround = true;
				isDoubleJumpEnable = true;
			}
			else
				isOnGround = false;
		}
		
		if (dX > MAX_SPEED)
			dX = MAX_SPEED;
		
		bmp.setGeneralSpeed(25 * (dX / MAX_SPEED));
		if (bmp.speed < 10)
			bmp.setGeneralSpeed(10);
		bmp.y = -hei - 5 - (isCrounched ? 8 : 0);
		bmp.update();
		
		wX += dX;
		wY += dY;
		
		this.x = wX;
		this.y = wY;
		
	// TUTO
		if (Settings.SHOW_TUTO) {
			if (arRoomDone.length == 2) {
				Game.ME.ui.updateTuto(2);
			}
			else if (arRoomDone.length == 3) {
				Game.ME.ui.updateTuto(3);
			}
			else if (arRoomDone.length == 4) {
				Game.ME.ui.updateTuto(4);
			}
			else if (arRoomDone.length == 5) {
				Game.ME.ui.updateTuto(6);
			}
		}
	}
}