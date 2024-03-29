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
    public static const MUSIC_DEATH_RATE:Number = 0.75;
    public static const GEM_SCROLL:Number = 3;
    public static const GEM_PITCH_RATE:Number = 0.5;
    public static const GLITCH_RATE:Number = 1;
    public static const GLITCH_PITCH:Number = 0.4;

    private var sin:Number = 0;

    private var currentPitch:Number = 0;
    private var glitchTimer = 0;

    private var glitching:Boolean = false;

    private var player:Player;
    private var terrain:TerrainGroup;
    private var lava:LavaGroup;
    private var background:FlxSprite;
    private var gems:GemGroup; 

    private var scoreText:FlxText;
    private var scoreShadowText:FlxText;

    public var gameOverGroup:FlxGroup;

    private var starting:Boolean = true;

    private var score:uint = 0;
    private var scoreSubmitted:Boolean = false;

    public function get hueRate():Number {
      return score * 5;
    }

    public function get aberrationLevel():Number {
      return score/40;
    }

    public function get aberrationAmount():Number {
      return glitchTimer;
    }

    public function get tiltRate():Number {
      return score/5;
    }

    public function get pitch():Number {
      return Math.max(0.5, 1 - score/100);
    }

    public function get sinkRate():Number {
      return (score == 0 ? 0 : Math.min(2, score/50 + 1));
    }

    override public function create():void {
      FlxG.camera.x = -32;
      FlxG.camera.y = -32;

      background = new FlxSprite();
      background.loadGraphic(Assets.Background);
      background.scrollFactor.y = 0;
      add(background);

      var geyser:FlxSprite = new FlxSprite(FlxG.width/2-10, 0);
      geyser.loadGraphic(Assets.LavaGeyser, true, false, 20, 21);
      geyser.addAnimation("squirt", [0,1,2,3,4,5], 15);
      geyser.play("squirt");
      geyser.scrollFactor.y = 0;
      add(geyser);

      var river:FlxSprite = new FlxSprite(66, 21);
      river.loadGraphic(Assets.LavaRivulets, true, false, 33, 28);
      river.addAnimation("move", [0,1,2], 5);
      river.play("move");
      river.scrollFactor.y = 0;
      add(river);

      player = new Player();
      add(player);

      gems = new GemGroup();
      add(gems);
      
      gems.badGem.spawn(28, 27);
      gems.goodGem.spawn(140, 27);

      terrain = new TerrainGroup();
      add(terrain);

      lava = new LavaGroup();
      add(lava);

      gameOverGroup = new FlxGroup();

      var gameOverSprite:FlxSprite = new FlxSprite();
      gameOverSprite.loadGraphic(Assets.GameOver);
      gameOverSprite.scrollFactor.y = 0;

      var gameOverShadingSprite:FlxSprite = new FlxSprite();
      gameOverShadingSprite.loadGraphic(Assets.GameOverShading);
      gameOverShadingSprite.ignoreHue = true;
      gameOverShadingSprite.scrollFactor.y = 0;

      gameOverGroup.add(gameOverShadingSprite);
      gameOverGroup.add(gameOverSprite);
      gameOverGroup.visible = false;
      add(gameOverGroup);

      scoreShadowText = new FlxText(-2, 10, FlxG.width, ""); 
      scoreShadowText.alignment = "center";
      scoreShadowText.setFormat("adore");
      scoreShadowText.color = 0xff000000;
      scoreShadowText.size = 8;
      scoreShadowText.scrollFactor.y = 0;
      add(scoreShadowText);

      scoreText = new FlxText(-2, 9, FlxG.width, "");
      scoreText.alignment = "center";
      scoreText.setFormat("adore");
      scoreText.size = 8;
      scoreText.scrollFactor.y = 0;
      add(scoreText);

      var vignette:FlxSprite = new FlxSprite();
      vignette.loadGraphic(Assets.Vignette);
      vignette.ignoreHue = true;
      vignette.scrollFactor.y = 0;
      add(vignette);

      FlxG.flash(0xff000000);

      G.started = true;
      G.hueShift = 0;
    }

    override public function update():void {
      G.hueShift += FlxG.elapsed * hueRate;
      scoreText.text = scoreShadowText.text = "" + score;

      sin += FlxG.elapsed * tiltRate;
      //G.game.rotationZ = Math.sin(sin/8)/2;

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

        FlxG.overlap(player, gems, function(player:Player, gem:GemSprite):void {
            if(gem == gems.goodGem) {
              if(gem.idle) {
                gem.collect(function():void { gems.spawn(terrain.spawnZones, player); });
                FlxG.camera.scroll.y += GEM_SCROLL;
                score++;
                glitching = true;
              }
            } else {
              player.die();
            }
        });

        if(glitching) {
          glitchTimer += FlxG.elapsed * GLITCH_RATE;
          G.pitcher.rate = pitch + (Math.sin(-glitchTimer * Math.PI) * GLITCH_PITCH);
        }
        if(glitchTimer >= 1) {
          glitchTimer = 0;
          glitching = false;
          G.pitcher.rate = pitch;
        }

        if(player.y + player.height - FlxG.camera.scroll.y >= lava.y + 3) {
          player.die();
        }
      } else {
        if(player.y > FlxG.camera.height - FlxG.camera.scroll.y) {
          scoreText.y = 51;
          scoreText.size = 16;
          scoreShadowText.y = 53;
          scoreShadowText.size = 16;
          gameOverGroup.visible = true;

          if(!scoreSubmitted) {
            G.api.kongregate.stats.submit("Gems", score);
            scoreSubmitted = true;
          }

          if(FlxG.keys.justPressed("W") || FlxG.keys.justPressed("UP")) {
            FlxG.fade(0xff000000,0.5,function():void {
              FlxG.switchState(new PlayState());
            });
          }
        }
        G.pitcher.rate -= FlxG.elapsed * MUSIC_DEATH_RATE;
      }

      if(FlxG.camera.scroll.y > 0) FlxG.camera.scroll.y = 0;
    }

    override public function draw():void {
      super.draw();

      aberrateCamera(FlxG.camera);
    }

    protected function aberrateCamera(camera:FlxCamera):void {
      var buffer:BitmapData = camera.buffer.clone();
      camera.fill(0xff000000);

      var sourceRect:Rectangle = new Rectangle(0,0,camera.width, camera.height);

      var colorBuffer:BitmapData;
      var channels:Array = [BitmapDataChannel.RED, BitmapDataChannel.BLUE, BitmapDataChannel.GREEN];
      var offsets:Object = {};
      offsets[BitmapDataChannel.RED] = new Point(
        1.5 * (aberrationLevel + aberrationAmount),
        0);
      offsets[BitmapDataChannel.BLUE] = new Point(
        -2 * (aberrationLevel + aberrationAmount), 
        2 * (aberrationLevel + aberrationAmount));
      offsets[BitmapDataChannel.GREEN] = new Point(
        -2 * (aberrationLevel + aberrationAmount),
        -2 * (aberrationLevel + aberrationAmount));
     
      for each(var channel:uint in channels) { 
        colorBuffer = new BitmapData(camera.width, camera.height, true, 0x00000000);
        var point:Point = new Point(
          (Math.sin(G.hueShift *  0.0175) * (aberrationAmount + aberrationLevel)) + offsets[channel].x,
          (Math.cos(G.hueShift *  0.0175) * (aberrationAmount + aberrationLevel)) + offsets[channel].y);
         
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
