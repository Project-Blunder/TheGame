package ;

import ice.entity.Entity;
import ice.wrappers.FlxKeyWrap;
import flixel.FlxG;
import flixel.FlxObject;
import ice.entity.EntityManager;
import Reg;

class Player
{
	//#
	var owner:Entity;
	//#
	
	var target:Entity = EntityManager.instance.GetEntityByTag("enemy");
	
	var attackDefault:Float = 0.2;
	var attackTimer:Float = -1;
	
	var attackDist:Float = 13;
	
	var attacking:Bool = false;
	
	var speed:Float = 60;
	var crouchPercent:Float = 0.4;
	
	var turns:Int = 0;
	var escapeAmount:Int = 10;
	
	var gravity:Float = 175;
	
	var caughtBool:Bool = false;
	
	public function init() 
	{
		owner.x = FlxG.width / 2 - owner.width / 2;
		owner.y = Reg.height - owner.height - 1;
		
		owner.offset.x = 16;
		owner.width = 5;
		
		owner.drag.x = 150;
		owner.drag.y = 300;
		
		owner.setFacingFlip(FlxObject.RIGHT, false, false);
		owner.setFacingFlip(FlxObject.LEFT, true, false);
		
		owner.FSM.PushState(standing);
	}
	
	public function update()
	{			
		if (FlxG.keys.anyPressed([FlxKeyWrap.LEFT, FlxKeyWrap.A]))
		{
			if (owner.facing != FlxObject.LEFT)
			{
				owner.facing = FlxObject.LEFT;
				turns++;
			}
		}
		else if (FlxG.keys.anyPressed([FlxKeyWrap.RIGHT, FlxKeyWrap.D]))
		{
			if (owner.facing != FlxObject.RIGHT)
			{
				owner.facing = FlxObject.RIGHT;
				turns++;
			}
		}
		
		owner.y += gravity * FlxG.elapsed;
		if (owner.y + owner.height > Reg.height - 1)
		{
			owner.y = Reg.height - 1 - owner.height;
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
		if (caughtBool)
		{
			owner.FSM.PushState(caught);
			return;
		}
		owner.animation.play("tall");
		if (FlxG.keys.anyPressed([FlxKeyWrap.S, FlxKeyWrap.DOWN]))
		{
			owner.FSM.PushState(crouching);
		}
		
		if (FlxG.keys.justPressed.SPACE)
		{
			owner.FSM.PushState(attackHigh);
		}
		
		if (FlxG.keys.anyPressed([FlxKeyWrap.LEFT, FlxKeyWrap.A]))
		{
			owner.x -= speed * FlxG.elapsed;
			owner.animation.play("walk");
		}
		else if (FlxG.keys.anyPressed([FlxKeyWrap.RIGHT, FlxKeyWrap.D]))
		{
			owner.x += speed * FlxG.elapsed;
			owner.animation.play("walk");
		}
	}
	
	function crouching()
	{
		if (caughtBool)
		{
			owner.FSM.ReplaceState(caught);
			return;
		}
		owner.animation.play("crouch");
		if (!FlxG.keys.anyPressed([FlxKeyWrap.S, FlxKeyWrap.DOWN]))
		{
			owner.FSM.PopState();
		}
		
		if (FlxG.keys.justPressed.SPACE)
		{
			owner.FSM.PushState(attackLow);
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
		if (caughtBool)
		{
			owner.FSM.ReplaceState(caught);
			return;
		}
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
			if (owner.animation.finished)
			{
				if (owner.GetDistance(target) < attackDist)
				{
					target.getVarAsDynamic("hit")();
				}
			}
			attackTimer -= FlxG.elapsed;
		}
		
		if (attackTimer < 0)
		{
			attacking = false;
			owner.FSM.PopState();
		}
	}
	
	function caught()
	{
		if (turns > escapeAmount)
		{
			owner.velocity.x += 100;
			owner.velocity.y -= 250;
			caughtBool = false;
			owner.FSM.PopState();
		}
	}
	
	function getCaught()
	{
		turns = 0;
		caughtBool = true;
	}
	//@
}