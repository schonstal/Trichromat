package
{
    import org.flixel.*;

    public class G
    {
        public var _paused:Boolean;

        private static var _instance:G = null;

        public function G() {
        }

        private static function get instance():G {
            if(_instance == null) {
                _instance = new G();
                _instance._paused = false;
            }

            return _instance;
        }

        public static function get paused():Boolean {
          return instance._paused;
        }

        public static function set paused(value:Boolean):void {
          instance._paused = value;
        }
    }
}
