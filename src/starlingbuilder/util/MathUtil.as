/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util
{
    public class MathUtil
    {
        public static function distance2(x1:Number, y1:Number, x2:Number, y2:Number):Number
        {
            return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2);
        }

        public static function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number
        {
            return Math.sqrt(distance2(x1, y1, x2, y2));
        }

        public static function gridDistance(x1:Number, y1:Number, x2:Number, y2:Number):Number
        {
            return Math.abs(x1 - x2) + Math.abs(y1 - y2);
        }

        public static function gridUnitVector(x1:Number, y1:Number, x2:Number, y2:Number):Object
        {
            var x:int = (x2 - x1);
            var y:int = (y2 - y1);

            var max:int = Math.max(Math.abs(x), Math.abs(y));

            return { x: int(x / max), y: int(y / max)};
        }

        public static function rouletteSelectFromArray(array:Array):int
        {
            var i:Number;
            var sum:Number = 0;

            for (i = 0; i < array.length; i++)
                sum += array[i];

            var value:Number = Math.random() * sum;

            sum = 0;
            for (i = 0; i < array.length; i++)
            {
                sum += array[i];
                if (sum > value) break;
            }

            return i;
        }

        public static function rouletteSelect(object:Object):Object
        {
            var id:Object;
            var sum:Number = 0;

            for (id in object)
            {
                sum += object[id];
            }

            var value:Number = Math.random() * sum;

            sum = 0;
            for (id in object)
            {
                sum += object[id];
                if (sum > value) break;
            }

            return id;
        }

        public static function randomSelect(array:Array):*
        {
            if (array && array.length > 0)
                return array[int(Math.random() * array.length)];
            else
                return null;
        }

        public static function shuffle(array:Array):Array
        {
            var oldArray:Array = array.concat();
            var newArray:Array = [];

            while (oldArray.length > 0)
                newArray.push(oldArray.splice(int(Math.random() * oldArray.length), 1)[0]);

            return newArray;
        }

        public static function randomBetween(value1:Number, value2:Number):Number
        {
            var random:Number = Math.min(value1, value2) + Math.random() * (Math.max((value1, value2) - Math.min(value1, value2)));
            return random;
        }

        public function MathUtil()
        {
        }
    }
}
