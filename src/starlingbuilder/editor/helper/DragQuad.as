/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Quad;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class DragQuad
    {
        public static function startDrag(obj:DisplayObject, onComplete:Function):void
        {
            var startX:Number;
            var startY:Number;

            var quad:Quad = new Quad(1, 1, 0x000000);
            quad.alpha = 0.1;
            quad.touchable = false;
            Starling.current.stage.addChild(quad);

            function onTouch(event:TouchEvent):void
            {
                var touch:Touch = event.getTouch(obj);

                if (touch)
                {
                    if (touch.phase == TouchPhase.BEGAN)
                    {
                        startX = touch.globalX;
                        startY = touch.globalY;

                        quad.visible = false;
                    }
                    else if (touch.phase == TouchPhase.MOVED)
                    {
                        quad.visible = true;
                    }
                    else if (touch.phase == TouchPhase.ENDED)
                    {
                        quad.visible = false;

                        if (onComplete)
                            onComplete(quad.getBounds(Starling.current.stage));
                    }

                    if (!isNaN(startX) && !isNaN(startY))
                    {
                        quad.x = Math.min(startX, touch.globalX);
                        quad.y = Math.min(startY, touch.globalY);
                        quad.width = Math.abs(touch.globalX - startX);
                        quad.height = Math.abs(touch.globalY - startY);
                    }
                }
            }

            obj.addEventListener(TouchEvent.TOUCH, onTouch);
        }

        public static function endDrag(obj:DisplayObject):void
        {
            obj.removeEventListeners(TouchEvent.TOUCH);
        }
    }
}
