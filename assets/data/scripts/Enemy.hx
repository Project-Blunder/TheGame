package ;

import flixel.FlxG;
import ice.entity.Entity;
import flixel.math.FlxRandom;
import ice.entity.EntityManager;

class Enemy
{
	//#
	var owner:Entity;
	//#
	
	var speed:Float = 25;
	
	var target:Entity;
	
	public function init()
	{
		owner.makeGraphic(12, 24, 0xffff0000);
		
		owner.y = FlxG.height - owner.height;
		
		target = EntityManager.instance.GetEntityByTag("player");
		
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
		if (owner.x > target.x + target.width/2 + owner.width/2)
		{
			owner.x -= speed * FlxG.elapsed;
		}
		else if (owner.x < target.x - owner.width)
		{
			owner.x += speed * FlxG.elapsed;
		}
	}
}