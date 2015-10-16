/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.helper
{
    import com.sgn.starlingbuilder.editor.controller.DocumentManager;

    import flash.ui.Keyboard;

    import starling.core.Starling;
    import starling.display.Stage;
    import starling.events.KeyboardEvent;

    public class KeyboardHelper
    {
        public function KeyboardHelper()
        {
        }

        public static function startKeyboard(documentManager:DocumentManager):void
        {
            var stage:Stage = Starling.current.stage;

            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);

            function onKeyUp(event:KeyboardEvent):void
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
        }




    }
}
