/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.history
{
    import flash.utils.Dictionary;

    public class PasteOperation extends CreateOperation
    {
        public function PasteOperation(target:Object, paramDict:Dictionary, parent:Object)
        {
            super(target, paramDict, parent);
        }

        override public function info():String
        {
            return "Paste";
        }
    }
}
