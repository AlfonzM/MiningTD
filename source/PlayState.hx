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
import flixel.effects.particles.FlxEmitter;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	public static var _cameraTarget:FlxSprite;
	public static var _level:Level;

	var _player:Player;
	var _bullets:FlxTypedGroup<Bullet>;
	var _enemies:FlxTypedGroup<Enemy>;

	var _enemyGibs:FlxEmitter;
	
	override public function create():Void
	{
		// FlxG.mouse.visible = false;
		super.create();

		setupPlayer();
		setupWorld();
		setupCamera();
		setupEnemies();
		setupGibs();

		// Add all the stuff to game
		add(_level.level);
		add(_player);
		add(_player._highlightBox);
        add(_bullets);
        add(_enemies);
        add(_enemyGibs);
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

		updateCameraPosition();
		
		super.update();

		FlxG.collide(_player, _level.level);
		FlxG.collide(_enemies, _level.level);
		FlxG.collide(_enemyGibs, _level.level);

		FlxG.collide(_bullets, _level.level, bulletHitsLevel);
		FlxG.overlap(_bullets, _enemies, bulletHitsEnemy);
	}	

	private function forDebug(){
		if(FlxG.keys.justPressed.R){
			trace("Restart level.");
			FlxG.switchState(new PlayState());
		}
	}

	public function setupCamera():Void {
		_cameraTarget = new FlxSprite(_player.x, _player.y);
		var lerp = 7;
		FlxG.camera.follow(_cameraTarget, FlxCamera.STYLE_LOCKON, lerp);
	}
	
	public function setupEnemies():Void {
		_enemies = new FlxTypedGroup<Enemy>();

		spawnEnemy(0,200);
		spawnEnemy(20,200);
		spawnEnemy(50,200);
	}

	public function setupPlayer():Void {
        _bullets = new FlxTypedGroup<Bullet>();
        _bullets.maxSize = 50;
		_player = new Player(578,230,_bullets);
	}
	
	public function setupWorld():Void {
		_level = new Level();

		FlxG.worldBounds.width = (_level.level.widthInTiles + 1) * Reg.T_WIDTH;
		FlxG.worldBounds.height = (_level.level.heightInTiles + 1) * Reg.T_HEIGHT;
	}

	public function setupGibs():Void {
		_enemyGibs = new FlxEmitter();
		_enemyGibs.setXSpeed( -100, 100);
		_enemyGibs.setYSpeed( -150, 0);
		_enemyGibs.setRotation( -360, 0);
		_enemyGibs.gravity = 350;
		_enemyGibs.bounce = 0.3;
		_enemyGibs.makeParticles("assets/images/enemy_gibs.png", 100, 10, true, 0.5);
	}
	
	private function updateCameraPosition():Void{
		var mod = 6; // used for camera lead
		_cameraTarget.setPosition(_player.x + (FlxG.mouse.x - _player.x)/mod, _player.y + (FlxG.mouse.y - _player.y)/mod);
	}

	// Callback method called by collide() in update()
	private function bulletHitsLevel(Bullet:FlxObject, Level:FlxObject):Void{
		// Bullet collide with level
		Bullet.kill();
		FlxG.camera.shake(0.005,0.05);
	}

	// Callback method called by collide() in update()
	public function bulletHitsEnemy(Bullet:FlxObject, Enemy:Enemy):Void {
		Bullet.kill();
		FlxG.camera.shake(0.005,0.08);

		if(Enemy.takeDamage(1)){
			_enemyGibs.at(Bullet);
			_enemyGibs.start(true,1,0,20,3);
			FlxG.camera.shake(0.02,0.2);
		}
	}
	
	public function spawnEnemy(X:Float, Y:Float):Void {
		_enemies.add(new EnemyWalking(X,Y));
	}
	
}