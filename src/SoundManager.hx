package;

import mt.flash.Sfx;

/**
 * ...
 * @author Tipyx
 */
class SoundManager
{
	static var SBANK 					= Sfx.importDirectory("res/sfx");
	
	static var sMusic					: mt.flash.Sfx;
	
	static var sJump					: mt.flash.Sfx;
	static var sDJump					: mt.flash.Sfx;
	
	static var VOLUME					= 1;

	public static function INIT() {
		//sMusic = SBANK.main();
		
		sJump = SBANK.jump();
		sDJump = SBANK.djump(); 
	}
	
	public static function MUSIC() {
		//sMusic.playLoop(999999, VOLUME);
	}
	
	public static function JUMP() {
		sJump.play(1);
	}
	
	public static function DJUMP() {
		sDJump.play(1);
	}
}