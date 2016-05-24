/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util
{
    import air.update.ApplicationUpdaterUI;
    import air.update.events.StatusUpdateEvent;

    import flash.events.ErrorEvent;

    import flash.events.Event;

    import starlingbuilder.util.feathers.popup.InfoPopup;

    public class AppUpdater
    {
        //Set the location of your update descriptor file here
        public static const UPDATE_URL:String = "http://starlingbuilder.github.io/download/2.x/updateConfig.xml";

        private var _appUpdater:ApplicationUpdaterUI;

        private var _showPopup:Boolean = false;

        public function AppUpdater(url:String = null)
        {
            _appUpdater = new ApplicationUpdaterUI();
            _appUpdater.addEventListener(ErrorEvent.ERROR, onError);
            _appUpdater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, onUpdateStatus);

            _appUpdater.updateURL = url ? url : UPDATE_URL;
            _appUpdater.delay = 1;
            _appUpdater.isCheckForUpdateVisible = false;
            _appUpdater.isDownloadUpdateVisible = true;
            _appUpdater.isDownloadProgressVisible = true;
            _appUpdater.isInstallUpdateVisible = true;

            _appUpdater.initialize();
        }

        private function onUpdateStatus(event:StatusUpdateEvent):void
        {
            if (!event.available && _showPopup)
                InfoPopup.show("Already up to date", ["OK"]);

            _showPopup = false;
        }

        private function onError(event:Event):void
        {
            trace(event.toString());
        }

        public function checkNow():void
        {
            _showPopup = true;
            _appUpdater.checkNow();
        }
    }
}
