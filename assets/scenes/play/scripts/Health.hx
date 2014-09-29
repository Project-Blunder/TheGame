package ;
import flixel.FlxG;
import flixel.FlxSprite;
import ice.entity.Entity;
import ice.entity.EntityManager;
import ice.wrappers.FlxColorWrap;
import Math;

/**
 * ...
 * @author 
 */
class Health
{
	//#
	var owner:Entity;
	//#
	
	var onScreen:Bool = false;
	var speed:Float = 350;
	
	var player = EntityManager.instance.GetEntityByTag("player");
	
	var startHealth:Float = 10;
	
	var lastHealth:Int = 10;
	
	public function init() 
	{	
		owner.scrollFactor.x = 0;
		owner.scrollFactor.y = 0;
		owner.makeGraphic(214, 1, FlxColorWrap.BLACK);
		
		owner.x = -214;
	}
	
	public function update()
	{
		if (lastHealth < player.health)
		{
			onScreen = false;
		}
		
		var pos = (214 * (Math.floor(player.health / startHealth * 10)) / 10) - 214;
		if (onScreen)
		{
			owner.x = pos;
		}
		else
		{
			owner.x += speed * FlxG.elapsed;
			if (owner.x >= pos)
			{
				owner.x = pos;
				onScreen = true;
				if (owner.x == 0)
				{
					speed /= 3; //for increasing health
				}
			}
		}
		
		lastHealth = player.health;
	}
}