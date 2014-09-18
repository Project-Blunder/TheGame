package ;

import flixel.FlxG;
import ice.group.EntityGroup;
import ice.entity.EntityManager;
import ice.entity.Entity;
import flixel.math.FlxRandom;

class EnemyManager
{
	var enemies:EntityGroup = new EntityGroup();
	
	var timer:Float = 0;
	var spawnDefault:Float = 9;
	var spawnRange:Float = 3;
	
	var rand = new FlxRandom();
	
	public function init() 
	{
		EntityManager.instance.AddGroup(enemies, "enemies", 0);
		addEnemy();
		setTimer();
	}
	
	public function update()
	{
		timer -= FlxG.elapsed;
		
		if (timer < 0)
		{
			addEnemy();
			
			setTimer();
		}
	}
	
	//@
	function setTimer()
	{
		timer = rand.float(spawnDefault - spawnRange, spawnDefault + spawnRange);
	}
	
	function addEnemy()
	{
		var enemy = EntityManager.instance.instantiate("enemy");
		enemies.add(enemy);
		
		if (rand.sign() > 0)
		{
			enemy.x = FlxG.camera.scroll.x + FlxG.width + enemy.width;
		}
		else
		{
			enemy.x = FlxG.camera.scroll.x -enemy.width;
		}
	}
	//@
}