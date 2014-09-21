package ;

import flixel.FlxG;
import flixel.ui.FlxButton.GraphicButton;

/**
 * ...
 * @author sruloart
 */
class Mute extends GraphicButton
{

	public function new() 
	{
		
	}
	
	public function mute()
	{
		FlxG.sound.toggleMuted();
		FlxG.sound.muteKeys(["M"]);
	}
}