package
{
  import org.flixel.*;
  import components.MP3Pitch;

  [SWF(width="640", height="480", backgroundColor="#000000")]
  [Frame(factoryClass="Preloader")]

  public class TerrenceGame extends FlxGame
  {
    public function TerrenceGame() {
      super(176,136,PlayState,4);
      forceDebugger = true;
      FlxG.debug = true;
      G.game = this;
      G.pitcher = new MP3Pitch(Assets.Music);
//      FlxG.visualDebug = true;
//      rotationZ = 1;
    }
  }
}
