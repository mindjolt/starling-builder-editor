/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor
{
    import starlingbuilder.util.AppUpdater;
    import starlingbuilder.util.feathers.popup.InfoPopup;

    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.display3D.Context3DProfile;
    import flash.display3D.Context3DRenderMode;
    import flash.events.Event;
    import flash.events.UncaughtErrorEvent;
    import flash.geom.Rectangle;

    import starling.core.Starling;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    [SWF(frameRate=60, width=1320, height=960, backgroundColor="#000")]
    public class Main extends Sprite
    {
        public static var STAGE : Stage;

        private var _viewport:Rectangle;
        private var _starling : Starling;

        private var _appUpdater:AppUpdater;

        public function Main()
        {
            addEventListener(Event.ENTER_FRAME, onEnterFrame);

            _appUpdater = new AppUpdater();

        }

        private function _start(e:Event):void
        {
            _starling.start();
        }

        private function onEnterFrame(event:Event):void
        {
            removeEventListener(Event.ENTER_FRAME, onEnterFrame);
            init();
        }

        private function init():void
        {
            STAGE = stage;

            _viewport = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

            Starling.handleLostContext = true;

            _starling = new Starling(UIEditorApp, stage, _viewport, null, Context3DRenderMode.AUTO, Context3DProfile.BASELINE);

            _starling.simulateMultitouch  = false;
            _starling.enableErrorChecking = false;
            _starling.showStatsAt(HAlign.RIGHT, VAlign.TOP);
            _starling.supportHighResolutions = true;

            _starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, _start);

            trace("width : " + Starling.current.viewPort.width + ", height : " + Starling.current.viewPort.height);

            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
        }

        private function onUncaughtError(event:UncaughtErrorEvent):void
        {
            var message:String;

            if (event.error is Error)
            {
                message = Error(event.error).getStackTrace();
            }
            else
            {
                message = event.error.toString();
            }

            trace(message);
            InfoPopup.show(message);
        }
    }
}
