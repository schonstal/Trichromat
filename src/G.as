package
{
    import org.flixel.*;
    import components.MP3Pitch;

    public class G
    {
        public var _paused:Boolean;
        public var _started:Boolean;
        public var _game:FlxGame;
        public var _hueShift:Number;
        public var _mp3Pitch:MP3Pitch;

        private static var _instance:G = null;

        public function G() {
        }

        private static function get instance():G {
            if(_instance == null) {
                _instance = new G();
                _instance._paused = false;
                _instance._hueShift = 0;
                _instance._started = false;
            }

            return _instance;
        }

        public static function get paused():Boolean {
          return instance._paused;
        }

        public static function set paused(value:Boolean):void {
          instance._paused = value;
        }

        public static function get started():Boolean {
          return instance._started;
        }

        public static function set started(value:Boolean):void {
          instance._started = value;
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

        public static function get pitcher():MP3Pitch {
          return instance._mp3Pitch;
        }

        public static function set pitcher(value:MP3Pitch):void {
          instance._mp3Pitch = value;
        }
    }
}
