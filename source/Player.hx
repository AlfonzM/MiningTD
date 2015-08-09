package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxAngle;
import flixel.util.FlxPoint;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxSpriteUtil;

class Player extends FlxSprite
{
	// Physics Stuff
    private var maxSpeedX:Int = 120;
	private var maxSpeedY:Int = 300;
    private static var ATTACK_COOLDOWN:Float = 0.1; // delay in between attacks (DPS = 1/ATTACK_COOLDOWN)
    private var jumpForceMultiplier:Float = 0.5;
    private var gravityMultiplier:Float = 1.75;
    private var xDragMultiplier:Float = 2;

    // Shooting Stuff
    private var _bullets:FlxTypedGroup<Bullet>;
    private var _attackDelayCounter:Float;

    private var xAcceleration:Float;
    private var jumpForce:Float;

    // Tower building stuff
    public var _highlightBox:FlxSprite;

    public function new(X:Float, Y:Float, Bullets:FlxTypedGroup<Bullet>)
    {
        super(X,Y);
        makeGraphic(Reg.T_WIDTH-2, Reg.T_HEIGHT-2, FlxColor.CYAN);

        // Hitbox adjustments
        // width = Reg.T_WIDTH - 2;
        // height = Reg.T_WIDTH;
        // offset.set(1,0);

        maxVelocity.set(maxSpeedX,maxSpeedY);
        xAcceleration = maxSpeedX * 10;
        drag.x = xAcceleration * xDragMultiplier;

        // Shooting stuff
        _bullets = Bullets;
        _attackDelayCounter = ATTACK_COOLDOWN;

        acceleration.y = maxVelocity.y * gravityMultiplier;
        jumpForce = maxVelocity.y * jumpForceMultiplier;

        // Tower building stuff
        _highlightBox = new FlxSprite(0,0);
        _highlightBox.makeGraphic(Reg.T_WIDTH, Reg.T_HEIGHT, FlxColor.TRANSPARENT);
        FlxSpriteUtil.drawRect(_highlightBox, 0, 0, Reg.T_WIDTH - 1, Reg.T_HEIGHT - 1, FlxColorUtil.makeFromARGB(0.3, 0, 255, 0), { thickness: 1, color: FlxColorUtil.makeFromARGB(0.0, 0, 255, 0) });
    }

    override public function update():Void
    {
        if(_attackDelayCounter > 0){
            _attackDelayCounter -= FlxG.elapsed;
        }

        _highlightBox.x = Math.floor(FlxG.mouse.x / Reg.T_WIDTH) * Reg.T_WIDTH;
        _highlightBox.y = Math.floor(FlxG.mouse.y / Reg.T_HEIGHT) * Reg.T_HEIGHT;

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
        mining();
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
     *  SHOOTING/MINING STUFF
     *  ------------------
     */
    private function shooting():Void{
        if(FlxG.mouse.justPressed){
            shoot();
        }
    }

    private function mining():Void{
        if(FlxG.mouse.justPressedRight){
            mine();
        }
    }

    private function mine(){
        var p:FlxPoint = new FlxPoint(0,0);
        PlayState._level.level.ray(getMidpoint(_point), new FlxPoint(FlxG.mouse.x,FlxG.mouse.y), p);    
        // trace(p.x  + " " + p.y);
        PlayState._level.level.setTile(Math.floor(p.x / Reg.T_WIDTH), Math.floor(p.y / Reg.T_HEIGHT), 0);
        // trace("ray: " + Math.floor(p.x/16), Math.floor(p.y/16));
        // trace("highlightbox: " + _highlightBox.x/16 + " " + _highlightBox.y/16);
    }

    private function shoot(){
        if(_attackDelayCounter > 0) {
            return;
        } else {
            var angle = FlxAngle.getAngle(FlxPoint.get(x,y), FlxPoint.get(FlxG.mouse.x, FlxG.mouse.y));
            getMidpoint(_point);
            
            _bullets.recycle(Bullet).shoot(_point, angle);
            _attackDelayCounter = ATTACK_COOLDOWN;        

            // FlxG.camera.shake(0.005, 0.05);
        }
    }
}
