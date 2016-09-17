/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util
{
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    import org.as3commons.reflect.Method;
    import org.as3commons.reflect.Type;
    import org.as3commons.reflect.Variable;

    public class ObjectUtil
    {
        public function ObjectUtil()
        {
        }

        public static function getCallee(calltStackIndex:int = 3):String
        {
            var stackTrace:Array = new Error().getStackTrace().split("\n", calltStackIndex + 2);
            trace(JSON.stringify(stackTrace));
            if (stackTrace.length && stackTrace[calltStackIndex])
            {
                var stackLine:String = stackTrace[calltStackIndex];
                var objectMethod:Array = stackLine.match(/\w*\/*\w*\(\)/g);
                if (objectMethod.length && objectMethod[0])
                    return objectMethod[0];
            }
            return null;
        }

        public static function objectToArray(object:Object):Array
        {
            var array:Array = [];

            for (var id:String in object)
            {
                if (object[id]) array.push(object[id]);
            }

            return array;
        }

        public static function objectKeyToArray(object:Object):Array
        {
            var array:Array = [];

            for (var id:String in object)
            {
                array.push(id);
            }

            return array;
        }

        public static function dictionaryToArray(dict:Dictionary):Array
        {
            var array:Array = [];

            for (var id:Object in dict)
            {
                if (dict[id]) array.push(dict[id]);
            }

            return array;
        }

        public static function concatObjectsToArray(...objects):Array
        {
            var array:Array = [];

            for (var i:int = 0; i < objects.length; i++)
            {
                var object:Object = objects[i];
                array = array.concat(objectToArray(object));
            }

            return array;
        }

        public static function concatObjectsToObject(...objects):Object
        {
            var result:Object = {};

            for (var i:int = 0; i < objects.length; i++)
            {
                var object:Object = objects[i];

                for (var id:String in object)
                {
                    result[id] = object[id];
                }
            }

            return result;
        }

        public static function concatArrayWithoutDuplicate(...arrays:Array):Array
        {
            var result:Array = [];

            for (var i:int = 0; i < arrays.length; i++)
            {
                var array:Array = arrays[i];

                for each (var object:Object in array)
                {
                    if (result.indexOf(object) == -1)
                        result.push(object);
                }
            }

            return result;
        }

        public static function isEmptyObject(object:Object):Boolean
        {
            if (object == null) return true;

            for (var id:String in object)
            {
                return false;
            }

            return true;
        }

        public static function isNullValuesObject(object:Object):Boolean
        {
            if (object == null) return true;

            for (var id:String in object)
            {
                if (object[id] !== null)
                    return false;
            }

            return true;
        }

        public static function numOfProperty(object:Object):int
        {
            var num:int = 0;

            for (var id:String in object)
            {
                num++;
            }

            return num;
        }

        public static function objectLength(myObject:Object):int
        {
            var size:int = 0;
            for (var s:String in myObject)
            {
                size++;
            }
            return size;
        }

        public static function cloneObject(object:Object):Object
        {
            var clone:ByteArray = new ByteArray();
            clone.writeObject(object);
            clone.position = 0;
            return(clone.readObject());
        }

        public static function fromJSONObject(target:Object, json:Object):void
        {
            var type:Type = Type.forInstance(target);
            for each(var k:* in type.fields)
            {
                if (k is Variable && json.hasOwnProperty(k.name))
                {
//                    if (target[k.name] is SimpleReflectionObject)
//                        target[k.name] = new k.type.clazz(json[k.name]);
//                    else
                        target[k.name] = json[k.name];
                }
            }
        }

        public static function toJSONObject(target:Object):Object
        {
            var obj:Object = {};
            var type:Type = Type.forInstance(target);
            var found:Boolean;
            for each(var k:* in type.fields)
            {
                if (k is Variable)
                {
                    if (target[k.name])
                    {
                        found = false;
                        for each(var m:Method in Type.forInstance(target[k.name]).methods)
                        {
                            if (m.name == "toJSONObject")
                            {
                                obj[k.name] = target[k.name].toJSONObject();
                                found = true;
                                break;
                            }
                        }
                        if (found) continue;
                    }
                    obj[k.name] = target[k.name];
                }
            }
            return obj;
        }

        public static function validJSON(text:String):Boolean
        {
            if (/^[\],:{}\s]*$/.test(text.replace(/\\["\\\/bfnrtu]/g, '@').
                    replace(/"[^"\\\n\r]*"|true|false|null|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?/g, ']').
                    replace(/(?:^|:|,)(?:\s*\[)+/g, '')))
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static function objectValuesFromPropertyNames(obj:Object):Object
        {
            var o:Object = {};
            for (var s:String in obj)
            {
                o[s] = s;
            }
            return o;
        }

        public static function inArray(needle:*, haystack:Array):Boolean
        {
            // Search variable needle in array haystack
            var itemIndex:int = haystack.indexOf(needle);
            return ( itemIndex < 0 ) ? false : true;
        }

        public static function getRandomElementOf(array:Array):*
        {
            if (!array || !array.length)
                return null;
            var idx:int = Math.floor(Math.random() * array.length);
            return array[idx];
        }

        public static function isObject(value:Object):Boolean
        {
            return getQualifiedClassName(value) == "Object";
        }
    }
}
