/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.history
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    public class OpenRecentManager
    {
        public static const MAX_RECORD:int = 20;

        public static const PATH:String = "settings/recent_open.json";

        private var _workspace:File;

        private var _recentFiles:Array = [];

        public function OpenRecentManager(workspace:File)
        {
            _workspace = workspace;
            load();
        }

        public function open(url:String):void
        {
            var index:int = _recentFiles.indexOf(url);

            if (index != -1)
            {
                _recentFiles.splice(index, 1);
            }

            _recentFiles.unshift(url);

            if (_recentFiles.length > MAX_RECORD)
                _recentFiles.pop();

            save();
        }

        public function reset():void
        {
            _recentFiles = [];

            save();
        }

        public function get recentFiles():Array
        {
            return _recentFiles;
        }

        protected function load():void
        {
            if (!_workspace) return;

            var file:File = _workspace.resolvePath(PATH);
            var fs:FileStream = new FileStream();

            if (file.exists)
            {
                try
                {
                    fs.open(file, FileMode.READ);
                    _recentFiles = JSON.parse(fs.readUTFBytes(fs.bytesAvailable)) as Array;
                }
                catch (e:Error) {}
            }
        }

        protected function save():void
        {
            if (!_workspace) return;

            var file:File = _workspace.resolvePath(PATH);
            var fs:FileStream = new FileStream();
            fs.open(file, FileMode.WRITE);
            fs.writeUTFBytes(JSON.stringify(_recentFiles));
        }

    }
}
