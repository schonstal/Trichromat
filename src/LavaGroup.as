package
{
  import org.flixel.*;

  public class LavaGroup extends FlxGroup
  {
    public const OSC_RATE:Number = -2;
    public const OSC_AMT:Number = -2;
    public const SIN_OFFSET:Number = 1;

    private var sinAmount:Number = 0;
    public var y:Number = FlxG.height - 16;

    public function LavaGroup():void {
      for(var i:int = 0; i <= FlxG.width/4; i++) {
        var lava:FlxSprite = new FlxSprite((i*4) - 2, y);
        lava.loadGraphic(Assets.Lava, false, false, 0, 0, true);
        lava.scrollFactor.y = 0;
        add(lava);
      }
    }

    public override function update():void {
      sinAmount += FlxG.elapsed * OSC_RATE;
      for(var i:int = 0; i < members.length; i++) {
        if(members[i] is FlxSprite) {
          members[i].y = y + Math.cos(sinAmount + (i * SIN_OFFSET)) * OSC_AMT;
        }
      }
      super.update();
    }

  }
}
