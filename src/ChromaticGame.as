package
{
  import org.flixel.*;
  [SWF(width="504", height="312", backgroundColor="#000000")]
  [Frame(factoryClass="Preloader")]

  public class ChromaticGame extends FlxGame
  {
    public function ChromaticGame() {
      super(252,156,PlayState,2);
      forceDebugger = true;
      FlxG.debug = true;
    }
  }
}
