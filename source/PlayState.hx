package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.util.FlxMath;
import flixel.group.FlxTypedGroup;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public static var _cameraTarget:FlxSprite;
	var _player:Player;
	var _bullets:FlxTypedGroup<Bullet>;
	var _level:Level;

	override public function create():Void
	{
		super.create();

		// Setup player
        _bullets = new FlxTypedGroup<Bullet>();
        _bullets.maxSize = 50;

		_player = new Player(0,0,_bullets);
		add(_player);


        add(_bullets);

		// Setup _level
		_level = new Level();
		add(_level.level);

		// Setup World
		FlxG.worldBounds.width = (_level.level.widthInTiles + 1) * Reg.T_WIDTH;
		FlxG.worldBounds.height = (_level.level.heightInTiles + 1) * Reg.T_HEIGHT;

		// Setup camera
		_cameraTarget = new FlxSprite(0,0);
		FlxG.camera.follow(_cameraTarget, FlxCamera.STYLE_LOCKON, 7);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		forDebug();
		_cameraTarget.setPosition(_player.x + (FlxG.mouse.x - _player.x)/6, _player.y + (FlxG.mouse.y - _player.y)/6);
		
		super.update();

		FlxG.collide(_bullets, _level.level, onCollision);
		FlxG.collide(_player, _level.level);
	}	

	private function forDebug(){
		if(FlxG.keys.justPressed.R){
			trace("Restart level.");
			FlxG.switchState(new PlayState());
		}
	}

	/*
	 *	Callback function called by overlap() in update
	 */
	private function onCollision(Object1:FlxObject, Object2:FlxObject):Void{
		// Bullet collide with level
		if(Std.is(Object1, Bullet)){
			Object1.kill();
		}
	}
}