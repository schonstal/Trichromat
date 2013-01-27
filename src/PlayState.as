package
{
  import org.flixel.*;
  import flash.display.BitmapData;
  import flash.display.BitmapDataChannel;
  import flash.geom.Rectangle;
  import flash.geom.Point;
  import components.MP3Pitch;

  public class PlayState extends FlxState
  {
    public static const SIN_RATE:Number = 10;
    public static const HUE_RATE:Number = 100;

    private var palette:FlxSprite;
    private var sin:Number = 0;

    private var pitchRate:Number = 0;
    private var pitcher:MP3Pitch;

    private var player:Player;
    private var terrain:TerrainGroup;
    private var lava:LavaGroup;
    private var background:FlxSprite;

    override public function create():void {
      FlxG.camera.x = -32;
      FlxG.camera.y = -32;

      background = new FlxSprite();
      background.loadGraphic(Assets.Background);
      add(background);

      player = new Player(0,0);
      add(player);

      terrain = new TerrainGroup();
      add(terrain);
      
      lava = new LavaGroup();
      add(lava);

      pitcher = new MP3Pitch(Assets.Music);

    }

    override public function update():void {
      pitcher.rate = 2;
      G.hueShift += 0.2;
//      G.game.rotationZ = Math.sin(sin/8)/2;

      super.update();

      player.resetFlags();

      FlxG.collide(player, terrain, function(player:Player, tile:FlxObject):void {
        if(tile.touching & FlxObject.UP) {
          player.setCollidesWith(Player.WALL_UP);
        }
      });
    }

    override public function draw():void {
      super.draw();

      aberrateCamera(FlxG.camera);
    }

    protected function aberrateCamera(camera:FlxCamera):void {
      sin += FlxG.elapsed * SIN_RATE;
      var buffer:BitmapData = camera.buffer.clone();
      camera.fill(0xff000000);

      var sourceRect:Rectangle = new Rectangle(0,0,camera.width, camera.height);

      var colorBuffer:BitmapData;
      var channels:Array = [BitmapDataChannel.RED, BitmapDataChannel.BLUE, BitmapDataChannel.GREEN];
      var offsets:Object = {};
      offsets[BitmapDataChannel.RED] = new Point(0,0);
      offsets[BitmapDataChannel.BLUE] = new Point(1,0);
      offsets[BitmapDataChannel.GREEN] = new Point(0,1);
     
      for each(var channel:uint in channels) { 
        colorBuffer = new BitmapData(camera.width, camera.height, true, 0x00000000);
        var point:Point = new Point(Math.sin(0) * 1 + offsets[channel].x, Math.cos(0) * 1 + offsets[channel].y);
         
        colorBuffer.copyChannel(buffer,
          sourceRect,
          point,
          BitmapDataChannel.ALPHA,
          BitmapDataChannel.ALPHA);

        colorBuffer.copyChannel(buffer, sourceRect, point, channel, channel); 
        camera.buffer.draw(colorBuffer, null, null, "add");
      }
    }
  }
}
