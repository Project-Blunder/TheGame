package ;

import flixel.addons.api.FlxKongregate;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.system.FlxSound;
import googleAnalytics.Stats;
import ice.group.EntityGroup;
import ice.entity.EntityManager;
import ice.entity.Entity;
import flixel.math.FlxRandom;
import Math;
import Reg;
import GA;

class EnemyManager
{
	var enemies:EntityGroup = new EntityGroup();
	var player = EntityManager.instance.GetEntityByTag("player");
	
	var leftTimer:Float = 0;
	var rightTimer:Float = 0;
	
	var wave:Int = 0;
	var enemyOffScreenSpeed:Float = 50;
	var spawned:Int = 0;
	var spawnCount:Int = 3;
	var spawnDefault:Float = 2;
	var spawnRange:Float = 1;
	
	var spawnTimeDefault:Float = 6;
	var spawnTimeRange:Float = 0.2;
	
	var speedIncrease:Float = 2;
	
	var burstChanceIncrease:Float = 5;
	var burstTimeIncrease:Float = 0.5;
	
	var dogChanceIncrease:Float = 3;
	
	var rand = new FlxRandom();
	
	var end:Bool = false;
	
	var pan:Bool = false;
	var speed:Float = 170;
	
	var sprintRound:Int = 3;
	var startSprint:Float = 15;
	var dogRound:Int = 5;
	var startDog:Float = 20;
	
	var leftGrowlSound:FlxSound;
	var rightGrowlSound:FlxSound;
	
	
	public function init() 
	{
		EntityManager.instance.AddGroup(enemies, "enemies", 0);
		
		Reg.roundTime = 0;
		Reg.waves = 0;		
		Reg.zombiesKilled:Int = 0;
		Reg.roundTime:Float = 0;
		Reg.waves:Int = 0;
		Reg.zombieBaseSpeed:Float = 25;
		Reg.burstChance:Float = 0;
		Reg.burstTime:Float = 0.5;
		Reg.dogChance = 0;
		
		
		leftGrowlSound = FlxG.sound.load("assets/sounds/growlexp3.mp3", 0.4, false, false, false);
		leftGrowlSound.pan = -1;
		rightGrowlSound = FlxG.sound.load("assets/sounds/growlexp3.mp3", 0.4, false, false, false);
		rightGrowlSound.pan = 1;
		
		setUpWave();
	}
	
	public function update()
	{
		leftGrowlSound.volume = 0.4 * Reg.sfxVol;
		rightGrowlSound.volume = 0.4 * Reg.sfxVol;
		
		if (pan)
		{
			panCamera();
		}
		
		Reg.roundTime += FlxG.elapsed;
		
		if (FlxG.camera.scroll.y != 0)
		{
			return;
		}
		
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
				
				GA.submit(
					"game", 
					"over", 
					"waves: " + wave
				);
				GA.submit(
					"game", 
					"over", 
					"kills: " + Reg.zombiesKilled
				);
				GA.submit(
					"game", 
					"over", 
					"round-time: " + Math.round(Reg.roundTime)
				);
				
				GA.submit(
					"game", 
					"overview", 
					"waves: " + wave + 
					", kills: " + Reg.zombiesKilled + 
					", round-time: " + (Math.round(Reg.roundTime) / 60)
				);
				
				GA.submit("kongregate", "submitted", "score");
				
				if (Reg.kongConnected)
				{
					FlxKongregate.submitStats("Highest Wave", wave);
					FlxKongregate.submitStats("Most Zombies Killed", Reg.zombiesKilled);
					FlxKongregate.submitStats("Total Zombies Killed", Reg.zombiesKilled);
				}
			
				Reg.waves = wave;
				
				pan = true;
				
				FlxG.camera.follow(null, null, null);
				FlxG.camera.minScrollY = null;
			}
		}
	}
	
	//@
	function panCamera()
	{	
		if (FlxG.camera.scroll.y > -Reg.height - Reg.start)
		{
			FlxG.camera.scroll.y -= speed * FlxG.elapsed;
		}
		else
		{
			FlxG.camera.scroll.x = 0;
			EntityManager.switchScene(["assets/scenes/dead/setup.xml"]);
		}
	}
	
	function endWave()
	{
		var over:Bool = true;
		for (e in enemies.members)
		{
			if (e != null)
			{
				e.y += enemyOffScreenSpeed * FlxG.elapsed;
				if (e.y <= Reg.height)
				{
					over = false;
				}
			}
		}
		
		if (over)
		{
			setUpWave();
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
		
		player.health++;

		leftTimer = rand.float(0, 1); 
		rightTimer = rand.float(0,1);
			
		if (wave == 3)
		{
			spawnTimeDefault = 4;
		}
		
		if (wave != 1)
		{
			Reg.zombieBaseSpeed += speedIncrease;
			
			spawnCount += Math.floor(rand.float(spawnDefault - spawnRange, spawnDefault + spawnRange + 1));
			spawnTimeDefault -= rand.float(spawnTimeRange / 2, spawnTimeRange);
		}
		
		if (wave >= sprintRound)
		{
			if (wave == sprintRound)
			{
				Reg.burstChance = startSprint;
			}
			if (Reg.burstChance < 50)
			{
				Reg.burstChance += burstChanceIncrease;
			}
			Reg.burstTime += burstTimeIncrease;
		}
		
		if (wave >= dogRound)
		{
			if (wave == dogRound)
			{
				Reg.dogChance = startDog;
			}
			if (Reg.dogChance < 40)
			{
				Reg.dogChance += dogChanceIncrease;
			}
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
		var enemy = null;
		if (rand.bool(Reg.dogChance))
		{
			enemy = EntityManager.instance.instantiate("canine");
		}
		else
		{
			enemy = EntityManager.instance.instantiate("enemy");
		}
		enemies.add(enemy);
		
		if (direction == 1)
		{
			rightGrowlSound.play();
			enemy.x = FlxG.camera.scroll.x + FlxG.width + enemy.width;
		}
		else
		{
			leftGrowlSound.play();
			enemy.x = FlxG.camera.scroll.x -enemy.width;
		}
		
		spawned++;
	}
	//@
}