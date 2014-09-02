package ;

import flixel.FlxG;
import ice.entity.Entity;
import flixel.util.FlxRandom;

class Enemy
{
	//#
	var owner:Entity;
	//#
	
	public function init()
	{
		//owner.makeGraphic(12, 24, 0xffff0000);
		
		owner.y = FlxG.height - owner.height;
		
		if (FlxRandom.sign() > 0)
		{
			owner.x = FlxG.width / 2 + owner.width;
		}
		else
		{
			owner.x = FlxG.width / 2 - owner.width;
		}
	}
}