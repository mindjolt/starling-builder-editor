/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util
{
    import flash.geom.Rectangle;

    import starling.display.Quad;
    import starling.display.Sprite;

    public class DrawUtil
    {
        public static function makeLine(x1:Number, y1:Number, x2:Number, y2:Number, color:uint = 0x0):Quad
        {
            var len:Number = MathUtil.distance(x1, y1, x2, y2);

            if (len == 0)
            {
                len = 1;
            }

            var quad:Quad = new Quad(len, 1, color);
            quad.pivotY = quad.height * 0.5;
            quad.x = x1;
            quad.y = y1;
            quad.rotation = Math.atan2(y2 - y1, x2 - x1);
            return quad;
        }

        public static function makeRect(rect:Rectangle, color:uint = 0x0):Sprite
        {
            var sprite:Sprite = new Sprite();
            sprite.addChild(makeLine(rect.left, rect.top, rect.right, rect.top, color));
            sprite.addChild(makeLine(rect.left, rect.bottom, rect.right, rect.bottom, color));
            sprite.addChild(makeLine(rect.left, rect.top, rect.left, rect.bottom, color));
            sprite.addChild(makeLine(rect.right, rect.top, rect.right, rect.bottom, color));
            return sprite;
        }
    }
}
