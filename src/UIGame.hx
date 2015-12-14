package;

import DCDB.TrapType;
import h2d.Sprite;

/**
 * ...
 * @author Tipyx
 */
class UIGame extends Sprite
{
	var txtDistance:h2d.Text;
	var txtTuto:h2d.Text;
	
	var actualTuto				: Int;
	
	var arRoomTuto		: Array<Room>;

	public function new() 
	{
		super();
		
		actualTuto = 0;
		
		arRoomTuto = [];
		
		var bg = new h2d.Graphics(this);
		bg.beginFill(0x000000);
		bg.lineStyle(5, 0xFFFFFF);
		bg.lineTo(0, 0);
		bg.lineTo(0, 100);
		bg.drawRect(0, 0, Settings.STAGE_WIDTH, 100);
		bg.endFill();
		
		txtDistance = new h2d.Text(Settings.FONT_2, this);
		txtDistance.text = "trololo";
		txtDistance.maxWidth = 100;
		txtDistance.textAlign = Center;
		txtDistance.x = Std.int((Settings.STAGE_WIDTH - txtDistance.maxWidth) * 0.5);
		
		txtTuto = new h2d.Text(Settings.FONT_2, this);
		txtTuto.text = "Escape from the angry vegetation!";
		txtTuto.maxWidth = Settings.STAGE_WIDTH;
		txtTuto.textAlign = Center;
		txtTuto.y = Std.int(Settings.STAGE_HEIGHT * 0.2);
		if (!Settings.SHOW_TUTO)
			txtTuto.alpha = 0;
	}
	
	var counterGauge		: Null<Float>;
	var maxGauge			: Int;
	var trapType			: TrapType;
	var lastIsUp			: Bool;
	
	public function showGauge(type:TrapType) {
		this.trapType = type;
		lastIsUp = false;
		
		maxGauge = 3;
		counterGauge = 0;
	}
	
	public function destroy() {
		
		
		super.remove();
	}
	
	public function updateTuto(num:Int) {
		if (num <= actualTuto)
			return;
		
		actualTuto = num;
		trace(num);
		switch (num) {
			case 1:
				var t:mt.motion.Tween = Main.ME.tweener.create();
				t.to(10, txtTuto.alpha = 0);
				t.onComplete = function () {
					txtTuto.text = "Press briefly DOWN to go down one floor!";
					txtTuto.y = Std.int(Settings.STAGE_HEIGHT * 0.4);					
				};
				t.to(10, txtTuto.alpha = 1);
				
			case 2 :
				txtTuto.text = "Dodge these by pressing DOWN !";
				txtTuto.y = Std.int(Settings.STAGE_HEIGHT * 0.9);
				
			case 3 :
				var t:mt.motion.Tween = Main.ME.tweener.create();
				t.to(10, txtTuto.alpha = 0);
				t.onComplete = function () {
					txtTuto.text = "Press UP to jump over these roots!";
					txtTuto.y = Std.int(Settings.STAGE_HEIGHT * 0.9);				
				};
				t.to(10, txtTuto.alpha = 1);
				
			case 4 :
				var t:mt.motion.Tween = Main.ME.tweener.create();
				t.to(10, txtTuto.alpha = 0);
				t.onComplete = function () {
					txtTuto.text = "Don't be trapped by these plants!";
					txtTuto.y = Std.int(Settings.STAGE_HEIGHT * 0.9);				
				};
				t.to(10, txtTuto.alpha = 1);
				
			case 5 :
				var t:mt.motion.Tween = Main.ME.tweener.create();
				t.to(10, txtTuto.alpha = 0);
				t.onComplete = function () {
					txtTuto.text = "Make a double Jump to go up one floor!";
					txtTuto.y = Std.int(Settings.STAGE_HEIGHT * 0.9);
				};
				t.to(10, txtTuto.alpha = 1);
				
			case 6 :
				var t:mt.motion.Tween = Main.ME.tweener.create();
				t.to(10, txtTuto.alpha = 0);
				t.onComplete = function () {
					txtTuto.text = "Good luck!";
					txtTuto.y = Std.int(Settings.STAGE_HEIGHT * 0.3);
				};
				t.to(10, txtTuto.alpha = 1);
				t.delay(30);
				t.to(10, txtTuto.alpha = 0);
		}
	}
	
	public function update() {
	// CHECK TUTO
		if (Settings.SHOW_TUTO) {
			for (r in Game.ME.arRoom) {
				var b = true;
				for (rt in arRoomTuto)
					if (r == rt)
						b = false;
				if (b && r.x < Settings.STAGE_WIDTH / Game.SCALE_GAME) {
					arRoomTuto.push(r);
				}
			}
			
			trace(arRoomTuto.length);
			
			if (arRoomTuto.length == 2 && actualTuto == 0) {
				updateTuto(1);
			}
			else if (arRoomTuto.length == 5 && actualTuto == 4) {
				updateTuto(5);
			}
		}
		
	// GAUGE
		if (counterGauge != null) {
			switch (trapType) {
				case DCDB.TrapType.TTBlocBot :
				case DCDB.TrapType.TTBlocTop :
				case DCDB.TrapType.TTPlantBot :
					if (hxd.Key.isReleased(hxd.Key.UP))
						counterGauge += 1;
					else  
						counterGauge -= 0.2;
				case DCDB.TrapType.TTPlantTop :
					if (hxd.Key.isReleased(hxd.Key.DOWN))
						counterGauge += 1;
					else  
						counterGauge -= 0.2;
				case DCDB.TrapType.TTPlantBoth :
					if ((lastIsUp && hxd.Key.isReleased(hxd.Key.DOWN)) || (!lastIsUp && hxd.Key.isReleased(hxd.Key.UP))) {
						Game.ME.hero.btnGauge1.alpha = lastIsUp ? 0.5 : 1;
						Game.ME.hero.btnGauge2.alpha = !lastIsUp ? 0.5 : 1;
						
						lastIsUp = !lastIsUp;
						counterGauge += 1;
					}
					else
						counterGauge -= 0.2;
			}
			
			if (counterGauge < 0) {
				counterGauge = 0;
				Game.ME.hero.updateGauge(0);
			}
			else if (counterGauge >= maxGauge) {
				counterGauge = null;
				Game.ME.hero.unlock();
			}
			else
				Game.ME.hero.updateGauge(counterGauge / maxGauge);
			
			
			//trace(counterGauge);
		}
		
	// UI TOP
		txtDistance.text = Std.int(Game.ME.distEnd) + " meters";
	}
}