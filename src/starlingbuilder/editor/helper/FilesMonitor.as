/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import flash.events.TimerEvent;
    import flash.filesystem.File;
    import flash.utils.Timer;
    import flash.utils.getTimer;

    import starling.events.Event;

    import starling.events.EventDispatcher;

    import starlingbuilder.editor.WorkspaceSetting;

    public class FilesMonitor extends EventDispatcher
    {
        private var _setting:WorkspaceSetting;
        private var _workspaceDir:File;

        private var _files:Object;
        private var _dirs:Object;
        private var _timer:Timer;

        private var _changedFiles:Array;
        private var _init:Boolean;

        public function FilesMonitor(setting:WorkspaceSetting, workspaceDir:File)
        {
            _setting = setting;
            _workspaceDir = workspaceDir;

            _files = {};
            _dirs = {};
            _timer = new Timer(2000);
            _timer.addEventListener(TimerEvent.TIMER, onTimer);
            _timer.start();

            _init = true;
            trackAssets();
            _init = false;
        }

        public function trackAssets():void
        {
            //var start:int = getTimer();

            var paths:Array = _setting.getAssetPaths();

            _changedFiles = [];

            for each (var path:String in paths)
            {
                trackFiles(_workspaceDir.resolvePath(path));
            }

            //We need to keep track of all the directories because when a sub directory changed it won't affect the modificationDate of the parent folder
            for (var dir:String in _dirs)
            {
                trackFiles(new File(dir));
            }

            //trace("track assets time: ", getTimer() - start);
        }

        private function onTimer(event:TimerEvent):void
        {
            trackAssets();
            if (_changedFiles.length)
                dispatchEventWith(Event.CHANGE, 0, {files:_changedFiles});
        }

        private function trackFiles(...files):void
        {
            for each (var file:File in files)
            {
                if (!file.exists) continue;

                var url:String = file.url;
                var ts:Number = file.modificationDate.getTime();
                var oldTs:Number = _files[url];
                if (file.isDirectory) _dirs[url] = ts;
                _files[url] = ts;
                var changed:Boolean = (oldTs != ts);

                if (file.isDirectory)
                {
                    if (changed)
                        trackFiles.apply(this, file.getDirectoryListing());
                }
                else
                {
                    if (!_init && changed)
                        _changedFiles.push(file);
                }
            }
        }

        public function start():void
        {
            _timer.start();
        }

        public function stop():void
        {
            _timer.stop();
        }
    }
}
