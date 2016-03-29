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

            setFontParams(data, editorData);

            if (constructorParams && constructorParams.length)
                data.constructorParams = constructorParams;

            return data;
        }

        private static function setTextureName(constructorParams:Array, textureName:String):void
        {
            if (!textureName) return;

            for each (var param:Object in constructorParams)
            {
                if (ParamUtil.getClassNames([Texture]).indexOf(param.cls) != -1)
                {
                    param.textureName = textureName;
                }
            }
        }

        public static const TEXT_FORMAT_FIELDS:Array = ["font", "size", "color"];

        private static function setFontParams(data:Object, editorData:Object):void
        {
            if (data.cls == "starling.text.TextField")
            {
                data.params.format = {cls:"starling.text.TextFormat", params:{}, customParams:{}};

                for each (var field:String in TEXT_FORMAT_FIELDS)
                    if (field in editorData)
                        data.params.format.params[field] = editorData[field];
            }

            if ("text" in editorData)
            {
                data.params.text = editorData.text;
            }
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
