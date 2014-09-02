package ;

import ice.entity.Entity;
import flixel.FlxG;

class Player
{
	//#
	var owner:Entity;
	//#
	
	var target:Entity;
	
	var crouching:Bool = false;
	
	public function init() 
	{
		owner.makeGraphic(12, 24, 0xff0000ff);
		owner.x = FlxG.width / 2 - owner.width / 2;
		owner.y = FlxG.height - owner.height;
	}
	
	public function update()
	{
		if (FlxG.keys.pressed.S)
		{
			crouching = true;
			owner.y = FlxG.height - owner.height + 8;
		}
		else
		{
			if (crouching)
			{
				crouching = false;
				owner.y = FlxG.height - owner.height;
			}
		}
		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.camera.shake(0.01, 0.2);
		}
	}
}