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
	var grabDist:Float = 10;
	
	var debug:FlxSprite = new FlxSprite();
	
	var timer:Float;
	
	public function init()
	{	
		debug.makeGraphic(1, 1, FlxColorWrap.RED);
		
		owner.y = Reg.height - owner.height - 1;
		owner.width = 11;
		owner.offset.x = 1;
		
		target = EntityManager.instance.GetEntityByTag("player");
		
		var rand = new FlxRandom();
		
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
		else 
		{
			owner.FSM.PushState(grab);
		}
	}
	
	function grab()
	{
		owner.animation.play("grab");
		
		var tween:Dynamic = newObject();
		tween.x = owner.getMidpoint().x - target.width / 2;
		FlxTween.tween(target, tween, 0.07);
		
		target.getVarAsDynamic("getCaught")();
		
		timer = 0;
		owner.FSM.ReplaceState(hold);
	}
	
	function hold()
	{
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
	//@
}