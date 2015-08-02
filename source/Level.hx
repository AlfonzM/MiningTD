package;

import flixel.tile.FlxTilemap;
import openfl.Assets;
import flixel.FlxObject;
import flixel.tile.FlxTile;

class Level {
	public var level:FlxTilemap;

	public function new(){
		level = new FlxTilemap();
		level.loadMap(Assets.getText("assets/map.csv"), "assets/images/tiles.png", Reg.T_WIDTH, Reg.T_HEIGHT);

		// level.setTileProperties(1,FlxObject.ANY, test, null, null);
	}
}