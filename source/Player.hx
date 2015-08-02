package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;

class Player extends FlxSprite
{
	// ------ Change these values ------
    private var maxSpeedX:Int = 150;
	private var maxSpeedY:Int = 400;
    private static var ATTACK_COOLDOWN:Float = 0.1; // delay in between attacks (DPS = 1/ATTACK_COOLDOWN)

    // Multiplied to maxSpeedY, used as upward jump force
    private var jumpForceMultiplier:Float = 0.8;

    // Multiplied to maxSpeedY and set as downwards gravity
    private var gravityMultiplier:Float = 2.5;

    // Multiplied to maxSpeedX and set as drag.x
    private var xDragMultiplier:Float = 2;

    // Shooting Stuff
    private var _bullets:FlxTypedGroup<Bullet>;
    private var _attackDelayCounter:Float;

    // Don't touch these!
    private var xAcceleration:Float;
    private var jumpForce:Float;

    public function new(X:Float, Y:Float, Bullets:FlxTypedGroup<Bullet>)
    {
        super(X,Y);
        makeGraphic(Reg.T_WIDTH, Reg.T_HEIGHT, FlxColor.WHITE);
        maxVelocity.set(maxSpeedX,maxSpeedY);
        xAcceleration = maxSpeedX * 10;
        drag.x = xAcceleration * xDragMultiplier;

        // Shooting stuff
        _bullets = Bullets;
        _attackDelayCounter = ATTACK_COOLDOWN;

        acceleration.y = maxVelocity.y * gravityMultiplier;
        jumpForce = maxVelocity.y * jumpForceMultiplier;
    }

    override public function update():Void
    {
        if(_attackDelayCounter > 0){
            _attackDelayCounter -= FlxG.elapsed;
        }

        playerControls();

        super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    private function playerControls():Void{
		acceleration.x = 0;

        movement();
        shooting();
    }

    private function movement():Void{
        if(FlxG.keys.pressed.A){
            acceleration.x= -xAcceleration;
        } else if(FlxG.keys.pressed.D){
            acceleration.x = xAcceleration;
        }

        if(FlxG.keys.justPressed.W){
            velocity.y = -jumpForce;
        }
    }

    /*
     *  ------------------
     *  SHOOTING STUFF
     *  ------------------
     */
    private function shooting():Void{
        if(FlxG.mouse.pressed){
            shoot();
        }
    }

    private function shoot(){
        if(_attackDelayCounter > 0) {
            return;
        } else {
            var angle = FlxAngle.getAngle(FlxPoint.get(x,y), FlxPoint.get(FlxG.mouse.x, FlxG.mouse.y));
            getMidpoint(_point);
            
            _bullets.recycle(Bullet).shoot(_point, angle);
            _attackDelayCounter = ATTACK_COOLDOWN;        

            FlxG.camera.shake(0.005, 0.02);
        }
    }
}
