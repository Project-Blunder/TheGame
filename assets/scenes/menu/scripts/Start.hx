package ;

import flixel.FlxG;
import ice.entity.Entity;
import ice.entity.EntityManager;
import Reg;

class Start
{
	//#
	var owner:Entity;
	//#
	
	var speed:Float = 130;
	
	var player:Entity = EntityManager.instance.GetEntityByTag("player-menu");
	
	public function init()
	{
		owner.y =  Reg.height - owner.height;
		owner.offset.x = 11;
	}
	
	public function update()
	{	
		if (FlxG.overlap(owner,player))   
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
			EntityManager.switchScene(["assets/scenes/play/setup.xml"]);
		}
	}

	//@



}