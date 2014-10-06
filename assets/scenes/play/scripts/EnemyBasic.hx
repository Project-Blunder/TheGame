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
	
	var crazyZombie:Bool = false;
	var burstSpeed:Float = 100;
	var burstTime:Float = 1;
	var burstTimer:Float = 0;
	var burstDelay:Float = 10;
	var burstMinDelay:Float = 2;
	var burstMaxDelay:Float = 10;
	
	var speed:Float;
	var reactionTime:Float = rand.float(0.05, 0.15);
	var stunnedChance:Float = 35;
	var swatChance:Float = 25;
	
	var grabDist:Float = 7;
	var separateDist:Float;
	var moveAnyway:Bool = false;
	
	var doneDead:Bool = false;
	
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
		
		speed = rand.float(Reg.zombieBaseSpeed - 1, Reg.zombieBaseSpeed + 1);
		
		separateDist = owner.width;
	
		owner.setFacingFlip(FlxObject.LEFT, true, false);
		owner.setFacingFlip(FlxObject.RIGHT, false, false);
		
		crazyZombie = rand.bool(Reg.burstChance);
		if (crazyZombie)
		{
			owner.color = 0xFFFF0000;
		}
		burstDelay = rand.float(burstMinDelay, burstMaxDelay);
		burstTime = Reg.burstTime;
		
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
		
		//BURST-STUFF///////////////////////////////
		if (crazyZombie)
		{
			burstTimer += FlxG.elapsed;
			if (burstTimer > burstDelay)
			{
				owner.FSM.PushState(burst);
				burstTimer = 0;
				burstDelay = rand.float(burstMinDelay, burstMaxDelay);
			}
		}
		/////////////////////////////////////////////

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
	
	function burst()
	{
		burstTimer += FlxG.elapsed;
		if (burstTimer > burstTime)
		{
			owner.FSM.PopState();
			burstTimer = 0;
		}
		
		if (owner.facing == FlxObject.LEFT)
		{
			if (getXDist(target) > grabDist)
			{
				owner.x -= burstSpeed * FlxG.elapsed;
				owner.animation.play("burst!");
			}
			else
			{
				var info = { };
				info.quick = true;
				owner.FSM.ReplaceState(attack, info);
				burstTimer = 0;
				return;
			}
		}
		else
		{
			if (getXDist(target) > grabDist)
			{
				owner.x += burstSpeed * FlxG.elapsed;
				owner.animation.play("burst!");
			}
			else
			{
				var info = { };
				info.quick = true;
				owner.FSM.ReplaceState(attack, info);
				burstTimer = 0;
				return;
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
					var swat:Bool = false;
					if (rand.bool(swatChance))
					{
						swat = true;
					}
					else if (owner.FSM.info != null && owner.FSM.info.quick)
					{
						swat = true;
					}
					if (swat)
					{
						if (currentState != "attack-swat")
						{
							owner.animation.play("swat");
							target.getVarAsDynamic("hit")();
						}
						else
						{
							if (owner.animation.finished)
							{
								owner.FSM.PopState();
							}
						}
						currentState = "attack-swat";
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
		
		//FlxG.sound.play("assets/sounds/bangsolo.mp3", 0.1);
		
		FlxG.sound.play("assets/sounds/bangsquish.mp3", 0.075 * Reg.sfxVol);
		
		
		timer = 0;
		owner.health--;
		if (owner.health == 0)
		{
			owner.FSM.PushState(die);
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
		FlxG.sound.play("assets/sounds/ouch.mp3", 0.05 * Reg.sfxVol);
		
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
	
	function die()
	{
		if (owner.alive)
		{
			Reg.zombiesKilled++;
			owner.animation.play("die");
			owner.alive = false;
			owner.scripts.Destroy();
		}
		if (!doneDead && owner.animation.finished)
		{
			FlxG.sound.play("assets/sounds/deathsolo.mp3", Reg.sfxVol);
			switch(Math.floor(rand.float(0, 3, [3])))
			{
				case 1:
					owner.animation.play("dead-1");
					
				case 2:
					owner.animation.play("dead-2");
			}
			doneDead = true;
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