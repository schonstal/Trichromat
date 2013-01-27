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
    public static const MUSIC_DEATH_RATE:Number = 0.75;

    public static const MAX_SINK_RATE:Number = 5;

    private var palette:FlxSprite;
    private var sin:Number = 0;

    private var pitchRate:Number = 0;

    private var sinkRate:Number = 2;

    private var player:Player;
    private var terrain:TerrainGroup;
    private var lava:LavaGroup;
    private var background:FlxSprite;

    private var starting:Boolean = true;

    override public function create():void {
      FlxG.camera.x = -32;
      FlxG.camera.y = -32;

      background = new FlxSprite();
      background.loadGraphic(Assets.Background);
      background.scrollFactor.y = 0;
      add(background);

      player = new Player(0,0);
      add(player);

      terrain = new TerrainGroup();
      add(terrain);
      
      lava = new LavaGroup();
      add(lava);

      if(G.started) FlxG.flash(0xff000000);

      G.started = true;
    }

    override public function update():void {
      G.hueShift += FlxG.elapsed * HUE_RATE;
      G.game.rotationZ = Math.sin(sin/8)/2;
      if(starting) {
        G.pitcher.rate += FlxG.elapsed * MUSIC_DEATH_RATE * 2;
        if(G.pitcher.rate >= 1) {
          G.pitcher.rate = 1;
          starting = false;
        }
      }

      FlxG.camera.scroll.y -= FlxG.elapsed * sinkRate;

      super.update();

      player.resetFlags();

      if(!player.dead) {
        FlxG.collide(player, terrain, function(player:Player, tile:FlxObject):void {
          if(tile.touching & FlxObject.UP) {
            player.setCollidesWith(Player.WALL_UP);
          }
        });

        if(player.y + player.height - FlxG.camera.scroll.y >= lava.y + 3) {
          player.die();
        }
      } else {
        G.pitcher.rate -= FlxG.elapsed * MUSIC_DEATH_RATE;
        if(player.y > FlxG.camera.height - FlxG.camera.scroll.y) {
          FlxG.fade(0xff000000,0.5,function():void {
            FlxG.switchState(new PlayState());
          });
        }
      }
    }

    override public function draw():void {
      super.draw();

      //aberrateCamera(FlxG.camera);
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
      offsets[BitmapDataChannel.BLUE] = new Point(3,0);
      offsets[BitmapDataChannel.GREEN] = new Point(1,3);
     
      for each(var channel:uint in channels) { 
        colorBuffer = new BitmapData(camera.width, camera.height, true, 0x00000000);
        var point:Point = new Point(Math.sin(G.hueShift *  0.0175)*2 + offsets[channel].x, Math.cos(G.hueShift *  0.0175)*2 + offsets[channel].y);
         
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
