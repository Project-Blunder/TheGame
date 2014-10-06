package ;

import flixel.FlxG;
import flixel.math.FlxRandom;
import flixel.system.FlxSound;
import ice.entity.Entity;
import ice.entity.EntityManager;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.math.FlxPoint;
import Reg;
import Std;
import Math;

class setup
{
	var speed:Float = 170;
	
	var player:Entity;
	
	var set:Bool = false;
	var load:Bool = false;
	
	public function init() 
	{	
		FlxG.camera.bgColor = 0xffffffff;
		FlxG.mouse.visible = false;
		
		//Music stuff
		//amb = FlxG.sound.load("assets/sounds/amb.mp3",0.4,true,false,true);	
		//music = FlxG.sound.load("assets/sounds/mood.mp3", 0.4, true, false, true);	
		
		if(!Reg.html)
		FlxG.scaleMode = new RatioScaleMode(true);
		
		FlxG.camera.height = Math.floor(FlxG.height / 2.5);
		FlxG.camera.y = (FlxG.height / 2 - FlxG.camera.height / 2) * FlxG.camera.zoom;
		
		Reg.start = FlxG.camera.y / FlxG.camera.zoom;
		//OOOOOHHH AHHHHH
		/*||||MAGIC||||*/Reg.height = FlxG.camera.y / FlxG.camera.zoom + FlxG.camera.height / FlxG.camera.zoom - 5;
		//IT NEEDS CHANGES ALL THE TIMMMMEEEEEE
		
		if(Reg.html)
		Reg.height = FlxG.camera.y / FlxG.camera.zoom + FlxG.camera.height / FlxG.camera.zoom + 5;	
		
		FlxG.camera.scroll.y = -Reg.height - Reg.start;
		FlxG.camera.scroll.x = 3;
		
		player = EntityManager.instance.GetEntityByTag("player-menu");
		player.setVar("hasControl", false);
	}
	
	public function update()
	{
		Reg.amb.volume = 0.4 * Reg.sfxVol;
		Reg.music.volume = 0.4 * Reg.musicVol;
		
		if (!load)
		{
			if (!set && player.getVarAsDynamic("hasControl") == true)
			{
				player.setVar("hasControl", false);
				set = true;
			}
			if (FlxG.camera.scroll.y < 0)
			{
				FlxG.camera.scroll.y += speed * FlxG.elapsed;

				if (FlxG.camera.scroll.y >= 0)
				{
					FlxG.camera.scroll.y = 0;
				}
			}
			else
			{
				player.setVar("hasControl", true);
				load = true;
			}
		}
	}
}