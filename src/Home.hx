package;

import h2d.Layers;

/**
 * ...
 * @author Tipyx
 */
class Home extends Layers
{
	var txtDistance				: h2d.Text;
	
	var keyEnable				: Bool;

	public function new() 
	{
		super();
		
		keyEnable = true;
		
		txtDistance = new h2d.Text(Settings.FONT_2, this);
		txtDistance.text = "Press UP to begin";
		txtDistance.maxWidth = 300;
		txtDistance.textAlign = Center;
		txtDistance.x = Std.int((Settings.STAGE_WIDTH - txtDistance.maxWidth) * 0.5);
		txtDistance.y = Std.int(Settings.STAGE_HEIGHT * 0.5);
	}
	
	public function destroy() {
		txtDistance.remove();
		
		super.remove();
	}
	
	public function update() {
		if (keyEnable && hxd.Key.isReleased(hxd.Key.UP)) {
			keyEnable = false;
			Main.ME.launchGame();
		}
	}
}