/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.extensions.filters
{
    public class DropShadowFilter extends GlowFilter
    {
        private var mDistance:Number;
        private var mAngle:Number;

        public function DropShadowFilter(distance:Number=4.0, angle:Number=0.785,
                                         color:uint=0x0, alpha:Number=0.5, blur:Number=1.0,
                                         resolution:Number=0.5)
        {
            super(blur, blur, resolution);
            mDistance = distance;
            mAngle = angle;
            mColor = color;
            mAlpha = alpha;
            updateOffset();
        }

        public function set distance(value:Number):void
        {
            mDistance = value;
            updateOffset();
        }

        public function get distance():Number
        {
            return mDistance;
        }

        public function get angle():Number
        {
            return mAngle;
        }

        public function set angle(value:Number):void
        {
            mAngle = value;
            updateOffset();
        }

        private function updateOffset():void
        {
            offsetX = Math.cos(mAngle) * mDistance;
            offsetY = Math.sin(mAngle) * mDistance;
        }
    }
}
