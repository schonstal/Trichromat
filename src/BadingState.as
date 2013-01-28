package
{
    import org.flixel.*;

    public class BadingState extends FlxState
    {
        private var _elapsed:Number = 0;
        private var _rate:Number = 2;
        private var logoSprite:FlxSprite;

        public static const BLACK_TIME = 1;
        public static const MUSIC_TIME = 0.5;

        override public function create():void
        {
          logoSprite = new FlxSprite(0,0);
          logoSprite.loadGraphic(Assets.Splash, false, false, 320, 180);
          add(logoSprite);

          FlxG.play(Assets.BaDing);
        }

        override public function update():void
        {
            if(!G.api)
              (G.api = FlxG.stage.addChild(new KongApi()) as KongApi).init();

            G.hueShift += FlxG.elapsed * 400;

            _elapsed += FlxG.elapsed;
            if(_elapsed >= _rate) {
              logoSprite.exists = false;
            }
            if(_elapsed > _rate + MUSIC_TIME) {
              G.pitcher.rate += FlxG.elapsed * 0.75;
            }
            if(_elapsed > _rate + BLACK_TIME) {
              FlxG.switchState(new PlayState());
            }
            super.update();
        }
    }
}
