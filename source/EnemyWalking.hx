package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class EnemyWalking extends Enemy
{
    private static var MOVESPEED:Float = 5;

    public function new(X:Float, Y:Float)
    {
        super(X,Y);

        hp = 3;
        makeGraphic(Reg.T_WIDTH-2, Reg.T_HEIGHT-2, FlxColor.MAGENTA);

        acceleration.x = MOVESPEED;
        acceleration.y = maxVelocity.y * gravityMultiplier;
    }

    override public function update():Void
    {
        super.update();
    }

    override public function die():Void{
        super.die();

        
    }
}