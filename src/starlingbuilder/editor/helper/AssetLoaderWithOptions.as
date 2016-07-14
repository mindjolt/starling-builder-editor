/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    import starling.textures.TextureOptions;
    import starling.utils.AssetManager;

    public class AssetLoaderWithOptions
    {
        public static const DEFAULT_OPTION:String = "default_option";

        private var _assetManager:AssetManager;
        private var _workspace:File;
        private var _options:Object;

        public function AssetLoaderWithOptions(assetManager:AssetManager, workspace:File)
        {
            _assetManager = assetManager;
            _workspace = workspace

            loadOptions();
        }

        private function loadOptions():void
        {
            var file:File = _workspace.resolvePath("settings/texture_options.json");

            if (file.exists)
            {
                var fs:FileStream = new FileStream();
                fs.open(file, FileMode.READ);
                _options = JSON.parse(fs.readUTFBytes(fs.bytesAvailable));
            }
            else
            {
                _options = {};
            }
        }

        public function enqueue(...rawAssets):void
        {
            for each (var rawAsset:Object in rawAssets)
            {
                if (rawAsset is File)
                {
                    var file:File = rawAsset as File;

                    rawAsset = unescape(file.url);

                    if (file.isDirectory)
                    {
                        enqueue.apply(this, file.getDirectoryListing());
                    }
                    else
                    {
                        _assetManager.enqueueWithName(rawAsset, null, getTextureOptions(file.url))
                    }
                }
                else
                {
                    _assetManager.enqueue.apply(this, rawAssets);
                }
            }
        }

        private function getTextureOptions(url:String):TextureOptions
        {
            for (var key:String in _options)
            {
                var re:RegExp = new RegExp(key);

                var res:Array = url.match(re);

                if (res && res.length > 0)
                    return toTextureOptions(_options[key]);
            }

            if (DEFAULT_OPTION in _options)
                return toTextureOptions(_options[DEFAULT_OPTION]);

            return null;
        }

        private static const TEXTURE_OPTIONS_FIELDS:Array = ["scale", "mipMapping", "format", "repeat"];

        private function toTextureOptions(option:Object):TextureOptions
        {
            var textureOptions:TextureOptions = new TextureOptions();

            for each (var field:String in TEXTURE_OPTIONS_FIELDS)
            {
                if (field in option)
                    textureOptions[field] = option[field];
            }

            return textureOptions;
        }
    }
}
