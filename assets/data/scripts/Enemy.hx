package ;

import flixel.FlxG;
import ice.entity.Entity;
import flixel.math.FlxRandom;

class Enemy
{
	//#
	var owner:Entity;
	//#
	
	var speed:Float = 25;
	
	public function init()
	{
		owner.makeGraphic(12, 24, 0xffff0000);
		
		owner.y = FlxG.height - owner.height;
		
		var rand = new FlxRandom();
		
		if (rand.sign() > 0)
		{
			owner.x = FlxG.width;
		}
		else
		{
			owner.x = -owner.width;
		}
	}
	
	public function update()
	{	
		if (owner.x > FlxG.width / 2 + owner.width / 1.2)
		{
			owner.x -= speed * FlxG.elapsed;
		}
		else if (owner.x < FlxG.width / 2 - owner.width - owner.width / 1.2)
		{
			owner.x += speed * FlxG.elapsed;
		}
	}
}