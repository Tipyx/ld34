package;

import h2d.Sprite;

/**
 * ...
 * @author Tipyx
 */
class Boss extends Sprite
{

	public function new() 
	{
		super();
		
		var arm1 = new ASprite(Settings.SLB, "boss_arm");
		arm1.setGeneralSpeed(30);
		this.addChild(arm1);
		
		var arm2 = new ASprite(Settings.SLB, "boss_arm");
		arm2.play(arm2.frames, Std.random(11));
		arm2.x = - 15;
		arm2.y = 10;
		arm2.setGeneralSpeed(30);
		this.addChild(arm2);
		
		var arm3 = new ASprite(Settings.SLB, "boss_arm");
		arm3.play(arm3.frames, Std.random(11));
		arm2.x = - 25;
		arm3.y = -10;
		arm3.setGeneralSpeed(30);
		this.addChild(arm3);
		
		var arm4 = new ASprite(Settings.SLB, "boss_arm");
		arm4.play(arm4.frames, Std.random(11));
		arm4.y = -15;
		arm4.setGeneralSpeed(30);
		this.addChild(arm4);
		
		var head = new ASprite(Settings.SLB, "boss_head");
		head.setGeneralSpeed(20);
		this.addChild(head);
	}
	
}