/**
 * Created by hyh on 1/14/16.
 */
package starlingbuilder.editor
{
    import feathers.data.ListCollection;

    import flash.geom.Point;

    import starling.core.Starling;

    import starling.display.DisplayObject;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class CITestUtil
    {
        public static function simulateTouch(target:DisplayObject, offsetX:Number = 0, offsetY:Number = 0, dx:Number = 0, dy:Number = 0):void
        {
            var position:Point = target.localToGlobal(new Point(offsetX, offsetY));
            var target:DisplayObject = target.stage.hitTest(position, true);
            var touch:Touch = new Touch(0);
            touch.target = target;
            touch.phase = TouchPhase.BEGAN;
            touch.globalX = position.x;
            touch.globalY = position.y;
            var touches:Vector.<Touch> = new <Touch>[touch];
            target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

            touch.phase = TouchPhase.MOVED;
            target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));

            touch.globalX += dx;
            touch.globalY += dy;
            touch.phase = TouchPhase.MOVED;
            target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));


            touch.phase = TouchPhase.ENDED;
            target.dispatchEvent(new TouchEvent(TouchEvent.TOUCH, touches));
        }

        public static function findDisplayObject(options:Object, container:DisplayObjectContainer = null):DisplayObject
        {
            if (container == null)
                container = Starling.current.stage;

            for (var i:int = 0; i < container.numChildren; ++i)
            {
                var child:DisplayObject = container.getChildAt(i);

                for (var name:String in options)
                {
                    var value:String = options[name];

                    if (child.hasOwnProperty(name) && child[name] == value)
                        return child;

                    if ("cls" in options && child is options.cls)
                        return child;
                }

                if (child is DisplayObjectContainer)
                {
                    var obj:DisplayObject = findDisplayObject(options, child as DisplayObjectContainer);
                    if (obj) return obj;
                }
            }

            return null;
        }

        public static function findListCollectionIndex(listCollection:ListCollection, text:String):int
        {
            for (var i:int = 0; i < listCollection.length; ++i)
            {
                var item:Object = listCollection.getItemAt(i);
                if (item.label == text)
                    return i;
            }

            return -1;
        }
    }




}
