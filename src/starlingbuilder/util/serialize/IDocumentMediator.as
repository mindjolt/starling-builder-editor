/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.serialize
{
    import flash.filesystem.File;

    public interface IDocumentMediator
    {
        function read(obj:Object, file:File):void;
        function write():Object;
        function get defaultSaveFilename():String;
    }
}
