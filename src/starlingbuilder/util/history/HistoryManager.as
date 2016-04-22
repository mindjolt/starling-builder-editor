/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.history
{
import starling.events.Event;
import starling.events.EventDispatcher;

import starlingbuilder.editor.history.OperationType;

public class HistoryManager extends EventDispatcher
    {
        public static const RESET:String = "reset";

        private var _maxHistoryRecord:int;

        private var _operations:Array = [];
        private var _currentIndex:int = -1;

        public function HistoryManager(maxHistoryRecord:int = 50)
        {
            _maxHistoryRecord = maxHistoryRecord;
        }

        public function add(operation:IHistoryOperation):void
        {

            //cut off history if it's not on the end
            while (_currentIndex < _operations.length - 1)
            {
                _operations.pop();
            }

            var prev:IHistoryOperation;

            if (_currentIndex >= 0 && _currentIndex < _operations.length)
            {
                prev = _operations[_currentIndex];
            }

            if (prev && operation.canMergeWith(prev))
            {
                _operations.pop();
                --_currentIndex;
                operation.merge(prev);
            }
            else
            {
                trace(operation.info());
            }

            _operations.push(operation);
            _currentIndex = _operations.length - 1;


            while (_operations.length > _maxHistoryRecord)
            {
                var op:IHistoryOperation = _operations.shift();
                //op.dispose(); //We can't dispose it in case the target is still on the stage or on other operations
                --_currentIndex;
            }

            if(operation.type != OperationType.MOVE){
                change();
            }

        }

        public function change():void{
            dispatchEventWith(Event.CHANGE);
        }

        public function undo():void
        {
            if (_currentIndex >= 0)
            {
                var operation:IHistoryOperation = _operations[_currentIndex];
                operation.undo();
                --_currentIndex;
            }
        }

        public function redo():void
        {
            if (_currentIndex < _operations.length - 1)
            {
                ++_currentIndex;
                var operation:IHistoryOperation = _operations[_currentIndex];
                operation.redo();
            }
        }

        public function reset():void
        {
            while (_operations.length > 0)
            {
                var op:IHistoryOperation = _operations.shift();
                op.dispose();
            }
            _currentIndex = -1;

            dispatchEventWith(RESET);
        }

        public function undoable():Boolean
        {
            return _currentIndex >= 0
        }

        public function redoable():Boolean
        {
            return _currentIndex + 1 < _operations.length;
        }

        public function getNextUndoHint():String
        {
            if (undoable())
            {
                var operation:IHistoryOperation = _operations[_currentIndex];
                return operation.info();
            }
            else
            {
                return null;
            }
        }

        public function getNextRedoHint():String
        {
            if (redoable())
            {
                var operation:IHistoryOperation = _operations[_currentIndex + 1];
                return operation.info();
            }
            else
            {
                return null;
            }
        }

        public function get numOperations():int
        {
            return _operations.length;
        }
    }
}
