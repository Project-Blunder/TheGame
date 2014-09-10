package ;

import flixel.FlxG;
import ice.entity.Entity;
import Reg;
import PlayState;

class Start
{
	//#
	var owner:Entity;
	//#
	
	public function init()
	{
		owner.x = FlxG.width / 2 - owner.width / 2;
		owner.y =  FlxG.height / 2 - owner.height / 2;	
	}
	
	public function update()
	{	
		if ((FlxG.mouse.overlaps(owner)) && (FlxG.mouse.justPressed))   
		{
			FlxG.switchState(new PlayState());  
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

	//Write your functions here.

	//@



}