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
	var attackDefault:Float = 0.2;
	var attackTimer:Float = 0;
	
	public function init() 
	{
		owner.x = FlxG.width / 2 - owner.width / 2;
		owner.y = FlxG.height - owner.height;
	}
	
	public function update()
	{
		if (FlxG.keys.pressed.S)
		{
			crouching = true;
			owner.animation.play("crouch");
			//owner.y = FlxG.height - owner.height + 8;
		}
		else
		{
			if (crouching)
			{
				crouching = false;
				owner.animation.play("tall");
				//owner.y = FlxG.height - owner.height;
			}
		}
		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.camera.shake(0.01, 0.2);
			attackTimer = attackDefault;
		}
		
		if (attackTimer > 0)
		{
			owner.animation.play("attack-tall");
			attackTimer -= FlxG.elapsed;
		}
		else
		{
			if (owner.animation.name != "tall" && !FlxG.keys.pressed.SPACE)
			{
				owner.animation.play("tall");
			}
		}
	}
}