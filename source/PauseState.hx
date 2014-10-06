package ;
import flixel.FlxG;
import flixel.FlxSubState;

/**
 * ...
 * @author 
 */
class PauseState extends FlxSubState
{
	public function new() 
	{
		FlxG.sound.muted = true;
		super();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.keys.justPressed.P)
		{
			FlxG.sound.muted = false;
			close();
		}
		super.update(elapsed);
	}
}