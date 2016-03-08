/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import starlingbuilder.engine.IAssetMediator;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    import starling.textures.Texture;
    import starling.utils.AssetManager;

    public class AssetMediator implements IAssetMediator
    {
        private var _assetManager:AssetManager;

        private var _file:File;

        public function AssetMediator(assetManager:AssetManager)
        {
            _assetManager = assetManager;
        }

        public function getTexture(name:String):Texture
        {
            return _assetManager.getTexture(name);
        }

        public function getTextures(prefix:String="", result:Vector.<Texture>=null):Vector.<Texture>
        {
            return _assetManager.getTextures(prefix, result);
        }

        public function getExternalData(name:String):Object
        {
            if (_file == null)
            {
                throw new Error("Current Directory not found!")
            }

            for each (var file:File in _file.parent.getDirectoryListing())
            {
                if (FileListingHelper.stripPostfix(file.name) == name)
                {
                    var fs:FileStream = new FileStream();
                    fs.open(file, FileMode.READ);
                    var data:Object = fs.readUTFBytes(fs.bytesAvailable);
                    fs.close();

                    return data;
                }
            }

            return null;
        }

        public function get file():File
        {
            return _file;
        }

        public function set file(value:File):void
        {
            _file = value;
        }
    }
}
