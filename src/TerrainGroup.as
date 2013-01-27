package
{
  import org.flixel.*;

  public class TerrainGroup extends FlxGroup
  {
    private var terrain:FlxSprite;

    public function TerrainGroup():void {
      terrain = new FlxSprite();
      terrain.loadGraphic(Assets.Terrain);
      terrain.y = 16;
      terrain.solid = false;
      add(terrain);

      var hitBox:FlxObject;// = new FlxObject(48, 24, 80, 8);
      //hitBox.immovable = true;
      //add(hitBox);

      hitBox = new FlxObject(16, 40, 32, 8);
      hitBox.immovable = true;
      add(hitBox);

      hitBox = new FlxObject(128, 40, 32, 8);
      hitBox.immovable = true;
      add(hitBox);

      hitBox = new FlxObject(64, 72, 48, 8);
      hitBox.immovable = true;
      add(hitBox);

      hitBox = new FlxObject(0, 104, 48, 8);
      hitBox.immovable = true;
      add(hitBox);

      hitBox = new FlxObject(128, 104, 48, 8);
      hitBox.immovable = true;
      add(hitBox);
    }
  }
}
