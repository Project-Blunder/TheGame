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

class waves
{
	//#
	var owner:Entity;
	//#
	
	var once:Bool = false;
	
	public function init() 
	{	
		
	}
	public function update()
	{
		if (!once)
		{
			if (FlxG.camera.scroll.y == 0)
			{
				owner.animation.play(Std.string(Reg.waves));
				once = true;
			}
		}
	}
}