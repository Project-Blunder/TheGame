package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import ice.entity.Entity;
import flixel.math.FlxRandom;
import ice.entity.EntityManager;
import flixel.FlxObject;
import ice.wrappers.FlxColorWrap;
import Reg;
import Math;

class Enemy
{
	//#
	var owner:Entity;
	//#
	
	var speed:Float = 25;
	
	var target:Entity;
	var grabDist:Float = 5;
	
	var timer:Float;
	
	var currentState:String = "";
	
	var rand = new FlxRandom();
	
	var stunnedChance:Float = 35;
	
	var debugText:FlxText = new FlxText();
	
	public function init()
	{	
		debugText.color = 0xFFFF0000;
		EntityManager.instance.AddFlxBasic(debugText);
		
		owner.y = Reg.height - owner.height - 1;
		owner.width = 11;
		owner.offset.x = 8;
		
		owner.health = 2;
		
		owner.drag.x = 350;
		
		target = EntityManager.instance.GetEntityByTag("player");
	
		owner.setFacingFlip(FlxObject.LEFT, true, false);
		owner.setFacingFlip(FlxObject.RIGHT, false, false);
		
		owner.FSM.PushState(hunt);
	}
	
	public function update()
	{		
		if (Reg.showDebug)
		{
			debugText.x = owner.x + owner.width / 2 - debugText.width / 2;
			debugText.y = owner.y - debugText.textField.textHeight;
			
			setDebug(Math.round(owner.GetDistance(target)) +"\n" +currentState);
		}
	}
	
	//@
	function hunt()
	{
		currentState = "hunt";
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
			grab();
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