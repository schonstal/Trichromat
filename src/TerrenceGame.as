package
{
  import org.flixel.*;
  import components.MP3Pitch;

  [SWF(width="640", height="480", backgroundColor="#000000")]
  [Frame(factoryClass="Preloader")]

  public class TerrenceGame extends FlxGame
  {
    public function TerrenceGame() {
      super(176,136,BadingState,4);
//      forceDebugger = true;
//      FlxG.debug = true;
      G.pitcher = new MP3Pitch(Assets.Music);
      G.pitcher.rate = 0;
      G.game = this;
//      FlxG.visualDebug = true;
//      rotationZ = 1;
    }
  }
}
