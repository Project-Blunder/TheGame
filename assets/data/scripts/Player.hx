package ;

import ice.entity.Entity;
import flixel.FlxG;

class Player
{
	//#
	var owner:Entity;
	//#
	
	public function init() 
	{
		owner.makeGraphic(12, 24, 0xff0000ff);
		owner.x = FlxG.width / 2 - owner.width / 2;
		owner.y = FlxG.height - owner.height;
	}
	
	public function update()
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.camera.shake(0.01, 0.2);
		}
	}
}