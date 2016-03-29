/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.helper
{
    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.data.TemplateData;
    import starlingbuilder.engine.util.ParamUtil;

    import feathers.core.PopUpManager;
    import feathers.textures.Scale3Textures;
    import feathers.textures.Scale9Textures;

    import starling.display.DisplayObject;
    import starling.textures.Texture;

    public class UIComponentHelper
    {
        public function UIComponentHelper()
        {
        }

        public static function createComponent(editorData:Object):void
        {
            var data:Object = createComponentData(editorData);

            var cls:Class = ParamUtil.getCreateComponentClass(TemplateData.editor_template, data.cls);
            if (cls)
            {
                var popup:DisplayObject = new cls(data, onCreateComponentComplete);
                PopUpManager.addPopUp(popup);
            }
            else
            {
                UIEditorApp.instance.documentManager.createFromData(data);
            }
        }

        private static function onCreateComponentComplete(data:Object):void
        {
            UIEditorApp.instance.documentManager.createFromData(data);
        }

        private static function createComponentData(editorData:Object):Object
        {
            var data:Object = {cls:editorData.cls, params:{}, customParams:{}};

            var constructorParams:Array = ParamUtil.getConstructorParams(TemplateData.editor_template, editorData.cls);

            data.params.name = editorData.name;

            setDefaultPosition(data.params, editorData);

            setTextureName(constructorParams, editorData.textureName);

            setScaleRatio(constructorParams, editorData.scaleData);

            setFontParams(data.params, editorData.fontName, editorData.text);

            if (constructorParams && constructorParams.length)
                data.constructorParams = constructorParams;

            return data;
        }

        private static function setTextureName(constructorParams:Array, textureName:String):void
        {
            if (!textureName) return;

            for each (var param:Object in constructorParams)
            {
                if (ParamUtil.getClassNames([Texture, Scale3Textures, Scale9Textures]).indexOf(param.cls) != -1)
                {
                    param.textureName = textureName;
                }
            }
        }

        private static function setScaleRatio(constructorParams:Array, scaleRatio:Object):void
        {
            if (!scaleRatio) return;

            for each (var param:Object in constructorParams)
            {
                if (ParamUtil.getClassNames([Scale3Textures, Scale9Textures]).indexOf(param.cls) != -1)
                {
                    param.scaleRatio = scaleRatio;
                }
            }
        }

        private static function setFontParams(params:Object, fontName:String, text:String):void
        {
            if (fontName) params.fontName = fontName;
            if (text) params.text = text;
        }

        private static function setDefaultPosition(params:Object, editorData:Object):void
        {
            if ("x" in editorData)
                params.x = editorData.x;

            if ("y" in editorData)
                params.y = editorData.y;
        }
    }
}
