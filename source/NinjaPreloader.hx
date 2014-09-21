package ; 

import flixel.system.FlxBasePreloader;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.events.Event;
import flash.display.Stage;
import flash.Lib;
import flash.display.Sprite;
import openfl.text.Font;
import openfl.text.TextField;
import openfl.text.TextFormat;


import NinjaPreloader.BG;
import NinjaPreloader.Pfont;

//import GraveyPreloader.L;

@:bitmap("assets/scenes/preloader/background.png") class BG extends flash.display.BitmapData { }
//@:bitmap("assets/images/logo.png") class L extends flash.dis play.BitmapData { }

@:font("assets/fonts/PixAntiqua.ttf") class Pfont extends Font {}


#if js
class NinjaPreloader extends NMEPreloader {}
#else

class NinjaPreloader extends FlxBasePreloader
{
	
	var percentage: TextField;
	var format: TextFormat;
	var background: Bitmap;
	var color: Dynamic;
	
	public function new () 
	{
		super(2);
	}

	override private function create():Void	
	{	

	//add a background image if you need one
	background = new Bitmap(new BG(0,0));
	background.smoothing = true;
	addChild(background);
	
	//add a loading bar, NMEPreloader style
	var color = 0x000000;

	outline = new Sprite ();
	outline.graphics.lineStyle (5, color, 1, true);
	outline.graphics.drawRect (0, 0, 522, 30);
	outline.x = 56;
	outline.y = 350;
	addChild (outline);

	progress = new Sprite ();
	progress.graphics.beginFill (color, 1);
	progress.graphics.drawRect (0, 0, 522-2, 30-2);
	progress.width = stage.width;
	progress.height = 30;
	progress.x = 56;
	progress.y = 350;
	progress.scaleX = 0;
	addChild (progress);

	//And some perecntages textfield
	Font.registerFont (Pfont);

	format = new TextFormat ("PixAntiqua", outline.height - 10, 0xC0C0C0);
	
	percentage = new TextField ();

	percentage.defaultTextFormat = format;
	percentage.embedFonts = true;
	percentage.selectable = false;
	percentage.x = outline.x + Math.floor(outline.width/2 - 10);
	percentage.y = outline.y + outline.height - 35;
	addChild (percentage);

	
	//add a logo
	
	}
	
	override public function update(Percent:Float):Void
	{
	progress.scaleX = Percent;
	percentage.text = Std.string(Std.int(Percent*100));
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
		background = null;
		outline = null;
		color = null;
	}
	
}
#end