package;

import flixel.addons.api.FlxKongregate;
import flixel.system.FlxSound;
import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
	
	public static var start:Float = 0;
	public static var height:Float = 0;
	
	public static var flash:Bool = false;
	public static var html:Bool = false;
	public static var debug:Bool = false;
	
	public static var showDebug:Bool = false;
	
	public static var kongConnected:Bool = false;
	
	public static var zombiesKilled:Int = 0;
	
	public static var roundTime:Float = 0;
	
	public static var waves:Int = 0;
	
	public static var zombieBaseSpeed:Float = 25;
	public static var burstChance:Float = 0;
	public static var burstTime:Float = 0.5;
	public static var dogChance:Float = 0;
	
	public static var sfxVol:Float = 1;
	public static var musicVol:Float = 1;
	
	public static var amb:FlxSound;
	public static var music:FlxSound;
	
}