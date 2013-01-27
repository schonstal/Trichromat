package
{
    import org.flixel.*;

    public class G
    {
        public var _paused:Boolean;
        public var _game:FlxGame;
        public var _hueShift:Number;

        private static var _instance:G = null;

        public function G() {
        }

        private static function get instance():G {
            if(_instance == null) {
                _instance = new G();
                _instance._paused = false;
                _instance._hueShift = 0;
            }

            return _instance;
        }

        public static function get paused():Boolean {
          return instance._paused;
        }

        public static function set paused(value:Boolean):void {
          instance._paused = value;
        }

        public static function get game():FlxGame {
          return instance._game;
        }

        public static function set game(value:FlxGame):void {
          instance._game = value;
        }

        public static function get hueShift():Number {
          return instance._hueShift;
        }

        public static function set hueShift(value:Number):void {
          instance._hueShift = value;
        }
    }
}
