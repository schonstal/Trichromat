package
{
  import org.flixel.*;

  public class Player extends FlxSprite
  {
    public static const START_X:Number = 84;
    public static const START_Y:Number = 64;

    public static const WALL_LEFT:uint = 1 << 1;
    public static const WALL_RIGHT:uint = 1 << 2;
    public static const WALL_UP:uint = 1 << 3;
    public static var WALL:uint = WALL_LEFT|WALL_RIGHT|WALL_UP;

    public static const RUN_SPEED:Number = 100;

    private var _speed:FlxPoint;
    private var _gravity:Number = 600; 

    private var _jumpPressed:Boolean = false;
    private var _grounded:Boolean = false;
    private var _jumping:Boolean = false;
    private var _landing:Boolean = false;
    private var _justLanded:Boolean = false;

    private var _groundedTimer:Number = 0;
    private var _groundedThreshold:Number = 0.07;
    
    private var currentRed:uint = 0;
    private var currentBlue:uint = 255;
    private var currentYellow:uint = 0;

    private var collisionFlags:uint = 0;

    private var jumpTimer:Number = 0;
    private var jumpThreshold:Number = 0.1;

    public var dead:Boolean = false;

    public var lockedToFlags:uint = 0;

    public var jumpAmount:Number = 300;


    private var deadTimer:Number = 0;
    private var deadThreshold:Number = 0.4;
    private var flying = false;

    public function Player(X:Number=START_X,Y:Number=START_Y):void {
      super(X,Y);
      loadGraphic(Assets.Player, true, true, 12, 12);
      addAnimation("idle", [0, 0, 0, 0, 0, 0, 1, 2, 3], 15, true);
      addAnimation("run", [6, 7, 8, 9, 10, 11], 15, true);
      addAnimation("run from landing", [8, 9, 10, 11, 6, 7], 15, true);
      addAnimation("jump start", [12], 15, true);
      addAnimation("jump peak", [13], 15, true);
      addAnimation("jump fall", [14], 15, true);
      addAnimation("jump land", [15], 15, false);
      addAnimation("die", [18]);
      play("idle");

      width = 8;
      height = 11;

      offset.y = 1;
      offset.x = 2;

      _speed = new FlxPoint();
      _speed.y = 215;
      _speed.x = 800;

      acceleration.y = _gravity;

      maxVelocity.y = 325;
      maxVelocity.x = RUN_SPEED;
    }

    public function init():void {
      x = START_X;
      y = START_Y;

      _jumpPressed = false;
      _grounded = false;
      _jumping = false;
      _landing = false;
      _justLanded = false;

      _groundedTimer = 0;
      collisionFlags = 0;

      jumpTimer = 0;

      lockedToFlags = 0;

      velocity.x = velocity.y = 0;
      acceleration.x = 0;
      acceleration.y = _gravity;
      exists = true;

      facing = RIGHT;
    }

    public function playRunAnim():void {
      if(!_jumping && !_landing) {
        if(_justLanded) play("run from landing");
        else play("run");
      }
    }

    override public function update():void {
      if(!dead) {
        //Check for jump input, allow for early timing
        jumpTimer += FlxG.elapsed;
        if(FlxG.keys.justPressed("W") || FlxG.keys.justPressed("UP")) {
          _jumpPressed = true;
          jumpTimer = 0;
          _grounded = false;
        }
        if(jumpTimer > jumpThreshold) {
          _jumpPressed = false;
        }

        if(collidesWith(WALL_UP)) {
          if(!_grounded) {
            play("jump land");
            _landing = true;
            _justLanded = true;
          }
          _grounded = true;
          _jumping = false;
          _groundedTimer = 0;
        } else {
          _groundedTimer += FlxG.elapsed;
          if(_groundedTimer >= _groundedThreshold) {
            _grounded = false;
          }
        }

        if(_landing && finished) {
          _landing = false;
        }

        if(FlxG.keys.A || FlxG.keys.LEFT) {
          acceleration.x = -_speed.x * (velocity.x > 0 ? 4 : 1);
          facing = LEFT;
          playRunAnim();
        } else if(FlxG.keys.D || FlxG.keys.RIGHT) {
          acceleration.x = _speed.x * (velocity.x < 0 ? 4 : 1);
          facing = RIGHT;
          playRunAnim();
        } else if (Math.abs(velocity.x) < 50) {
          if(!_jumping && !_landing) play("idle");
          velocity.x = 0;
          acceleration.x = 0;
          _justLanded = false;
        } else {
          _justLanded = false;
          var drag:Number = 3;
          if (velocity.x > 0) {
            acceleration.x = -_speed.x * drag;
          } else if (velocity.x < 0) {
            acceleration.x = _speed.x * drag;
          }
        }

        if(_jumpPressed) {
            if(_grounded) {
              FlxG.play(Assets.JumpSound);
              play("jump start");
              _jumping = true;
              velocity.y = -_speed.y;
              _jumpPressed = false;
            }
        }

        if(velocity.y < -1) {
          if(jumpPressed() && velocity.y > -25) {
            play("jump peak");
          }
        } else if (velocity.y > 1) {
          if(velocity.y > 100) {
            play("jump fall");
          }
        }


        if(FlxG.keys.LEFT) {
          jumpAmount--;
        }
        if(FlxG.keys.RIGHT) {
          jumpAmount++;
        }
            
        if(!jumpPressed() && velocity.y < 0)
          acceleration.y = _gravity * 3;
        else
          acceleration.y = _gravity;
      } else {
        deadTimer += FlxG.elapsed;
        if(deadTimer >= deadThreshold && !flying) {
          velocity.y = -125;
          acceleration.y = 400;
          flying = true;
        }
      }
      super.update();

      if(x < 0) x = FlxG.camera.width - width;
      if(x + width > FlxG.camera.width) x = 0;
    }

    public function jumpPressed():Boolean {
      return FlxG.keys.W || FlxG.keys.SPACE || FlxG.keys.UP;
    }

    public function resetFlags():void {
      collisionFlags = 0;
    }

    public function die():void {
      play("die");
      deadTimer = 0;
      dead = true;
      acceleration.y = acceleration.x = velocity.x = velocity.y = 0;
    }

    public function setCollidesWith(bits:uint):void {
      collisionFlags |= bits;
    }

    public function collidesWith(bits:uint):Boolean {
      return (collisionFlags & bits) > 0;
    }
  }
}
