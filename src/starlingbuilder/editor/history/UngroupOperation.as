/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.history
{
    public class UngroupOperation extends GroupOperation
    {
        public function UngroupOperation(container:Object, children:Array)
        {
            super(container, children);
            _type = OperationType.UNGROUP;
        }

        override public function undo():void
        {
            super.redo();
        }

        override public function redo():void
        {
            super.undo();
        }

        override public function info():String
        {
            return "Ungroup";
        }
    }
}
