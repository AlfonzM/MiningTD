package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxSpriteUtil;

class Enemy extends FlxSprite
{
    var hp:Int = 1;
    var maxSpeedX:Int = 120;
    var maxSpeedY:Int = 300;

    var gravityMultiplier:Float = 2.5;
    var xDragMultiplier:Float = 2.5;

    public function new(X:Float, Y:Float)
    {
        super(X,Y);

        maxVelocity.set(maxSpeedX, maxSpeedY);
        drag.x = maxSpeedX * 10 * xDragMultiplier;
    }

    override public function update():Void
    {
        super.update();
    }

    /*
     * Returns true if enemy died after taking damage
     */
    public function takeDamage(Damage:Int):Bool{
    	hp -= Damage;
		FlxSpriteUtil.flicker(this, 0.2, 0.02, true);

    	if(hp <= 0){
    		die();
    		return true;
    	}

    	return false;
    }

    public function die():Void{
    	super.kill();
    }
}