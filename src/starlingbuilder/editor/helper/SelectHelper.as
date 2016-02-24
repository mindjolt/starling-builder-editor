/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import starling.display.DisplayObject;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class SelectHelper
    {
        public static function startSelect(object:DisplayObject, onSelect:Function):void
        {
            function onTouch(event:TouchEvent):void
            {
                var touch:Touch = event.getTouch(object);

                if (touch)
                {
                    if (touch.phase == TouchPhase.BEGAN)
                    {
                        onSelect(object);
                    }
                }

                event.stopPropagation();
            }

            object.addEventListener(TouchEvent.TOUCH, onTouch);
        }

        public static function endSelect(obj:DisplayObject):void
        {
            obj.removeEventListeners(TouchEvent.TOUCH);
        }
    }
}
