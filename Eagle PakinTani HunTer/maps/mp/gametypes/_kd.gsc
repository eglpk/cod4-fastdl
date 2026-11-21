/*
	KD panel (SLeS/tool style), next to the minimap.
	Columns: red || x=115, gold names left-aligned x=128, ":" vertical column x=200, white score column x=207.
	Order: Health, KD Ratio, Headshots, Elimination, Revive, Accuracy, Aura.
*/

main()
{
	self endon( "disconnect" );

	self.pers["shots"] = 1;
	self.pers["hits"] = 1;

	initKdHud();
	self thread kdHudUpdate();
	self thread kdShootCounter();

	for ( ;; )
	{
		self waittill( "spawned_player" );
		initKdHud();
	}
}

kdShootCounter()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "weapon_fired" );
		if ( isDefined( self.pers["shots"] ) )
			self.pers["shots"] = self.pers["shots"] + 1;
	}
}

createKdElem( text, x, y, alignX )
{
	elem = newClientHudElem( self );
	elem.x = x;
	elem.y = y;
	elem.horzAlign = "left";
	elem.vertAlign = "bottom";
	elem.alignX = alignX;
	elem.alignY = "middle";
	elem.fontScale = 1.4;
	elem.hidewheninmenu = true;
	elem.alpha = 0.9;
	elem.color = (1, 1, 1);
	elem.glowalpha = 0.5;
	elem.foreground = 1;
	elem.label = text;
	return elem;
}

initKdHud()
{
	if ( !isDefined( self.pers["shots"] ) || self.pers["shots"] < 1 )
		self.pers["shots"] = 1;
	if ( !isDefined( self.pers["hits"] ) || self.pers["hits"] < 1 )
		self.pers["hits"] = 1;

	if ( isDefined( self.kdHudAura ) )
		return;

	createKdElem( &"^1||", 115, -459, "left" );
	createKdElem( &"^3Health", 128, -459, "left" );
	createKdElem( &"^3:", 204, -459, "left" );
	self.kdHudHealth = createKdElem( &"^7&&1", 211, -459, "left" );

	createKdElem( &"^1||", 115, -445, "left" );
	createKdElem( &"^3KD Ratio", 128, -445, "left" );
	createKdElem( &"^3:", 204, -445, "left" );
	self.kdHudKD = createKdElem( &"^7&&1", 211, -445, "left" );

	createKdElem( &"^1||", 115, -431, "left" );
	createKdElem( &"^3Headshots", 128, -431, "left" );
	createKdElem( &"^3:", 204, -431, "left" );
	self.kdHudHeadshots = createKdElem( &"^7&&1", 211, -431, "left" );

	createKdElem( &"^1||", 115, -417, "left" );
	createKdElem( &"^3Elimination", 128, -417, "left" );
	createKdElem( &"^3:", 204, -417, "left" );
	self.kdHudElims = createKdElem( &"^7&&1", 211, -417, "left" );

	createKdElem( &"^1||", 115, -403, "left" );
	createKdElem( &"^3Revive", 128, -403, "left" );
	createKdElem( &"^3:", 204, -403, "left" );
	self.kdHudRevives = createKdElem( &"^7&&1", 211, -403, "left" );

	createKdElem( &"^1||", 115, -389, "left" );
	createKdElem( &"^3Accuracy", 128, -389, "left" );
	createKdElem( &"^3:", 204, -389, "left" );
	self.kdHudAccuracy = createKdElem( &"^7&&1", 211, -389, "left" );

	createKdElem( &"^1||", 115, -375, "left" );
	createKdElem( &"^3Aura", 128, -375, "left" );
	createKdElem( &"^3:", 204, -375, "left" );
	self.kdHudAura = createKdElem( &"^7&&1", 211, -375, "left" );
}

kdHudUpdate()
{
	self endon( "disconnect" );

	for ( ;; )
	{
		wait 0.5;

		if ( !isDefined( self.kdHudAura ) )
			continue;

		health = 0;
		revives = 0;
		kills = 0;
		deaths = 0;
		headshots = 0;
		shots = 0;
		hits = 0;

		if ( isDefined( self.health ) ) health = self.health;
		if ( health < 0 ) health = 0;
		if ( isDefined( self.reviveCount ) ) revives = self.reviveCount;
		if ( isDefined( self.pers["kills"] ) ) kills = self.pers["kills"];
		if ( isDefined( self.pers["deaths"] ) ) deaths = self.pers["deaths"];
		if ( isDefined( self.pers["headshots"] ) ) headshots = self.pers["headshots"];
		if ( isDefined( self.pers["shots"] ) ) shots = self.pers["shots"];
		if ( isDefined( self.pers["hits"] ) ) hits = self.pers["hits"];

		if ( deaths < 1 )
			ratio = kills;
		else
			ratio = int( kills / deaths * 100 ) / 100;

		if ( shots > 0 )
			accInt = int( hits * 100 / shots );
		else
			accInt = 0;

		self.kdHudAccuracy setText( "^7" + accInt );

		self.kdHudHealth setValue( int( health ) );
		self.kdHudKD setValue( ratio );
		self.kdHudHeadshots setValue( headshots );
		self.kdHudElims setValue( kills );
		self.kdHudRevives setValue( revives );
		self.kdHudAura setValue( 0 );
	}
}
