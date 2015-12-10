/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.history
{
    public interface IHistoryOperation
    {
        function get type():String
        function get timestamp():Number
        function get beforeValue():Object

        function canMergeWith(previousOperation:IHistoryOperation):Boolean
        function merge(previousOperation:IHistoryOperation):void


        function redo():void
        function undo():void

        function info():String

        function dispose():void
    }


}
