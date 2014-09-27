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

class EnemyCanine
{
	//#
	var owner:Entity;
	//#
	
	var debugText:FlxText = new FlxText();
	
	var timer:Float = 0;
	var slideTimer:Float = 0;
	var currentState:String = "";
	
	var rand = new FlxRandom();
	
	var speed:Float = 80;//rand.float(25 - 1, 25 + 1);
	var reactionTime:Float = 0.1;//rand.float(0.05, 0.15);
	var slideTime:Float = 0.35;
	var attackDist:Int = 60;
	
	var target:Entity = EntityManager.instance.GetEntityByTag("player");
	var group:EntityGroup = EntityManager.instance.GetGroup("enemies");
	
	var jumpForce:Float = 230;
	var gravity:Float = 100;
	
	var floorHeight:Int;
	var groundTimer:Float = 0;
	var jumpDelay:Float = 0.35;
	
	var direction:Int = 0;
	
	public function init()
	{	
		debugText.color = 0xFFFF0000;
		EntityManager.instance.AddFlxBasic(debugText);
		
		//owner.makeGraphic(17, 17, FlxColorWrap.RED);
		
		owner.y = Reg.height - owner.height - 1;
		owner.width = 11;
		owner.offset.x = 8;	
		owner.health = 2;
		owner.drag.x = 350;
		owner.drag.y = 300;
		
		floorHeight = Reg.height - owner.height - 1;	
	
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
		owner.y += gravity * FlxG.elapsed;
		if (owner.y > floorHeight)
		{
			owner.y = floorHeight;
			owner.velocity.y = 0;
		}
		if (owner.y == floorHeight)
		{
			groundTimer += FlxG.elapsed;
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
		
		owner.animation.play("run");
		
		if (slideTimer > 0)
		{
			slideTimer -= FlxG.elapsed;
			
			if (slideTimer <= 0)
			{
				direction = owner.facing;
			}
		}
		
		if (direction == FlxObject.LEFT)
		{
			owner.x -= speed * FlxG.elapsed;
		}
		else
		{
			owner.x += speed * FlxG.elapsed;
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
					slideTimer = slideTime;
				}
				else
				{
					owner.facing = FlxObject.LEFT;
					slideTimer = slideTime;
				}
			}
		}
		
		if (groundTimer > jumpDelay && isFacing(target) && getXDist(target) < attackDist)
		{
			//owner.FSM.PushState(jump);
		}
	}
	
	function jump()
	{
		groundTimer = 0;
		
		owner.velocity.y -= jumpForce;

		owner.animation.play("jump");
		
		owner.FSM.ReplaceState(midAir);
	}
	
	function midAir()
	{
		if (owner.facing == FlxObject.LEFT)
		{
			owner.velocity.x = -100;
		}
		else
		{
			owner.velocity.x = 100;
		}
		
		if (owner.y == floorHeight)
		{
			owner.velocity.x = 0;
			owner.FSM.PopState();
		}
	}
	
	function attack()
	{
		currentState = "attack";
	}
	
	function stunned()
	{
		currentState = "stunned";
	}
	
	function hit(high:Bool)
	{
		currentState = "hit";
	}
	
	function knocked()
	{
		currentState = "knocked";
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