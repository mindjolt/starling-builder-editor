/**
 * Created by hyh on 5/15/15.
 */
package starlingbuilder.util.ui.inspector
{
    public class WidthAndHeightPropertyRetriever extends DefaultPropertyRetriever
    {
        public function WidthAndHeightPropertyRetriever(target:Object, param:Object = null):void
        {
            super(target, param);
        }

        override public function set(name:String, value:Object):void
        {
            //disable resize when rotation is not 0
            if (_target.rotation != 0) return;

            var sx:Number = sign(_target.scaleX);
            var sy:Number = sign(_target.scaleY);

            value = formatType(name, value);
            _target[name] = value;

            if (sx != sign(_target.scaleX))
                _target.scaleX *= -1;

            if (sy != sign(_target.scaleY))
                _target.scaleY *= -1;
        }

        override public function get(name:String):Object
        {
            return _target[name];
        }

        private static function sign(value:Number):Number
        {
            if (value < 0)
            {
                return -1;
            }
            else
            {
                return 1;
            }
        }

    }
}
