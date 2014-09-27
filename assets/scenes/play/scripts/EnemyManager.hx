package ;

import flixel.addons.api.FlxKongregate;
import flixel.FlxG;
import ice.group.EntityGroup;
import ice.entity.EntityManager;
import ice.entity.Entity;
import flixel.math.FlxRandom;
import Math;
import Reg;

class EnemyManager
{
	var enemies:EntityGroup = new EntityGroup();
	var player = EntityManager.instance.GetEntityByTag("player");
	
	var leftTimer:Float = 0;
	var rightTimer:Float = 0;
	
	var wave:Int = 0;
	var waveDelay:Float = 2.5;
	var enemyOffScreenSpeed:Float = 50;
	var spawned:Int = 0;
	var spawnCount:Int = 3;
	var spawnDefault:Float = 2;
	var spawnRange:Float = 1;
	
	var spawnTimeDefault:Float = 6;
	var spawnTimeRange:Float = 0.5;
	
	var rand = new FlxRandom();
	
	var end:Bool = false;
	
	public function init() 
	{
		EntityManager.instance.AddGroup(enemies, "enemies", 0);
		setUpWave();
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
		
		leftTimer -= FlxG.elapsed;
		rightTimer -= FlxG.elapsed;
		
		if (spawned < spawnCount)
		{
			if (leftTimer < 0)
			{
				addEnemy(0);
				setLeftTimer();
			}
			if (rightTimer < 0)
			{
				addEnemy(1);
				setRightTimer();
			}
		}
		
		if (!end)
		{
			if (!player.alive)
			{
				end = true;
				//FlxKongregate.submitStats("Highest Wave", wave);
				//FlxKongregate.submitStats("Most Zombies Killed", Reg.zombiesKilled);
				//FlxKongregate.submitStats("Total Zombies Killed", Reg.zombiesKilled);
				trace("score submitted");
			}
		}
	}
	
	//@
	function endWave()
	{
		leftTimer += FlxG.elapsed;
		
		if (leftTimer > waveDelay)
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
		
		++wave;
		trace(wave);

		leftTimer = rand.float(0,3);
		rightTimer = rand.float(0,3);
			
		if (wave != 1)
		{
			spawnCount += Math.floor(rand.float(spawnDefault - spawnRange, spawnDefault + spawnRange + 1));
			spawnTimeDefault -= rand.float(spawnTimeRange / 2, spawnTimeRange);
		}
	}
	
	function setLeftTimer()
	{
		leftTimer = rand.float(spawnTimeDefault - spawnTimeRange, spawnTimeDefault + spawnTimeRange + 1);
	}
	
	function setRightTimer()
	{
		rightTimer = rand.float(spawnTimeDefault - spawnTimeRange, spawnTimeDefault + spawnTimeRange + 1);
	}
	
	function addEnemy(direction:Int)
	{
		var enemy = EntityManager.instance.instantiate("enemy");
		enemies.add(enemy);
		
		if (direction == 1)
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