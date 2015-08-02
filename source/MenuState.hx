package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	override public function create():Void
	{
		var title:FlxText = new FlxText(0, FlxG.height / 2 - 100, FlxG.width, "PLATFORMER GAME");
		var text:FlxText = new FlxText(0, FlxG.height / 2 + 100, FlxG.width, "Press Enter to Play!");
		
		title.setFormat(null, 32, FlxColor.WHITE, "center");
		text.setFormat(null, 16, FlxColor.WHITE, "center");

		add(title);
		add(text);

		super.create();
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		if(FlxG.keys.pressed.ENTER){
			FlxG.switchState(new PlayState());
		}
		super.update();
	}	
}