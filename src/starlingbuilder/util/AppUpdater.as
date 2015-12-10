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

    import flash.events.Event;
    import flash.filesystem.File;

    public class AppUpdater
    {
        private var _appUpdater:ApplicationUpdaterUI;

        public function AppUpdater()
        {
            _appUpdater = new ApplicationUpdaterUI();

            _appUpdater.addEventListener("beforeInstall", beforeInstall);
            _appUpdater.addEventListener("checkForUpdate", checkForUpdate);
            _appUpdater.addEventListener("downloadComplete", downloadComplete);
            _appUpdater.addEventListener("downloadError", downloadError);
            _appUpdater.addEventListener("downloadStart", downloadStart);
            _appUpdater.addEventListener("error", error);
            _appUpdater.addEventListener("fileUpdateError", fileUpdateError);
            _appUpdater.addEventListener("fileUpdateStatus", fileUpdateStatus);
            _appUpdater.addEventListener("initialized", initialized);
            _appUpdater.addEventListener("progress", progress);
            _appUpdater.addEventListener("updateError", updateError);
            _appUpdater.addEventListener("updateStatus", updateStatus);
            _appUpdater.configurationFile = new File("app:/updateConfig.xml");
            _appUpdater.initialize();
        }

        private function beforeInstall(event:Event):void
        {
            trace("beforeInstall");
        }

        private function checkForUpdate(event:Event):void
        {
            trace("checkForUpdate");
        }

        private function downloadComplete(event:Event):void
        {
            trace("downloadComplete");
        }

        private function downloadError(event:Event):void
        {
            trace("downloadError");
        }

        private function downloadStart(event:Event):void
        {
            trace("downloadStart");
        }

        private function error(event:Event):void
        {
            trace("error");
        }

        private function fileUpdateError(event:Event):void
        {
            trace("fileUpdateError");
        }

        private function fileUpdateStatus(event:Event):void
        {
            trace("fileUpdateStatus");
        }

        private function initialized(event:Event):void
        {
            trace("initialized");
            (event.target as ApplicationUpdaterUI).checkNow();
        }

        private function progress(event:Event):void
        {
            trace("progress");
        }

        private function updateError(event:Event):void
        {
            trace("updateError");
        }

        private function updateStatus(event:Event):void
        {
            trace("updateStatus");
        }

        public function get appUpdater():ApplicationUpdaterUI
        {
            return _appUpdater;
        }

        public function checkNow():void
        {
            _appUpdater.checkNow();
        }
    }
}
