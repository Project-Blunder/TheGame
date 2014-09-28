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
	
	var player = EntityManager.instance.GetEntityByTag("player");
	
	var startHealth:Float = 10;
	
	public function init() 
	{	
		owner.scrollFactor.x = 0;
		owner.scrollFactor.y = 0;
		owner.makeGraphic(214, 1, FlxColorWrap.BLACK);
		
	}
	
	public function update()
	{
		owner.x = (214*(Math.floor(player.health / startHealth * 10)) / 10)-214;
	}
}