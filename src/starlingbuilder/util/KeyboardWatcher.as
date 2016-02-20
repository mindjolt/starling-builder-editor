/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util
{
    import starling.core.Starling;
    import starling.display.Stage;
    import starling.events.KeyboardEvent;

    public class KeyboardWatcher
    {
        private var _stage:Stage;
        private var _keyMap:Object;

        public function KeyboardWatcher()
        {
            _keyMap = {};

            _stage = Starling.current.stage;
            _stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            _stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }

        private function onKeyDown(event:KeyboardEvent):void
        {
            _keyMap[event.keyCode] = true;
            //trace("down:", event.keyCode);
        }

        private function onKeyUp(event:KeyboardEvent):void
        {
            delete _keyMap[event.keyCode];
            //trace("up:", event.keyCode);
        }

        public function hasKeyPressed(keyCode:int):Boolean
        {
            return _keyMap[keyCode];
        }
    }
}
