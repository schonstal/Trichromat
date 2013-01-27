package
{
  import org.flixel.*;
  [SWF(width="640", height="480", backgroundColor="#000000")]
  [Frame(factoryClass="Preloader")]

  public class TerrenceGame extends FlxGame
  {
    public function TerrenceGame() {
      super(176,136,PlayState,4);
      forceDebugger = true;
      FlxG.debug = true;
      FlxG.visualDebug = true;
      G.game = this;
//      rotationZ = 1;
    }
  }
}
