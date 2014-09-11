package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import ice.entity.Entity;
import flixel.math.FlxRandom;
import ice.entity.EntityManager;
import flixel.FlxObject;
import ice.wrappers.FlxColorWrap;
import Reg;

class Enemy
{
	//#
	var owner:Entity;
	//#
	
	var speed:Float = 25;
	
	var target:Entity;
	var grabDist:Float = 5;
	
	var debug:FlxSprite = new FlxSprite();
	
	var timer:Float;
	
	var currentState:String = "";
	
	var rand = new FlxRandom();
	
	var stunnedChance:Float = 0.35;
	
	public function init()
	{	
		debug.makeGraphic(1, 1, FlxColorWrap.RED);
		
		owner.y = Reg.height - owner.height - 1;
		owner.width = 11;
		owner.offset.x = 1;
		
		owner.health = 5;
		
		owner.drag.x = 350;
		
		target = EntityManager.instance.GetEntityByTag("player");
		
		if (rand.sign() > 0)
		{
			owner.x = FlxG.width - owner.width - 25;
		}
		else
		{
			owner.x = 25;
		}
	
		owner.setFacingFlip(FlxObject.LEFT, true, false);
		owner.setFacingFlip(FlxObject.RIGHT, false, false);
		
		owner.FSM.PushState(hunt);
	}
	
	public function update()
	{		

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
			owner.FSM.PushState(grab);
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
		owner.FSM.ReplaceState(hold);
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
	
	function hit()
	{
		if (currentState == "hunt")
		{
			owner.FSM.PushState(isHit);
		}
		else if (currentState != "hit")
		{
			owner.FSM.ReplaceState(isHit);
		}
	}
	
	function isHit()
	{
		currentState = "hit";
		
		timer = 0;
		owner.health--;
		if (owner.health == 0)
		{
			owner.destroy();
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
		
		owner.FSM.ReplaceState(knocked);
	}
	
	function knocked()
	{
		if (owner.velocity.x == 0)
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
	}
	//@
}