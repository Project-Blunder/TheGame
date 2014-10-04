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
	
	var speed:Float = 10;
	var reactionTime:Float = 0.1;
	var slideTime:Float = 0.35;
	
	var attackDist:Int = 15;
	
	var target:Entity = EntityManager.instance.GetEntityByTag("player");
	
	var direction:Int = 0;
	
	public function init()
	{	
		debugText.color = 0xFFFF0000;
		EntityManager.instance.AddFlxBasic(debugText);
		
		owner.y = Reg.height - owner.height - 1;
		owner.width = 26;
		owner.health = 2;
		owner.drag.x = 350;
		owner.drag.y = 300;
		
		speed = Reg.zombieBaseSpeed * 3;
		
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
			
			owner.animation.play("slide");
			
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
		
		if (getXDist(target) < attackDist)
		{
			owner.FSM.PushState(attack);
			return;
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
	}
	
	function attack()
	{
		if (target.y + target.height > owner.y - 2)
		{
			if (currentState != "attack")
			{
				owner.animation.play("attack");
			}
			else
			{
				if (owner.animation.finished)
				{
						if (getXDist(target) < attackDist)
						{
							target.getVarAsDynamic("hit")();
						}
					owner.FSM.PopState();
					return; 
				}
			}
		}
		else
		{
			owner.FSM.PopState();
		}
		
		currentState = "attack";
	}
	
	function hit(high:Bool)
	{
		if (owner.alive)
		{
			Reg.zombiesKilled++;
			owner.animation.play("die");
			owner.alive = false;
			owner.FSM.destroy();
			owner.scripts.Destroy();
		}
		/*if (!doneDead && owner.animation.finished)
		{
			FlxG.sound.play("assets/sounds/deathsolo.mp3");
			doneDead = true;
		}*/
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