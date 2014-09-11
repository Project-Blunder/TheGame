package ;

import flixel.FlxG;
import ice.group.EntityGroup;
import ice.entity.EntityManager;
import ice.entity.Entity;

class EnemyManager
{
	var enemies:EntityGroup = new EntityGroup();
	
	public function init() 
	{
		EntityManager.instance.AddGroup(enemies, "enemies");
		addEnemy();
	}
	
	//@
	function addEnemy()
	{
		enemies.add(EntityManager.instance.instantiate("enemy"));
	}
	//@
}