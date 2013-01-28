package
{
  import org.flixel.*;

  public class Assets
  {
    [Embed(source = "../data/terrain.png")] public static var Terrain:Class;
    [Embed(source = "../data/player.png")] public static var Player:Class;
    [Embed(source = "../data/lava.png")] public static var Lava:Class;
    [Embed(source = "../data/lavaGlow.png")] public static var LavaGlow:Class;
    [Embed(source = "../data/background.png")] public static var Background:Class;
    [Embed(source = "../data/gemGood.png")] public static var GemGood:Class;
    [Embed(source = "../data/gemBad.png")] public static var GemBad:Class;
    [Embed(source = "../data/lavaGeyser.png")] public static var LavaGeyser:Class;
    [Embed(source = "../data/lavaRivulets.png")] public static var LavaRivulets:Class;

    [Embed(source = "../data/gameOver.png")] public static var GameOver:Class;
    [Embed(source = "../data/gameOverShading.png")] public static var GameOverShading:Class;
    [Embed(source = "../data/vignette.png")] public static var Vignette:Class;
    [Embed(source = "../data/logo.png")] public static var Splash:Class;

    [Embed(source = "../data/test.mp3")] public static var Music:Class;
    [Embed(source = "../data/jump.mp3")] public static var JumpSound:Class;
    [Embed(source = "../data/bading.mp3")] public static var BaDing:Class;


    [Embed(source = '../data/adore64.ttf', fontFamily="adore", embedAsCFF="false")] public var Adore:String;
  }
}
