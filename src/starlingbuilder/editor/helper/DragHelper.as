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

    public class DragHelper
    {
        public function DragHelper()
        {
        }

        public static function startDrag(obj:DisplayObject, onSelect:Function, onDrag:Function, onRelease:Function):void
        {
            var previousX:Number;
            var previousY:Number;

            function onTouch(event:TouchEvent):void
            {
                var touch:Touch = event.getTouch(obj);

                if (touch)
                {
                    if (touch.phase == TouchPhase.BEGAN)
                    {
                        if (onSelect) onSelect(obj);
                    }
                    else if (touch.phase == TouchPhase.MOVED)
                    {
                        if (!isNaN(previousX) && !isNaN(previousY))
                        {
                            var dx:Number = touch.globalX - previousX;
                            var dy:Number = touch.globalY - previousY;

                            if (onDrag)
                            {
                                if (onDrag(obj, dx, dy))
                                {
                                    previousX = touch.globalX;
                                    previousY = touch.globalY;
                                }
                            }
                        }
                        else
                        {
                            previousX = touch.globalX;
                            previousY = touch.globalY;
                        }
                    }
                    else if (touch.phase == TouchPhase.ENDED)
                    {
                        if (onRelease) onRelease();

                        previousX = Number.NaN;
                        previousY = Number.NaN;
                    }
                }

                event.stopPropagation();
            }


            obj.addEventListener(TouchEvent.TOUCH, onTouch);
        }

        public static function endDrag(obj:DisplayObject):void
        {
            obj.removeEventListeners(TouchEvent.TOUCH);
        }


    }
}
