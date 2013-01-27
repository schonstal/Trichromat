package
{
  import org.flixel.*;

  public class Assets
  {
    [Embed(source = "../data/terrain.png")] public static var Terrain:Class;
    [Embed(source = "../data/player.png")] public static var Player:Class;
    [Embed(source = "../data/lava.png")] public static var Lava:Class;

    [Embed(source = "../data/test.mp3")] public static var Music:Class;

    [Embed(source = "../data/jump.mp3")] public static var JumpSound:Class;
  }
}
