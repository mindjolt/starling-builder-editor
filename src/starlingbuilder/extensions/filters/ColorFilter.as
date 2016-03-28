/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.extensions.filters
{
    import starling.filters.ColorMatrixFilter;

    public class ColorFilter extends ColorMatrixFilter
    {
        private var _hue:Number = 0;
        private var _contrast:Number = 0;
        private var _brightness:Number = 0;
        private var _saturation:Number = 0;

        public function ColorFilter(matrix:Vector.<Number> = null)
        {
            super(matrix);
        }

        public function set hue(value:Number):void
        {
            _hue = value;
            adjustValues();
        }

        public function get hue():Number
        {
            return _hue;
        }

        public function set contrast(value:Number):void
        {
            _contrast = value;
            adjustValues();
        }

        public function get contrast():Number
        {
            return _contrast;
        }

        public function set brightness(value:Number):void
        {
            _brightness = value;
            adjustValues();
        }

        public function get brightness():Number
        {
            return _brightness;
        }

        public function set saturation(value:Number):void
        {
            _saturation = value;
            adjustValues();
        }

        public function get saturation():Number
        {
            return _saturation;
        }

        private function adjustValues():void
        {
            reset();
            adjustHue(_hue);
            adjustBrightness(_brightness);
            adjustContrast(_contrast);
            adjustSaturation(_saturation);
        }
    }
}
