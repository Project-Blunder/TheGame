package ; 

import flixel.system.FlxBasePreloader;
import flixel.util.FlxStringUtil;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.display.Stage;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;


import GraveyPreloader.BG;
import GraveyPreloader.Pfont;

//import GraveyPreloader.L;

@:bitmap("assets/scenes/preloader/zombiesplit.png") class BG extends flash.display.BitmapData { }
//@:bitmap("assets/images/logo.png") class L extends flash.dis play.BitmapData { }

@:font("assets/fonts/PixAntiqua.ttf") class Pfont extends Font {}


#if js
class GraveyPreloader extends NMEPreloader {}
#else

class GraveyPreloader extends IceBasePreloader
{
	
	var percentage: Bitmap;
	var format: TextFormat;
	var zombie: Bitmap;
	var color: Dynamic;
	
	var percentStart:Float = 0;
	
	public function new () 
	{
		super(2, ["www.kongregate.com", "http://nicom1.github.io/", FlxBasePreloader.LOCAL]);
	}

	override private function create():Void	
	{	
		var bgd:BitmapData = new BitmapData(640, 480, false, 0xFFFFFFFF);
		var bg:Bitmap = new Bitmap(bgd);
		
		zombie = new Bitmap(new BG(0, 0));
		zombie.scaleX = 640 / 160;
		zombie.scaleY = 480 / 120;
		zombie.x = Math.floor(320 - zombie.width / 2);
		zombie.y = Math.floor(240 - zombie.height / 2);
		
		var overlay:BitmapData = new BitmapData(9, 26, false, 0xFFFFFFFF);
		percentage = new Bitmap(overlay);
		percentage.scaleX = 640 / 160;
		percentage.scaleY = 480 / 120;
		percentage.x = zombie.x;
		percentage.y = zombie.y;
		percentStart = percentage.y;
		
		addChild(bg);
		addChild(zombie);
		addChild(percentage);
	}
	
	override public function update(Percent:Float):Void
	{
		percentage.y = percentStart - Math.ceil((Percent * percentage.height) / 4) * 4;
	}
	
	override public function destroy():Void
	{
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);

		// How to destroy? like this:
		// something = null;

		percentage = null;
		format = null;
		outline = null;
		progress = null;
		zombie = null;
		outline = null;
		color = null;
	}
}
#end