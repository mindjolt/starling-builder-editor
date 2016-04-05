/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.upgrade
{
    public interface ILayoutConverter
    {
        function getCurrentVersion():String;

        function getUpgradePolicy(data:Object):String;

        function upgrade(data:Object):Object;
    }
}
