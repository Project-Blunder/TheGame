package ;

import flixel.FlxG;
import ice.entity.Entity;
import ice.entity.EntityManager;
import Reg;
import googleAnalytics.Stats;

class Start
{
	//#
	var owner:Entity;
	//#
	
	var speed:Float = 170;
	
	var player:Entity = EntityManager.instance.GetEntityByTag("player-menu");
	
	var pan:Bool = false;
	
	public function init()
	{
		owner.y =  Reg.height - owner.height;
		owner.offset.x = 11;
	}
	
	public function update()
	{	
		if (!pan)
		{
			if (FlxG.overlap(owner, player))
			{
				pan = true;
			}
		}
		else
		{
			panCamera();
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
		if (FlxG.camera.scroll.y > -Reg.height - Reg.start)
		{
			FlxG.camera.scroll.y -= speed * FlxG.elapsed;
		}
		else
		{
			Stats.trackEvent("game", "start", "started game");
			EntityManager.switchScene(["assets/scenes/play/setup.xml"]);
		}
	}

	//@



}