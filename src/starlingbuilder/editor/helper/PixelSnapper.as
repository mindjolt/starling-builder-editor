/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import starling.utils.Color;

    import starlingbuilder.util.DrawUtil;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;

    public class PixelSnapper
    {
        private static const NONE:int = -1;
        private static const MIN:int = 0;
        private static const MIDDLE:int = 1;
        private static const MAX:int = 2;

        public static function snap(selectObj:DisplayObject, container:DisplayObjectContainer, canvas:DisplayObjectContainer, delta:Point, threshold:Number = 3):PixelSnapperData
        {
            var i:int, j:int, k:int;
            var x1:Number, x2:Number, y1:Number, y2:Number;
            var bx:Array, by:Array;

            var minX:Number = int.MAX_VALUE;
            var minY:Number = int.MAX_VALUE;

            var targetObjX:DisplayObject;
            var targetObjY:DisplayObject;

            var selectObjSnapXType:int = NONE;
            var selectObjSnapYType:int = NONE;

            var targetObjSnapXType:int = NONE;
            var targetObjSnapYType:int = NONE;

            var deltaX:Number;
            var deltaY:Number;


            var sbx:Array = getXBoundary(selectObj);
            var sby:Array = getYBoundary(selectObj);

            var objects:Array = [];

            var obj:DisplayObject;

            for (i = 0; i < container.numChildren; ++i)
            {
                obj = container.getChildAt(i);

                if (!obj.visible || !obj.touchable) continue;

                if (selectObj === obj) continue;

                objects.push(obj);
            }

            objects.push(canvas);

            for each (obj in objects)
            {
                if (obj === canvas)
                {
                    bx = getCanvasXBoundary(obj);
                    by = getCanvasYBoundary(obj);
                }
                else
                {
                    bx = getXBoundary(obj);
                    by = getYBoundary(obj);
                }


                for (j = 0; j < sbx.length; ++j)
                {
                    x1 = sbx[j];

                    for (k = 0; k < bx.length; ++k)
                    {
                        x2 = bx[k];

                        if (Math.abs(x2 - (x1 + delta.x)) < Math.abs(minX))
                        {
                            minX = x2 - (x1 + delta.x);
                            targetObjX = obj;
                            selectObjSnapXType = j;
                            targetObjSnapXType = k;
                        }
                    }
                }

                for (j = 0; j < sby.length; ++j)
                {
                    y1 = sby[j];

                    for (k = 0; k < by.length; ++k)
                    {
                        y2 = by[k];

                        if (Math.abs(y2 - (y1 + delta.y)) < Math.abs(minY))
                        {
                            minY = y2 - (y1 + delta.y);
                            targetObjY = obj;
                            selectObjSnapYType = j;
                            targetObjSnapYType = k;
                        }
                    }
                }
            }

            var canSnap:Boolean = false;

            deltaX = delta.x;
            deltaY = delta.y;

            if (Math.abs(minX) <= threshold)
            {
                canSnap = true;
                deltaX += minX;
            }
            else
            {
                targetObjX = null;
                selectObjSnapXType = targetObjSnapXType = NONE;
            }

            if (Math.abs(minY) <= threshold)
            {
                canSnap = true;
                deltaY += minY;
            }
            else
            {
                targetObjY = null;
                selectObjSnapYType = targetObjSnapYType = NONE;
            }

            if (canSnap)
            {
                return new PixelSnapperData(selectObj, targetObjX, targetObjY, selectObjSnapXType, selectObjSnapYType, targetObjSnapXType, targetObjSnapYType, deltaX, deltaY);
            }
            else
            {
                return null;
            }


        }

        private static function getXBoundary(obj:DisplayObject):Array
        {
            if (obj)
            {
                var rect:Rectangle = obj.getBounds(Starling.current.stage);
                return [rect.x, rect.x + rect.width * 0.5, rect.x + rect.width];
            }
            else
            {
                return null;
            }
        }

        private static function getYBoundary(obj:DisplayObject):Array
        {
            if (obj)
            {
                var rect:Rectangle = obj.getBounds(Starling.current.stage);
                return [rect.y, rect.y + rect.height * 0.5, rect.y + rect.height];
            }
            else
            {
                return null;
            }
        }

        private static function getCanvasXBoundary(obj:DisplayObject):Array
        {
            if (obj)
            {
                var rect:Rectangle = obj.getBounds(Starling.current.stage);
                return [rect.x, Number.MAX_VALUE, rect.x + rect.width];
            }
            else
            {
                return null;
            }
        }

        private static function getCanvasYBoundary(obj:DisplayObject):Array
        {
            if (obj)
            {
                var rect:Rectangle = obj.getBounds(Starling.current.stage);
                return [rect.y, Number.MAX_VALUE, rect.y + rect.height];
            }
            else
            {
                return null;
            }
        }

        public static function drawSnapLine(container:DisplayObjectContainer, data:PixelSnapperData):void
        {
            var x1:Number, x2:Number, y1:Number, y2:Number;
            var global1:Point, global2:Point;

            var selectObjXBound:Array = getXBoundary(data.selectObj);
            var selectObjYBound:Array = getYBoundary(data.selectObj);
            var targetXXBound:Array = getXBoundary(data.targetObjX);
            var targetXYBound:Array = getYBoundary(data.targetObjX);
            var targetYXBound:Array = getXBoundary(data.targetObjY);
            var targetYYBound:Array = getYBoundary(data.targetObjY);


            if (data.targetObjX)
            {
                x1 = selectObjXBound[data.selectObjSnapXType];
                y1 = selectObjYBound[MIDDLE];

                x2 = targetXXBound[data.targetObjSnapXType];
                y2 = targetXYBound[MIDDLE];

                global1 = container.globalToLocal(new Point(x1, y1));
                global2 = container.globalToLocal(new Point(x2, y2));

                container.addChild(DrawUtil.makeLine(global1.x, global1.y, global2.x, global2.y, Color.RED));
            }

            if (data.targetObjY)
            {
                x1 = selectObjXBound[MIDDLE];
                y1 = selectObjYBound[data.selectObjSnapYType];

                x2 = targetYXBound[MIDDLE];
                y2 = targetYYBound[data.targetObjSnapYType];

                global1 = container.globalToLocal(new Point(x1, y1));
                global2 = container.globalToLocal(new Point(x2, y2));

                container.addChild(DrawUtil.makeLine(global1.x, global1.y, global2.x, global2.y, Color.RED));
            }
        }

        public static function drawSnapObjectBound(container:DisplayObjectContainer, data:PixelSnapperData):void
        {
            if (data.targetObjX)
            {
                container.addChild(DrawUtil.makeRect(data.targetObjX.getBounds(container), Color.LIME));
            }

            if (data.targetObjY)
            {
                container.addChild(DrawUtil.makeRect(data.targetObjY.getBounds(container), Color.LIME));
            }
        }




    }
}
