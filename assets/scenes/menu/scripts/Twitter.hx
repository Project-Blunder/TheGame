package ;

import flixel.FlxG;
import ice.entity.Entity;
import ice.entity.EntityManager;
import ice.wrappers.FlxKeyWrap;
import Reg;
import googleAnalytics.Stats;

class Twitter
{
	//#
	var owner:Entity;
	//#
	
	var speed:Float = 170;
	
	var player:Entity = EntityManager.instance.GetEntityByTag("player-menu");
	
	var up:Bool = true;
	
	var pan:Bool = false;
	
	var fix:Bool = false;
	
	public function init()
	{
		owner.y =  Reg.height - owner.height;	
		owner.offset.x = -11;
	}
	
	public function update()
	{	
		if (!pan)
		{
			if (FlxG.overlap(owner, player))
			{
				pan = true;
				player.setVar("hasControl", false);
			}
		}
		else
		{
			panCamera();
		}
		
		if (fix)
		{
			if (FlxG.keys.anyJustPressed([FlxKeyWrap.A,FlxKeyWrap.S,FlxKeyWrap.D,FlxKeyWrap.W, FlxKeyWrap.LEFT,FlxKeyWrap.RIGHT,FlxKeyWrap.UP,FlxKeyWrap.DOWN,FlxKeyWrap.SPACE]))
			{
				FlxG.keys.reset();
				player.setVar("hasControl", true);
				fix = false;
			}
		}
	}


	public function reload()
	{
	//anything typed here will be run whenever the script is altered
	}

	/*Any function in the following block is treated as a standard haxe function,
	and supports live reloading while the game runs.
	You MUST place all functions except the above script functions inside of a single
	block as shown below.*/
	
	//@

	function panCamera()
	{
		if (up)
		{
			if (FlxG.camera.scroll.y > -Reg.height - Reg.start)
			{
				FlxG.camera.scroll.y -= speed * FlxG.elapsed;
			}
			else
			{
				up = false;
				player.setVar("hasControl", false);
				player.x = FlxG.width / 2;
				Stats.trackEvent("load", "twitter", "opened twitter");
				FlxG.openURL("https://twitter.com/nico_m__");
			}
		}
		else
		{
			if (FlxG.camera.scroll.y < 0)
			{
				FlxG.camera.scroll.y += speed * FlxG.elapsed;
				if (FlxG.camera.scroll.y >= 0)
				{
					FlxG.camera.scroll.y = 0;
					pan = false;
					up = true;
					fix = true;
				}
			}
		}
	}

	//@



}