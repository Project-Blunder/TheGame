package ;

import flixel.FlxG;
import flixel.math.FlxRandom;
import ice.entity.Entity;
import ice.entity.EntityManager;
import flixel.system.scaleModes.RatioScaleMode;
import flixel.math.FlxPoint;
import Reg;
import Std;
import Math;

class setup
{
	public function init() 
	{	
		FlxG.camera.bgColor = 0xffffffff;
		FlxG.mouse.visible = false;
		
		//Music theme (very partial first draft!) - the idea is that the tempo can get faster and faster
		//with the level of intensity
		if (Reg.flash)
		{
			var music = FlxG.sound.load("assets/music/3bztheme.mp3",1,true,false,true);	
		}	
		else
		{
			var music = FlxG.sound.load("assets/music/3bztheme.ogg", 1, true, false, true);	
		}	
		
		if(!Reg.html)
		FlxG.scaleMode = new RatioScaleMode(true);
		
		FlxG.camera.height = Math.floor(FlxG.height / 2.5);
		FlxG.camera.y = (FlxG.height / 2 - FlxG.camera.height / 2) * FlxG.camera.zoom;
		FlxG.camera.scroll.x = 0;
		FlxG.camera.scroll.y = 0;
		
		Reg.start = FlxG.camera.y / FlxG.camera.zoom;
		//OOOOOHHH AHHHHH
		/*||||MAGIC||||*/Reg.height = FlxG.camera.y / FlxG.camera.zoom + FlxG.camera.height / FlxG.camera.zoom - 5;
		//IT NEEDS CHANGES ALL THE TIMMMMEEEEEE
		
		if(Reg.html)
		Reg.height = FlxG.camera.y / FlxG.camera.zoom + FlxG.camera.height / FlxG.camera.zoom + 5;	
	}
}