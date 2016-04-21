/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
import flash.ui.Keyboard;

import starling.core.Starling;
import starling.display.Stage;
import starling.events.KeyboardEvent;

import starlingbuilder.editor.controller.DocumentManager;

public class KeyboardHelper
    {
        public function KeyboardHelper()
        {
        }

        public static function startKeyboard(documentManager:DocumentManager):void
        {
            var stage:Stage = Starling.current.stage;

            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

            function onKeyDown(event:KeyboardEvent):void
            {
                switch (event.keyCode)
                {
                    case Keyboard.UP:
                        if (documentManager.hasFocus) documentManager.move(0, -1, true);
                        break;
                    case Keyboard.DOWN:
                        if (documentManager.hasFocus) documentManager.move(0, 1, true);
                        break;
                    case Keyboard.LEFT:
                        if (documentManager.hasFocus) documentManager.move(-1, 0, true);
                        break;
                    case Keyboard.RIGHT:
                        if (documentManager.hasFocus) documentManager.move(1, 0, true);
                        break;
                }
            }

            function onKeyUp(event:KeyboardEvent):void
            {
                if (documentManager.hasFocus) documentManager.historyManager.change();;
            }
        }




    }
}
