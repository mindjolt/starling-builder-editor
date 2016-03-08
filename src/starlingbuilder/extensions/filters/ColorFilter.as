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

    /**
     *  There's a limitation of this class:
     *  ONLY one of the properties will work each time since there's a reset for every property setter
     */
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

        private function resetValues():void
        {
            _hue = _contrast = _brightness = _saturation = 0;
        }

        public function set hue(value:Number):void
        {
            resetValues();
            _hue = value;
            reset();
            adjustHue(_hue);
        }

        public function get hue():Number
        {
            return _hue;
        }

        public function set contrast(value:Number):void
        {
            resetValues();
            _contrast = value;
            reset();
            adjustContrast(_contrast);
        }

        public function get contrast():Number
        {
            return _contrast;
        }

        public function set brightness(value:Number):void
        {
            resetValues();
            _brightness = value;
            reset();
            adjustBrightness(_brightness);
        }

        public function get brightness():Number
        {
            return _brightness;
        }

        public function set saturation(value:Number):void
        {
            resetValues();
            _saturation = value;
            reset();
            adjustSaturation(_saturation);
        }

        public function get saturation():Number
        {
            return _saturation;
        }
    }
}
