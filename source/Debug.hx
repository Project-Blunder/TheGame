package ;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;

class Debug extends FlxSprite
{

	public function new() 
	{
		super();
		makeGraphic(FlxG.width, FlxG.height, FlxColor.TRANSPARENT);
	}
	
	public function clear()
	{
		FlxSpriteUtil.fill(this, FlxColor.TRANSPARENT);
	}
}