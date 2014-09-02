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
	var attackTimer:Float = -1;
	
	var lastAnim:String = "";
	
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
			lastAnim = "crouch";
		}
		else
		{
			if (crouching)
			{
				crouching = false;
				owner.animation.play("tall");
				lastAnim = "tall";
			}
		}
		if (FlxG.keys.justPressed.SPACE && lastAnim != "attack-tall")
		{
			FlxG.camera.shake(0.01, 0.2);
			attackTimer = attackDefault;
		}
		
		if (attackTimer > 0)
		{
			owner.animation.play("attack-tall");
			lastAnim = "attack-tall";
			attackTimer -= FlxG.elapsed;
			if (attackTimer < 0)
			{
				attackTimer = -1;
			}
		}
		else
		{
			if ( attackTimer == -1 && !FlxG.keys.pressed.SPACE && lastAnim == "attack-tall")
			{
				owner.animation.play("tall");
				lastAnim = "tall";
			}
		}
	}
}