/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.persist
{
    public interface ISerializableObject
    {
        function save():Object;
        function load(data:Object):void;
        function setChanged():void;
    }
}
