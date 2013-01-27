package
{
  import org.flixel.*;

  public class TerrainGroup extends FlxGroup
  {
    private var terrain:FlxSprite;
    
    public var spawnZones:FlxGroup;
    
    public function TerrainGroup():void {
      terrain = new FlxSprite();
      terrain.loadGraphic(Assets.Terrain);
      terrain.y = 16;
      terrain.solid = false;
      add(terrain);

      spawnZones = new FlxGroup();
      var spawnZone:FlxObject;

      var zones:Array = [
        new FlxObject(16, 40, 32, 8),
        new FlxObject(128, 40, 32, 8),
        new FlxObject(64, 72, 48, 8),
        new FlxObject(0, 104, 48, 8),
        new FlxObject(128, 104, 48, 8)
      ];

      for each(var hitBox:FlxObject in zones) {
        hitBox.immovable = true;
        add(hitBox);
        spawnZone = new FlxObject(
          hitBox.x + (hitBox.x == 0 ? 8 : 4),
          hitBox.y - 8,
          hitBox.width - (hitBox.x == 128 && hitBox.width == 104 ? 12 : 8),
          hitBox.height);
        spawnZone.immovable = true;
        spawnZones.add(spawnZone);
      }
    }
  }
}
