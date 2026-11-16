/*
 * Proximity Revive module for Promod4 S&D.
 * Based on the Revive source stored in A1/cod4-modRevive-main,
 * adapted for Promod4's spawnPlayer() flow.
 *
 * Behaviour:
 * - Friendly player enters the fallen player's 50-unit radius.
 * - No USE key and no progress timer.
 * - Revived player uses the normal S&D spawn callback, not corpse origin.
 * - Health is set to 100.
 */

#include common_scripts\utility;
#include maps\mp\_utility;

setup()
{
	precacheItem("revive_mp");
}

onPlayerKilled(attacker, sMeansOfDeath)
{
	self endon("disconnect");
	level endon("game_ended");

	wait 0.05;

	if (!isDefined(self.body))
		return;

	self.reviveInProgress = false;

	// Let the corpse settle before creating the proximity trigger.
	wait 1.5;

	if (!isDefined(self.body) || self.reviveInProgress)
		return;

	trigger = spawn("trigger_radius", self.body.origin, 0, 50, 50);
	self thread monitorBody(trigger);
}

monitorBody(trigger)
{
	self endon("disconnect");
	self endon("revived");
	level endon("game_ended");

	for (;;)
	{
		if (!isDefined(self.body) || !isDefined(trigger) || self.reviveInProgress)
			break;

		trigger waittill("trigger", player);

		if (!isDefined(player) || !isAlive(player))
			continue;

		if (player.pers["team"] != self.pers["team"])
			continue;

		if (self.reviveInProgress)
			break;

		self.reviveInProgress = true;
		player thread reviveDeadTeammate(self, trigger);
		break;
	}

	if (isDefined(trigger))
		trigger delete();
}

reviveDeadTeammate(deadPlayer, trigger)
{
	self endon("disconnect");
	self endon("death");
	level endon("game_ended");

	if (!isDefined(deadPlayer) || !isDefined(deadPlayer.body) || !isAlive(self))
		return;

	if (self.pers["team"] != deadPlayer.pers["team"])
		return;

	// Preserve the current round-life counter; the revive is not a new round life.
	livesBefore = deadPlayer.pers["lives"];

	// Promod4 owns the spawn pipeline and S&D spawnpoint selection.
	deadPlayer maps\mp\gametypes\_globallogic::spawnPlayer();

	deadPlayer.pers["lives"] = livesBefore;
	deadPlayer.maxhealth = 100;
	deadPlayer.health = 100;

	if (isDefined(deadPlayer.body))
		deadPlayer.body delete();

	deadPlayer notify("revived");
	level notify("player_revived");

	if (isDefined(trigger))
		trigger delete();

	if (getDvarInt("scr_revivesound") == 1)
		deadPlayer playSound("revive");
}
