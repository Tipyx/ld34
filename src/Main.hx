package;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Tipyx
 */
class Main  extends hxd.App {
	public static var ME			: Main;
	
	override function init() {
		ME = this;
	}
	
	static function main() {
		hxd.Res.initEmbed();
		
		new Main();
	}
	
}