package ;

import flixel.math.FlxRandom;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.misc.VarTween;
import ice.entity.Entity;
import ice.wrappers.FlxColorWrap;
import Reg;
import Std;

class Bug
{
	//#
	var owner:Entity;
	//#
	
	var rand = new FlxRandom();
	
	var timer:Float;
	var timerRange:Float = 10;
	
	var meanDist:Float = 7;
	var meanDur:Float = 5;
	
	var tweenVal = newObject();
	var tween:VarTween;
	
	public function init() 
	{
		owner.makeGraphic(1, 1, FlxColorWrap.RED);
		
		owner.x = rand.float(0, FlxG.width);
		owner.y = rand.float(Reg.start, Reg.height);
		timer = rand.float(0, timerRange);
	}
	
	public function update()
	{
		timer -= FlxG.elapsed;
		if (timer < 0 && timer != -1)
		{
			timer = -1;
			move();
		}
		if (timer = -1)
		{
			if (tween != null && tween.finished)
			{
				timer = rand.floatNormal(timerRange, 2);
			}
		}
	}
	
	//@
	function move()
	{
		
	}
	//@
}