package ;

import flixel.FlxG;
import ice.group.EntityGroup;
import ice.entity.EntityManager;
import ice.entity.Entity;
import flixel.math.FlxRandom;
import Math;

class EnemyManager
{
	var enemies:EntityGroup = new EntityGroup();
	
	var timer:Float = 0;
	var wave:Int = 0;
	var waveDelay:Float = 5;
	var enemyOffScreenSpeed:Float = 50;
	var spawned:Int = 0;
	var spawnCount:Int = 0;
	var spawnDefault:Float = 6;
	var spawnRange:Float = 1;
	
	var spawnTimeDefault:Float = 6;
	var spawnTimeRange:Float = 0.5;
	
	var rand = new FlxRandom();
	
	public function init() 
	{
		EntityManager.instance.AddGroup(enemies, "enemies", 0);
		setUpWave();
		
		setTimer();
	}
	
	public function update()
	{
		var over:Bool = true;
		for (e in enemies.members)
		{
			if (e != null && e.alive)
			{
				over = false;
				break;
			}
		}
		if (over && spawned >= spawnCount)
		{
			endWave();
			return;
		}
		
		timer -= FlxG.elapsed;
		
		if (spawned < spawnCount && timer < 0)
		{
			addEnemy();
			
			setTimer();
		}
	}
	
	//@
	function endWave()
	{
		timer += FlxG.elapsed;
		
		if (timer > waveDelay)
		{
			setUpWave();
		}
		
		for (e in enemies.members)
		{
			if (e != null)
			{
				e.y += enemyOffScreenSpeed * FlxG.elapsed;
			}
		}
	}
	
	function setUpWave()
	{
		for (e in enemies.members)
		{
			e.destroy();
		}
		enemies.clear();
		spawned = 0;
		addEnemy();
		setTimer();
		trace(++wave);
		spawnCount += Math.floor(rand.float(spawnDefault - spawnRange, spawnDefault + spawnRange));
		spawnTimeDefault -= rand.float(0, spawnTimeRange);
	}
	
	function setTimer()
	{
		timer = rand.float(spawnTimeDefault - spawnTimeRange, spawnTimeDefault + spawnTimeRange);
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
		
		spawned++;
	}
	//@
}