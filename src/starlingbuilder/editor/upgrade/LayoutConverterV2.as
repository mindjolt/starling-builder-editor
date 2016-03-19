/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.upgrade
{
    import starling.textures.Texture;

    import starlingbuilder.editor.UIEditorApp;

    public class LayoutConverterV2 extends AbstractLayoutConverter
    {
        public static const convertMap:Object = {
            "starling.text.TextField":convertTextField,
            "feathers.display.Scale3Image":convertScale3Image,
            "feathers.display.Scale9Image":convertScale9Image,
            "feathers.display.TiledImage":convertTiledImage,
            "starling.display.Button":convertStarlingButton
        };

        override public function getCurrentVersion():String
        {
            return "2.0";
        }

        override public function getUpgradePolicy(data:Object):String
        {
            var data:Object = JSON.parse(data as String);

            var majorVersion:String = data.version.charAt(0);

            if (majorVersion == "1")
                return LayoutUpgradePolicy.CAN_UPGRADE;
            else if (majorVersion == "2")
                return LayoutUpgradePolicy.NO_UPGRADE;
            else
                return LayoutUpgradePolicy.CANNOT_UPGRADE;
        }

        override protected function process(data:Object):void
        {
            var func:Function = convertMap[data.cls];
            if (func)
            {
                func(data);
            }
        }

        private static function convertTextField(data:Object):void
        {
            data.constructorParams.splice(3, 3);

            var params:Object = data.params;
            if (!("color" in params))
                params.color = 0xffffff;
            params.format = {cls:"starling.text.TextFormat", params:{font:params.fontName, color:params.color, size:params.fontSize, hAlign:params.hAligh, vAlign:params.vAlign}, customParams:{}};

            delete params.fontName;
            delete params.fontSize;
            delete params.color;
            delete params.hAlign;
            delete params.vAlign;
        }

        private static function convertScale3Image(data:Object):void
        {
            var texture:Texture = UIEditorApp.instance.assetManager.getTexture(data.constructorParams[0].textureName);

            var scaleRatio:Array = data.constructorParams[0].scaleRatio;
            delete data.constructorParams[0].scaleRatio;

            data.constructorParams[0].cls = "starling.textures.Texture";

            data.cls = "starling.display.Image";

            if (scaleRatio[2] == "horizontal")
                data.params.scale9Grid = {cls:"flash.geom.Rectangle",
                    params:{x:texture.width * scaleRatio[0], y:texture.height * 0.5, width:texture.width * scaleRatio[1], height:0}, customParams:{}};
            else
                data.params.scale9Grid = {cls:"flash.geom.Rectangle",
                    params:{x:texture.width * 0.5, y:texture.height * scaleRatio[0], width:0, height:texture.height * scaleRatio[1]}, customParams:{}};
        }

        private static function convertScale9Image(data:Object):void
        {
            var texture:Texture = UIEditorApp.instance.assetManager.getTexture(data.constructorParams[0].textureName);

            var scaleRatio:Array = data.constructorParams[0].scaleRatio;
            delete data.constructorParams[0].scaleRatio;

            data.constructorParams[0].cls = "starling.textures.Texture";

            data.cls = "starling.display.Image";
            data.params.scale9Grid = {cls:"flash.geom.Rectangle",
                params:{x:texture.width * scaleRatio[0], y:texture.height * scaleRatio[1], width:texture.width * scaleRatio[2], height:texture.height * scaleRatio[3]}, customParams:{}};
        }

        private static function convertTiledImage(data:Object):void
        {
            data.cls = "starling.display.Image";
            var params:Object = data.params;
            params.tileGrid = {cls:"flash.geom.Rectangle", customParams:{}};
        }

        private static function convertStarlingButton(data:Object):void
        {
            var params:Object = data.params;
            params.textFormat = {cls:"starling.text.TextFormat", params:{font:params.fontName, color:params.fontColor, size:params.fontSize}, customParams:{}};

            delete params.fontName;
            delete params.fontColor;
            delete params.fontSize;
        }
    }
}
