package ;

import ice.entity.EntityManager;
import ice.group.EntityGroup;
import ice.entity.Entity;
import ice.wrappers.FlxColorWrap;
import ice.wrappers.FlxKeyWrap;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxSpriteUtil;
import flixel.FlxObject;

import SceneLoader;
import Reg;
import Math;

class Player
{
	//#
	var owner:Entity;
	//#
	
	//Groups/////////////////////////////////////////////////////////////
	var enemies:EntityGroup = EntityManager.instance.GetGroup("enemies");
	//////////////////////////////////////////////////////////////////////
		
	//Attacking////////////////////
	var attackDist:Float = 21;
	var attacking:Bool = false;
	var attackDefault:Float = 0.2;
	var attackTimer:Float = -1;
	//////////////////////////////
		
	//Caught///////////////////////
	var caughtBool:Bool = false;
	var turns:Int = 0;
	var escapeAmount:Int = 10;
	////////////////////////////////
	
	//Defaults////////////////////////
	var speed:Float = 60;	
	var startingHealth:Int = 10;
	var floorHeight = Reg.height - owner.height - 1;	
	var gravity:Float = 175;
	var jumpforce:Float = 300;
	//////////////////////////////
	
	//Debug///////////////////////////////
	var lineStyle = newObject();
	var debugText:FlxText = new FlxText();
	//////////////////////////////////////
	
	public function init() 
	{
		//Debug///////////////////////////////////////
		lineStyle.width = 1;
		lineStyle.color = 0xFFFF0000;			
		debugText.color = 0xFFFF0000;
		EntityManager.instance.AddFlxBasic(debugText);
		//////////////////////////////////////////////
		
		
		//Setup////////////////////////////////////////
		owner.x = FlxG.width / 2 - owner.width / 2;
		owner.y = floorHeight;

		owner.offset.x = 16;
		owner.width = 5;
		
		owner.drag.x = 150;
		owner.drag.y = 300;
		
		owner.health = startingHealth;
		
		owner.setFacingFlip(FlxObject.RIGHT, false, false);
		owner.setFacingFlip(FlxObject.LEFT, true, false);
		///////////////////////////////////////////////////
		
		//Start-Up/////////////////////////////
		owner.FSM.PushState(standing);
		////////////////////////////////
	}
	
	public function update()
	{	
		//Debug/////////////////////////////////////////////////////////////////////////////////////
		if (Reg.showDebug)
		{
			debugText.visible = true;
			debugText.x = owner.x + owner.width / 2 - debugText.width / 2;
			debugText.y = owner.y - debugText.textField.textHeight;
			
			//Draw a line to all enemies
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
			
			//Draw a square in the players center
			FlxSpriteUtil.drawRect(
				SceneLoader.debug, 
				Math.round(owner.getMidpoint().x - 2), 
				Math.round(owner.getMidpoint().y - 2), 
				4,
				4, 
				FlxColorWrap.GREEN
			);
			
			//Draw where the attack distance maxes out
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
		//////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		//Flip player
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
		
		//Add gravity
		owner.y += gravity * FlxG.elapsed;

		//Lock to floor
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
		
		//handle getting caught
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
		
		//transition to attack
		if (FlxG.keys.justPressed.SPACE)
		{
			var info = newObject();
			info.high = true;
			owner.FSM.PushState(attack, info);
		}
		
		//movement
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
		
		//jumping
		if (owner.y >= floorHeight && FlxG.keys.anyJustPressed([FlxKeyWrap.UP, FlxKeyWrap.W]))
		{
			owner.velocity.y -= jumpforce;
			owner.FSM.PushState(jumping);
		}
	}
	
	function jumping()
	{
		setDebug("jump");
		
		//play anim
		if (owner.velocity.y <= 0)
		{
			owner.animation.play("fall");
		}
		
		//transtion back to standing
		if (owner.y >= floorHeight)
		{
			owner.FSM.PopState();
		}
		
		//movement
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
		
		//back to standing on key release
		if (!FlxG.keys.anyPressed([FlxKeyWrap.S, FlxKeyWrap.DOWN]))
		{
			owner.FSM.PopState();
		}
		
		//low-attack
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
		
		//wind-up
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
			
			//set-up timer for wind-down
			if (attackTimer < 0)
			{
				attackTimer = attackDefault;
			}
			
			//on release play attack anim
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
		else //now we're attacking
		{
			if (owner.animation.finished) //when strike is finished:
			{
				for (target in enemies.members)
				{
					if (target != null)
					{						
						if (getXDist(target) < attackDist && isFacing(target))
						{
							//Hit just one enemy
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
				//transition to wind-down
				owner.FSM.ReplaceState(windDown);
			}
		}
	}
	
	function windDown()
	{
		setDebug("wind-down");
		
		//just wait for a bit until we go back to standing
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
	
	function hit()
	{
		
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