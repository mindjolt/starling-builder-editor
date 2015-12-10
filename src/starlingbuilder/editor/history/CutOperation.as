/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.history
{
    import flash.utils.Dictionary;

    import starling.display.DisplayObjectContainer;

    public class CutOperation extends DeleteOperation
    {
        public function CutOperation(target:Object, paramDict:Dictionary, parent:DisplayObjectContainer)
        {
            super(target, paramDict, parent);
        }

        override public function info():String
        {
            return "Cut";
        }
    }
}
