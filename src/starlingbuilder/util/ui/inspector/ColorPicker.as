package starlingbuilder.util.ui.inspector
{
    import feathers.controls.TextInput;
    import feathers.events.FeathersEventType;

    import flash.display.Bitmap;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.display.Stage;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.filters.ColorMatrixFilter;
    import starling.textures.Texture;

    public class ColorPicker extends Sprite
    {
        public static const TOP_LEFT:String = "topLeft";
        public static const TOP_RIGHT:String = "topRight";
        public static const BOTTOM_LEFT:String = "bottomLeft";
        public static const BOTTOM_RIGHT:String = "bottomRight";

        [Embed(source="palette.png")]
        private static const Palette:Class;

        private var _square:Button;
        private var _colorFilter:ColorMatrixFilter;

        private var _palette:Image;
        private var _bitmap:Bitmap;

        private var _value:uint = 0xffffff;

        private var _sprite:Sprite;

        private var _textInput:TextInput;

        public function ColorPicker()
        {
            _bitmap = new Palette();
            _colorFilter = new ColorMatrixFilter();

            _square = new Button(Texture.fromColor(20, 20));
            _square.filter = _colorFilter;
            _square.scaleWhenDown = 1;
            _palette = new Image(Texture.fromBitmap(_bitmap));

            addChild(_square);

            _square.addEventListener(Event.TRIGGERED, onSquare);
            _palette.addEventListener(TouchEvent.TOUCH, onPalette);

            _textInput = new TextInput();
            _textInput.y = _palette.height;
            _textInput.addEventListener(FeathersEventType.FOCUS_OUT, onTextInput);
            _textInput.addEventListener(FeathersEventType.ENTER, onTextInput);
            _textInput.addEventListener(Event.CLOSE, onTextInput);

            _sprite = new Sprite();
            _sprite.addChild(_palette);
            _sprite.addChild(_textInput);

        }

        private function onSquare(event:Event):void
        {
            togglePalette();
        }

        private function togglePalette():void
        {
            if (_sprite.stage == null)
            {
                Starling.current.stage.addChild(_sprite);
                autoPositionPalette();
            }
            else
            {
                Starling.current.stage.removeChild(_sprite);
            }
        }

        private function autoPositionPalette():void
        {
            var directions:Array = [BOTTOM_LEFT, TOP_LEFT, BOTTOM_RIGHT, TOP_RIGHT];

            for each (var direction:String in directions)
            {
                positionPalette(direction);

                if (insideViewPort(_sprite))
                {
                    break;
                }
            }
        }

        private function insideViewPort(obj:DisplayObject):Boolean
        {
            var stage:Stage = Starling.current.stage;

            var rect:Rectangle = obj.getBounds(stage);
            var stageRect:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

            return stageRect.containsRect(rect);
        }


        private function positionPalette(type:String):void
        {
            var pt:Point;

            switch (type)
            {
                case BOTTOM_LEFT:
                    pt = localToGlobal(new Point(-10, 0));
                    _sprite.x = pt.x - _sprite.width;
                    _sprite.y = pt.y;
                    break;
                case BOTTOM_RIGHT:
                    pt = localToGlobal(new Point(30, 0));
                    _sprite.x = pt.x;
                    _sprite.y = pt.y;
                    break;
                case TOP_LEFT:
                    pt = localToGlobal(new Point(-10, 20));
                    _sprite.x = pt.x - _sprite.width;
                    _sprite.y = pt.y - _sprite.height;
                    break;
                case TOP_RIGHT:
                    pt = localToGlobal(new Point(30, 20));
                    _sprite.x = pt.x;
                    _sprite.y = pt.y - _sprite.height;
                    break;
            }
        }


        private function onPalette(event:TouchEvent):void
        {
            var target:DisplayObject = DisplayObject(event.target);

            var touch:Touch = event.getTouch(target);

            if (touch)
            {
                var loc:Point = touch.getLocation(target);

                if (touch.phase == TouchPhase.BEGAN || touch.phase == TouchPhase.MOVED || touch.phase == TouchPhase.ENDED)
                {
                    value = getColor(loc.x, loc.y);
                    dispatchEventWith(Event.CHANGE);
                }

                if (touch.phase == TouchPhase.ENDED)
                {
                    _sprite.removeFromParent();
                }
            }
        }

        private function onTextInput(event:Event):void
        {
            value = uint(_textInput.text);
            dispatchEventWith(Event.CHANGE);
        }

        public function get value():uint
        {
            return _value;
        }

        public function set value(value:uint):void
        {
            _value = value;

            updateColor(_value);
        }

        private function updateColor(color:uint):void
        {
            _colorFilter.reset();
            _colorFilter.tint(color);
            _textInput.text = "0x" + value.toString(16);
        }

        private function getColor(x:int, y:int):uint
        {
            return _bitmap.bitmapData.getPixel(x, y);
        }

        override public function dispose():void
        {
            _square.removeEventListener(Event.TRIGGERED, onSquare);
            _palette.removeEventListener(TouchEvent.TOUCH, onPalette);

            _sprite.removeFromParent(true);
            _palette.texture.dispose();

            _square.removeFromParent(true);
            _square.upState.dispose();

            super.dispose();
        }


    }

}