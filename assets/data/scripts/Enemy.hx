package ;

import flixel.FlxG;
import ice.entity.Entity;
import flixel.math.FlxRandom;
import ice.entity.EntityManager;
import flixel.FlxObject;
import Reg;

class Enemy
{
	//#
	var owner:Entity;
	//#
	
	var speed:Float = 25;
	
	var target:Entity;
	
	public function init()
	{
		//owner.makeGraphic(12, 24, 0xffff0000);
		
		owner.y = Reg.height - owner.height - 1;
		
		target = EntityManager.instance.GetEntityByTag("player");
		
		var rand = new FlxRandom();
		
		if (rand.sign() > 0)
		{
			owner.x = FlxG.width - owner.width - 25;
		}
		else
		{
			owner.x = 25;//-owner.width;
		}
	
		owner.setFacingFlip(FlxObject.RIGHT, false, false);
		owner.setFacingFlip(FlxObject.LEFT, true, false);
	
	}
	
	public function update()
	{	
		owner.animation.play("idle");
		
		if (owner.x > target.x + target.width/2 + owner.width/2)
		{
			owner.x -= speed * FlxG.elapsed;
			owner.facing = FlxObject.LEFT;
			owner.animation.play("walk");
		}
		else if (owner.x < target.x - owner.width)
		{
			owner.x += speed * FlxG.elapsed;
			owner.facing = FlxObject.RIGHT;
			owner.animation.play("walk");
		}
	}
}