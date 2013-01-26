package
{
  import org.flixel.*;
  import flash.display.BitmapData;
  import flash.display.BitmapDataChannel;
  import flash.geom.Rectangle;
  import flash.geom.Point;

  public class PlayState extends FlxState
  {
    public static const SIN_RATE:Number = 0;
    public static const HUE_RATE:Number = 50;

    private var palette:FlxSprite;
    private var dingus:FlxSprite;
    private var sin:Number = 0;
    private var hue:Number = 0;

    private var colors:Array = [];
    private var shiftedColors:Array = [];
    private var shiftedHSB:Array = [];

    override public function create():void {
      dingus = new FlxSprite();
      dingus.loadGraphic(Assets.CMY);
      dingus.scale = new FlxPoint(4,4);
      dingus.x = dingus.width*1.5;
      dingus.y = dingus.height*1.5;
      add(dingus);

      palette = new FlxSprite();
      palette.loadGraphic(Assets.CMY);
      for(var x:int = 0; x < palette.width; x++) {
        for(var y:int = 0; y < palette.height; y++) {
          var pixel:uint = palette.pixels.getPixel32(x, y);
          if(colors.indexOf(pixel) < 0) {
            colors.push(palette.pixels.getPixel32(x, y));
          }
        }
      }
      FlxG.log(colors.length);

      for each(var color:uint in colors) {
        shiftedHSB.push(FlxU.getHSB(color));
      }

    }

    override public function update():void {
      var hsb:Array;
      for (var i:int = 0; i < shiftedHSB.length; i++) {
        shiftedHSB[i][0] += FlxG.elapsed * HUE_RATE
        if(shiftedHSB[i][0] >= 360) {
          shiftedHSB[i][0] = 0;
        }

        shiftedColors[i] = FlxU.makeColorFromHSB(shiftedHSB[i][0], shiftedHSB[i][1], shiftedHSB[i][2]);
      }

      if(FlxG.keys.justPressed("SPACE")) {
        FlxG.log(FlxG.camera.buffer.getPixel32(40,40));
      }

      super.update();
    }

    override public function draw():void {
      super.draw();

      hueShiftCamera(FlxG.camera);
      aberrateCamera(FlxG.camera);
      /*
        var blueBuffer:BitmapData = new BitmapData(FlxG.camera.width, FlxG.camera.height, true, 0x00000000);
        blueBuffer.copyChannel(buffer, sourceRect, new Point(4,5), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA); 
        blueBuffer.copyChannel(buffer, sourceRect, new Point(4,5), BitmapDataChannel.BLUE, BitmapDataChannel.BLUE); 
        FlxG.camera.buffer.draw(blueBuffer, null, null, "add");

        var greenBuffer:BitmapData = new BitmapData(FlxG.camera.width, FlxG.camera.height, true, 0x00000000);
        greenBuffer.copyChannel(buffer, sourceRect, new Point(3,4), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA); 
        greenBuffer.copyChannel(buffer, sourceRect, new Point(3,4), BitmapDataChannel.GREEN, BitmapDataChannel.GREEN); 
        FlxG.camera.buffer.draw(greenBuffer, null, null, "add");
      */
    }

    protected function hueShiftCamera(camera:FlxCamera):void {
      var colorIndex:int = -1;

      for(var row:uint = 0; row < camera.height; row++) {
        for(var column:uint = 0; column < camera.width; column++) {
          colorIndex = colors.indexOf(camera.buffer.getPixel32(column,row));
					if(colorIndex > -1) {
						camera.buffer.setPixel32(column,row,shiftedColors[colorIndex]);
					}
				}
			}
      //
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
        var point:Point = new Point(Math.sin(channel + sin) * 1 + offsets[channel].x, Math.cos(channel + sin) * 1 + offsets[channel].y);
         
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
