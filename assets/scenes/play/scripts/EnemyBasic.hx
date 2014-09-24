package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import ice.entity.Entity;
import flixel.math.FlxRandom;
import ice.entity.EntityManager;
import flixel.FlxObject;
import ice.group.EntityGroup;
import ice.wrappers.FlxColorWrap;
import flixel.util.FlxSpriteUtil;
import openfl.Assets;
import SceneLoader;
import Reg;
import Math;

class EnemyBasic
{
	//#
	var owner:Entity;
	//#
	
	var debugText:FlxText = new FlxText();
	
	var timer:Float = 0;
	var currentState:String = "";
	
	var rand = new FlxRandom();
	
	var speed:Float = rand.float(25 - 1, 25 + 1);
	var reactionTime:Float = rand.float(0.05, 0.15);
	var stunnedChance:Float = 35;
	var swatChance:Float = 25;
	
	var grabDist:Float = 7;
	var separateDist:Float;
	var moveAnyway:Bool = false;
	
	var target:Entity = EntityManager.instance.GetEntityByTag("player");
	var group:EntityGroup = EntityManager.instance.GetGroup("enemies");
	
	public function init()
	{	
		debugText.color = 0xFFFF0000;
		EntityManager.instance.AddFlxBasic(debugText);
		
		owner.y = Reg.height - owner.height - 1;
		owner.width = 11;
		owner.offset.x = 8;	
		owner.health = 2;
		owner.drag.x = 350;
		
		separateDist = owner.width;
	
		owner.setFacingFlip(FlxObject.LEFT, true, false);
		owner.setFacingFlip(FlxObject.RIGHT, false, false);
		
		owner.FSM.PushState(hunt);
	}
	
	public function update()
	{		
		if (Reg.showDebug)
		{
			debugText.visible = true;
			debugText.x = owner.x + owner.width / 2 - debugText.width / 2;
			debugText.y = owner.y - debugText.textField.textHeight;
			
			setDebug(Math.round(owner.GetDistance(target)) +"\n" +currentState);
			FlxSpriteUtil.drawRect(SceneLoader.debug, Math.round(owner.getMidpoint().x-2), Math.round(owner.getMidpoint().y-2), 4, 4, FlxColorWrap.GREEN);
		}
		else
		{
			debugText.visible = false;
		}
	}
	
	public function destroy()
	{
		debugText.destroy();
	}
	
	//@
	function hunt()
	{
		currentState = "hunt";
		
		var move:Bool = true;
		//Attempts to combat grouping
		/*if (!moveAnyway)
		{
			for (e in group.members)
			{
				if (e == null)
				{
					continue;
				}
				if (e.GID == owner.GID)
				{
					continue;
				}
				if (owner.GetDistance(target) > grabDist + 3 && owner.GetDistance(e) < separateDist)
				{
					move = false;
					e.setVar("moveAnyway", true);
					break;
				}
			}
		}
		else
		{
			moveAnyway = false;
		}*/
		if(move)
		{
			if (owner.facing == FlxObject.LEFT)
			{
				if (getXDist(target) > grabDist)
				{
					owner.x -= speed * FlxG.elapsed;
					owner.animation.play("walk");
				}
				else
				{
					owner.FSM.PushState(attack);
					attack();
				}
			}
			else
			{
				if (getXDist(target) > grabDist)
				{
					owner.x += speed * FlxG.elapsed;
					owner.animation.play("walk");
				}
				else
				{
					owner.FSM.PushState(attack);
					attack();
				}
			}
			if (!isFacing(target))
			{
				timer += FlxG.elapsed;
				if (timer > reactionTime)
				{
					timer = 0;
					if (owner.facing == FlxObject.LEFT)
					{
						owner.facing = FlxObject.RIGHT;
					}
					else
					{
						owner.facing = FlxObject.LEFT;
					}
				}
			}
		}
	}
	
	function attack()
	{
		if (owner.GetDistance(target) <= grabDist + 2)
		{
			if(owner.getMidpoint().y - target.getMidpoint().y < owner.height / 2)
			{
				if (currentState == "attack")
				{
					if (owner.animation.finished)
					{
						target.getVarAsDynamic("hit")();
					}
				}
				else
				{
					if (rand.bool(swatChance))
					{
						owner.animation.play("swat");
						target.getVarAsDynamic("hit")();
						return;
					}
				}
				
				owner.animation.play("scary");
				
				if (target.getMidpoint().x < owner.getMidpoint().x)
				{
					owner.facing = FlxObject.LEFT;
				}
				else
				{
					owner.facing = FlxObject.RIGHT;
				}
			}
		}
		else
		{
			owner.FSM.PopState();
		}
		currentState = "attack";
		//FlxG.sound.play("assets/sounds/Eating.wav");
	}
	
	function grab()
	{
		currentState = "grab";
		owner.animation.play("grab");
		
		
		target.getVarAsDynamic("getCaught")();
		
		var tween:Dynamic = newObject();
		tween.x = owner.getMidpoint().x - target.width / 2;
		FlxTween.tween(target, tween, 0.07);
		
		timer = 0;
		owner.FSM.PushState(hold);
	}
	
	function hold()
	{
		currentState = "hold";
		owner.animation.play("hold");
		
		if (timer < 1)
		{
			timer += FlxG.elapsed;
		}
		else
		{
			if (target.x != owner.getMidpoint().x - target.width / 2)
			{
				timer = 0;
				owner.FSM.ReplaceState(stunned);
			}
		}
	}
	
	function stunned()
	{
		currentState = "stunned";
		owner.animation.play("stunned");
		if (timer < 1.5)
		{
			timer += FlxG.elapsed;
		}
		else
		{
			owner.FSM.PopState();
		}
	}
	
	function hit(high:Bool)
	{
		currentState = "hit";
		
		FlxG.sound.play("assets/sounds/Thump.wav");
		
		
		timer = 0;
		owner.health--;
		if (owner.health == 0)
		{
			owner.destroy();
			EntityManager.instance.GetGroup("enemies").remove(owner);
			return;
		}
		
		if (target.getMidpoint().x > owner.getMidpoint().x)
		{
			owner.velocity.x = -175;
		}
		else
		{
			owner.velocity.x = 175;
		}
		
		owner.animation.play("hit");
		
		var info = newObject();
		info.high = high;
		owner.FSM.PushState(knocked, info);
	}
	
	function knocked()
	{
		currentState = "knocked";
		
		if (owner.velocity.x == 0)
		{
			if (owner.FSM.info.high)
			{
				if (rand.bool(stunnedChance))
				{
					owner.FSM.ReplaceState(stunned);
				}
				else
				{
					owner.FSM.PopState();
				}
			}
			else
			{
				if (rand.bool(stunnedChance * 2))
				{
					owner.FSM.ReplaceState(stunned);
				}
				else
				{
					owner.FSM.PopState();
				}
			}
		}
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
	//@
}