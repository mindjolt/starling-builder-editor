/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.extensions.filters
{
    import starling.filters.BlurFilter;
    import starling.filters.FragmentFilterMode;

    public class GlowFilter extends BlurFilter
    {
        protected var mColor:uint;
        protected var mAlpha:Number;

        public function GlowFilter(color:uint=0xffff00, alpha:Number=1.0, blur:Number=1.0,
                                   resolution:Number=0.5)
        {
            super(blur, blur, resolution);
            mode = FragmentFilterMode.BELOW;
            mColor = color;
            mAlpha = alpha;
            setUniformColor(true, mColor, mAlpha);
        }

        public function set color(value:uint):void
        {
            mColor = value;
            setUniformColor(true, mColor, mAlpha);
        }

        public function get color():uint
        {
            return mColor;
        }

        public function set alpha(value:Number):void
        {
            mAlpha = value;
            setUniformColor(true, mColor, mAlpha);
        }

        public function get alpha():Number
        {
            return mAlpha;
        }

        public function get blur():Number
        {
            return blurX;
        }

        public function set blur(value:Number):void
        {
            blurX = blurY = value;
        }
    }
}
