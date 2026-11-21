#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\util;

setup()
{
	level.lockPrint = false;

	thread watchPrematch();
}

watchPrematch() {
	level endon("game_ended");
	for(;;) {
		level waittill("prematch_over");
		printAliveCount();
	}
}

onPlayerKilled(attacker, sMeansOfDeath) {
	wait ( 0.05 );
	printAliveCount();
}

printAliveCount()
{
	return;
}