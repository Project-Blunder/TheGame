package ;

import flixel.text.FlxText;
import ice.entity.Entity;
import ice.group.EntityGroup;
import ice.wrappers.FlxColorWrap;
import ice.wrappers.FlxKeyWrap;
import flixel.FlxG;
import flixel.FlxObject;
import ice.entity.EntityManager;
import Reg;
import flixel.util.FlxSpriteUtil;
import SceneLoader;
import Math;

class Player
{
	//#
	var owner:Entity;
	//#
	
	var enemies:EntityGroup = EntityManager.instance.GetGroup("enemies");
	
	var attackDefault:Float = 0.2;
	var attackTimer:Float = -1;
	
	var attackDist:Float = 21;
	
	var attacking:Bool = false;
	
	var speed:Float = 60;
	var crouchPercent:Float = 0.4;
	
	var turns:Int = 0;
	var escapeAmount:Int = 10;
	
	var gravity:Float = 175;
	
	var caughtBool:Bool = false;
	
	var floorHeight = Reg.height - owner.height - 1;
	
	var jumpforce:Float = 300;
	
	var lineStyle = newObject();
	
	var debugText:FlxText = new FlxText();
	
	public function init() 
	{
		lineStyle.width = 1;
		lineStyle.color = 0xFFFF0000;
				
		debugText.color = 0xFFFF0000;
		EntityManager.instance.AddFlxBasic(debugText);
		
		owner.x = FlxG.width / 2 - owner.width / 2;
		owner.y = floorHeight;
		
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
		if (Reg.showDebug)
		{
			debugText.visible = true;
			debugText.x = owner.x + owner.width / 2 - debugText.width / 2;
			debugText.y = owner.y - debugText.textField.textHeight;
			for (target in enemies.members)
			{
				if (target != null)
				{
					FlxSpriteUtil.drawLine(
						SceneLoader.debug, 
						owner.getMidpoint().x, 
						owner.getMidpoint().y, 
						target.getMidpoint().x, 
						target.getMidpoint().y,
						lineStyle
					);		
				}
			}
			FlxSpriteUtil.drawRect(SceneLoader.debug, Math.round(owner.getMidpoint().x - 2), Math.round(owner.getMidpoint().y - 2), 4, 4, FlxColorWrap.GREEN);
			if (owner.facing != FlxObject.LEFT)
			{
				FlxSpriteUtil.drawRect(SceneLoader.debug, Math.round(owner.getMidpoint().x + attackDist - 1), Math.round(owner.getMidpoint().y - 2), 2, 4, FlxColorWrap.PURPLE);
			}
			else
			{
				FlxSpriteUtil.drawRect(SceneLoader.debug, Math.round(owner.getMidpoint().x - attackDist - 1), Math.round(owner.getMidpoint().y - 2), 2, 4, FlxColorWrap.PURPLE);
			}
		}
		else
		{
			debugText.visible = false;
		}
		
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

		if (owner.y > floorHeight)
		{
			owner.y = floorHeight;
		}
	}
	
	public function reload()
	{

	}
	
	//@
	function standing()
	{
		setDebug("stand");
		
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
			var info = newObject();
			info.high = true;
			owner.FSM.PushState(attack, info);
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
		
		if (owner.y >= floorHeight && FlxG.keys.anyJustPressed([FlxKeyWrap.UP, FlxKeyWrap.W]))
		{
			owner.velocity.y -= jumpforce;
			owner.FSM.PushState(jumping);
		}
	}
	
	function jumping()
	{
		setDebug("jump");
		
		if (owner.velocity.y <= 0)
		{
			owner.animation.play("fall");
		}
		if (owner.y >= floorHeight)
		{
			owner.FSM.PopState();
		}
		
		if (FlxG.keys.anyPressed([FlxKeyWrap.LEFT, FlxKeyWrap.A]))
		{
			owner.x -= speed * FlxG.elapsed;
		}
		else if (FlxG.keys.anyPressed([FlxKeyWrap.RIGHT, FlxKeyWrap.D]))
		{
			owner.x += speed * FlxG.elapsed;
		}
	}
	
	function crouching()
	{
		setDebug("crouch");
		
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
			var info = newObject();
			info.high = false;
			owner.FSM.PushState(attack, info);
		}
	}	
		
	function attack()
	{
		setDebug("attack");
		
		if (caughtBool)
		{
			owner.FSM.ReplaceState(caught);
			return;
		}
		if (!attacking)
		{
			if (owner.FSM.info.high)
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
				if (owner.FSM.info.high)
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
				for (target in enemies.members)
				{
					if (target != null)
					{						
						if (getXDist(target) < attackDist && isFacing(target))
						{
							if (owner.FSM.info.high)
							{
								target.getVarAsDynamic("hit")(true);
							}
							else
							{
								target.getVarAsDynamic("hit")(false);
							}
							break;
						}
					}
				}
				owner.FSM.ReplaceState(windDown);
			}
		}
	}
	
	function windDown()
	{
		setDebug("wind-down");
		attackTimer -= FlxG.elapsed;
		if (attackTimer < 0)
		{
			attacking = false;
			owner.FSM.PopState();
		}
	}
	
	function isFacing(target:Entity):Bool
	{
		if (target.getMidpoint().x <= owner.getMidpoint().x)
		{
			if (owner.facing == FlxObject.LEFT)
			{
				return true;
			}
		}
		if (target.getMidpoint().x >= owner.getMidpoint().x)
		{
			if (owner.facing == FlxObject.RIGHT)
			{
				return true;
			}
		}
		return false;
	}
	
	function caught()
	{
		setDebug("caught");
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
		owner.velocity.x = 0;
		owner.velocity.y = 0;
		caught();
		caughtBool = true;
	}
	
	function setDebug(t:String)
	{
		if (Reg.showDebug)
		{
			debugText.text = t;
		}
	}
	
	function getXDist(t:FlxObject):Float
	{
		return Math.abs(owner.getMidpoint().x - t.getMidpoint().x);
	}
	//@
}