package
{
  import org.flixel.*;

  public class GemSprite extends FlxSprite
  {
    public static const SIN_RATE:Number = 3;
    public static const OSC_AMT:Number = 2;
    public var idle:Boolean = false;

    private var sin:Number = 0;
    private var collectFinishCallback:Function;

    public function GemSprite(good:Boolean):void {
      loadGraphic(good ? Assets.GemGood : Assets.GemBad, true, false, 8, 8);
      addAnimation("appear", [2,1,2,1,2,1,3,4,5,6], 15, false);
      addAnimation("idle", [0,0,0,0,0,7,8,9,10], 10);
      addAnimation("disappear", [1,2,1,2,1,2,2], 15, false);
      addAnimationCallback(onAnimate);
      visible = false;
    }

    public function spawn(X:Number, Y:Number):void {
      x = X;
      y = Y;

      idle = false;
      offset.y = 0;
      visible = true;
      play("appear");
    }

    public function collect(callback:Function=null):void {
      if(idle) {
        collectFinishCallback = callback;
        idle = false;
        play("disappear");
      }
    }

    public override function update():void {
      if(idle) {
        sin += FlxG.elapsed * SIN_RATE;
        offset.y = Math.sin(sin) * OSC_AMT;
      }
    }

    protected function onAnimate(name:String, frameNumber:uint, frameIndex:uint):void {
      if(frameIndex == 6) {
        play("idle");
        idle = true;
      }
      if(frameNumber == 6 && name == "disappear") {
        if(collectFinishCallback != null) collectFinishCallback();
      }
    }
  }
}
