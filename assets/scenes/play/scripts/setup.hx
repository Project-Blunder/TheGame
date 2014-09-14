package ;

import flixel.FlxG;
import ice.entity.EntityManager;
import flixel.system.scaleModes.RatioScaleMode;
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
		if(Reg.flash)
		FlxG.sound.playMusic("assets/music/graveytheme.wav", 1, true); //wav doesn't work properly on native (yet)
		
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
		
		//FlxG.camera.follow(EntityManager.instance.GetEntityByTag("player"), null, FlxPoint.get(0,Reg.start + 100));//Just thinking about taking the player to an adventure	
	}	
}