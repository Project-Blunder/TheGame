package ;

import ice.entity.Entity;
import flixel.FlxG;
import flixel.FlxObject;
import ice.entity.EntityManager;

class Player
{
	//#
	var owner:Entity;
	//#
	
	var target:Entity = EntityManager.instance.GetEntityByTag("enemy");
	
	var attackDefault:Float = 0.2;
	var attackTimer:Float = -1;
	
	var attacking:Bool = false;
	
	var speed:Float = 60;
	var crouchPercent:Float = 0.4;
	
	public function init() 
	{
		owner.x = FlxG.width / 2 - owner.width / 2;
		owner.y = FlxG.height - owner.height - 1;
		
		owner.setFacingFlip(FlxObject.RIGHT, false, false);
		owner.setFacingFlip(FlxObject.LEFT, true, false);
		
		owner.FSM.PushState(standing);
	}
	
	public function update()
	{			
		if (FlxG.keys.pressed.A)
		{
			owner.facing = FlxObject.LEFT;
		}
		else if (FlxG.keys.pressed.D)
		{
			owner.facing = FlxObject.RIGHT;
		}
	}
	
	public function reload()
	{

	}
	
	//@
	function test()
	{
		trace("Test");
	}
	
	function standing()
	{
		owner.animation.play("tall");
		if (FlxG.keys.pressed.S)
		{
			owner.FSM.PushState(crouching);
		}
		
		if (FlxG.keys.justPressed.SPACE)
		{
			owner.FSM.PushState(attackHigh);
		}
		
		if (FlxG.keys.pressed.A)
		{
			owner.x -= speed * FlxG.elapsed;
			owner.animation.play("walk");
		}
		else if (FlxG.keys.pressed.D)
		{
			owner.x += speed * FlxG.elapsed;
			owner.animation.play("walk");
		}
	}
	
	function crouching()
	{
		owner.animation.play("crouch");
		if (!FlxG.keys.pressed.S)
		{
			owner.FSM.PopState();
		}
		
		if (FlxG.keys.justPressed.SPACE)
		{
			owner.FSM.PushState(attackLow);
		}
		
		if (FlxG.keys.pressed.A)
		{
			owner.x -= speed * crouchPercent * FlxG.elapsed;
		}
		else if (FlxG.keys.pressed.D)
		{
			owner.x += speed * crouchPercent * FlxG.elapsed;
		}
	}
	
	function attackHigh()
	{
		attack(true);
	}
	
	function attackLow()
	{
		attack(false);
	}	
		
	function attack(high:Bool)
	{
		if (!attacking)
		{
			if (high)
			{
				owner.animation.play("windup");
			}
			else
			{
				owner.animation.play("windup-crouch");
			}
			
			if (attackTimer < 0)
			{
				attackTimer = attackDefault;
			}
			
			if (FlxG.keys.justReleased.SPACE)
			{
				if (high)
				{
					owner.animation.play("attack-tall");
				}
				else
				{
					owner.animation.play("attack-crouch");
				}
				FlxG.camera.shake(0.01, 0.2);
				attacking = true;
			}
		}
		else
		{
			attackTimer -= FlxG.elapsed;
		}
		
		if (attackTimer < 0)
		{
			attacking = false;
			owner.FSM.PopState();
		}
	}
	//@
}