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
		super();
	}
	
	override public function update(elapsed:Float):Void 
	{
		if (FlxG.keys.justPressed.P)
		{
			close();
		}
		super.update(elapsed);
	}
}