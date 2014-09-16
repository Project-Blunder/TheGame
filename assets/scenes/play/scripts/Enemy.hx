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
import SceneLoader;
import Reg;
import Math;

class Enemy
{
	//#
	var owner:Entity;
	//#
	
	var debugText:FlxText = new FlxText();
	
	var timer:Float;
	var currentState:String = "";
	
	var rand = new FlxRandom();
	
	var speed:Float = rand.float(25 - 1, 25 + 1);
	var stunnedChance:Float = 35;
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
		if (!moveAnyway)
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
		}
		if(move)
		{
			if (owner.getMidpoint().x > target.getMidpoint().x + grabDist)
			{
				owner.x -= speed * FlxG.elapsed;
				owner.facing = FlxObject.LEFT;
				owner.animation.play("walk");
			}
			else if (owner.getMidpoint().x < target.getMidpoint().x - grabDist)
			{
				owner.x += speed * FlxG.elapsed;
				owner.facing = FlxObject.RIGHT;
				owner.animation.play("walk");
			}
			else if(owner.getMidpoint().y - target.getMidpoint().y < owner.height / 2)
			{
				//grab();
				owner.FSM.PushState(attack);
				attack();
			}
		}
	}
	
	function attack()
	{
		currentState = "attack";
		if (owner.GetDistance(target) <= grabDist + 2)
		{
			if(owner.getMidpoint().y - target.getMidpoint().y < owner.height / 2)
			{
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
	//@
}