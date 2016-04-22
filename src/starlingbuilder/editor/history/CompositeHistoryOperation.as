/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.history
{
    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.controller.DocumentManager;
    import starlingbuilder.util.history.IHistoryOperation;

    public class CompositeHistoryOperation extends AbstractHistoryOperation
    {
        private var _operations:Array;
        private var _documentManager:DocumentManager;

        public function CompositeHistoryOperation(operations:Array)
        {
            _documentManager = UIEditorApp.instance.documentManager;

            var type:String;
            _operations = operations;
            if (_operations && _operations.length)
                type = _operations[0].type;
            super(type);
        }

        override public function redo():void
        {
            for (var i:int = 0; i < _operations.length; ++i)
            {
                _operations[i].redo();
            }

            _documentManager.boundingBoxContainer.reload();
        }

        override public function undo():void
        {
            for (var i:int = _operations.length - 1; i >= 0; --i)
            {
                _operations[i].undo();
            }

            _documentManager.boundingBoxContainer.reload();
        }

        override public function canMergeWith(previousOperation:IHistoryOperation):Boolean
        {
            return previousOperation is CompositeHistoryOperation
                    && _operations.length == previousOperation.operations.length && _operations.length > 0
                    && _operations[0].canMergeWith(previousOperation.operations[0]);
        }

        override public function merge(previousOperation:IHistoryOperation):void
        {
            var prev:CompositeHistoryOperation = previousOperation as CompositeHistoryOperation;

            if (prev)
            {
                for (var i:int = 0; i < _operations.length; ++i)
                {
                    _operations[i].merge(prev.operations[i]);
                }
            }
        }

        override public function get operations():Array
        {
            return _operations;
        }

        override public function info():String
        {
            if (_operations && _operations.length)
                return _operations[0].info();
            else
                return "";
        }
    }
}
