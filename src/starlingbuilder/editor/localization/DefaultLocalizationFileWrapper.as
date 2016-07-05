/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.localization
{
    import starlingbuilder.engine.localization.DefaultLocalization;
    import starlingbuilder.engine.localization.ILocalization;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    public class DefaultLocalizationFileWrapper implements ILocalizationFileWrapper
    {
        private var _workspace:File;

        private var _localization:ILocalization;

        public function DefaultLocalizationFileWrapper(workspace:File)
        {
            _workspace = workspace;


            var template:File = _workspace.resolvePath("strings.json");

            if (template.exists)
            {
                var fs:FileStream = new FileStream();
                fs.open(template, FileMode.READ);
                var data:Object = JSON.parse(fs.readUTFBytes(fs.bytesAvailable));
                fs.close();

                _localization = new DefaultLocalization(data);
            }
        }

        public function get localization():ILocalization
        {
            return _localization;
        }

    }
}
