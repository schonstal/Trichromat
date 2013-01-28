package
{
  import org.flixel.*;

  public class GemGroup extends FlxGroup
  {
    public var badGem:GemSprite;
    public var goodGem:GemSprite;

    public function GemGroup():void {
      goodGem = new GemSprite(true);
      add(goodGem);

      badGem = new GemSprite(false);
      add(badGem);
    }

    public function spawn(spawnZones:FlxGroup, player:Player) {
      var acceptableZones:Array = [];
      FlxG.log(spawnZones.members);
      for(var i:uint = 0; i < spawnZones.members.length; i++) {
        if(spawnZones.members[i] is FlxObject &&
            spawnZones.members[i].x > 0 &&
            spawnZones.members[i].y > 0 &&
            spawnZones.members[i].y < (FlxG.height + FlxG.camera.scroll.y - 28) &&
            !FlxG.overlap(spawnZones.members[i], player)) {
          acceptableZones.push(spawnZones.members[i]);
        }
      }

      var zoneIndex:uint = Math.floor(acceptableZones.length * Math.random());
      var zone:FlxObject = acceptableZones[zoneIndex];
      goodGem.spawn(zone.x + Math.floor((Math.random() * (zone.width - 8))/8)*8, zone.y - 4);
      FlxG.log("" + zoneIndex + ": " + zone.x);
 
      var previousZone:uint = zoneIndex;
      do {
        zoneIndex = Math.floor(acceptableZones.length * Math.random());
      } while (zoneIndex == previousZone && acceptableZones.length >= 2);

      zone = acceptableZones[zoneIndex];
      badGem.spawn(zone.x + (Math.random() * (zone.width - 8)), zone.y - 4);
      FlxG.log("" + zoneIndex + ": " + zone.x);

      if(FlxG.overlap(badGem, goodGem)) {
        goodGem.x += 8;
        badGem.x -= 8;
      }
    }
  }
}
