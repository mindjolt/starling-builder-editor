/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.data
{
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    import starlingbuilder.engine.format.StableJSONEncoder;
    import starlingbuilder.util.ObjectUtil;

    import starlingbuilder.util.feathers.popup.InfoPopup;

    public class TemplateData
    {
        public function TemplateData()
        {
        }

        public static const ALWAYS_OVERRIDE:Boolean = false;

        public static var editor_template:Object;

        private static var original_template:Object;

        private static var external_template:Object;

        public static var shouldOverride:Boolean;

        public static function load(customTemplate:Object = null, workspace:File = null):void
        {
            if (!editor_template)
            {
                original_template = JSON.parse(new EmbeddedData.editor_template());
                editor_template = ObjectUtil.cloneObject(original_template);

                loadExternalTemplate(workspace);

                //if file not exist or revision property not exists or external template older than the default template or version mismatch, then overwrite it
                //otherwise use the external template
                shouldOverride = ALWAYS_OVERRIDE || !external_template || !external_template.hasOwnProperty('revision') || !original_template.hasOwnProperty('revision') || external_template.revision < original_template.revision
                || external_template.version != original_template.version;

                if (!shouldOverride)
                {
                    editor_template = ObjectUtil.cloneObject(external_template);
                }
            }

            mergeCustomTemplate(customTemplate);
        }

        public static function getSupportedComponent(tag:String = null):Array
        {
            var array:Array = [];

            for each (var item:Object in editor_template.supported_components)
            {
                if (tag == null || item.tag == tag)
                {
                    array.push(item.cls);
                }
            }

            return array;
        }

        public static function loadExternalTemplate(workspace:File):void
        {
            if (workspace == null) return;

            var dir:File = workspace.resolvePath("settings");

            if (!dir.exists)
                dir.createDirectory();

            if (!external_template)
            {
                var file:File = dir.resolvePath("editor_template.json");
                if (file.exists)
                {
                    try
                    {
                        var fs2:FileStream = new FileStream();
                        fs2.open(file, FileMode.READ);
                        var data:String = fs2.readUTFBytes(fs2.bytesAvailable);
                        fs2.close();
                        external_template = JSON.parse(data);
                    }
                    catch (e:Error)
                    {
                        InfoPopup.show("Invalid editor_template.json. Default template loaded.");
                        return;
                    }
                }
            }
        }

        private static function concatCustomComponents(origin:Object, from:Object):void
        {
            var supportedComponents:Array = origin.supported_components;
            var customComponents:Array = from.custom_components;

            for each (var component:Object in customComponents)
            {
                if (supportedComponents.indexOf(component) == -1)
                    supportedComponents.push(component);
            }
        }

        private static function mergeCustomTemplate(customTemplate:Object):void
        {
            if (customTemplate && shouldOverride)
            {
                handleLegacyField(customTemplate);
                applyOverlay(editor_template, customTemplate);
            }
        }

        /**
         * Apply an overlay to a base value
         *
         * Loop through every key/value pair of the overlay object:
         * If both the base and overlay property is an Array, then concat overlay array with base array
         * If both the base and overlay property is an Object, then call mergeObject to the property recursively
         * Otherwise the base property will set to the overlay property
         *
         * @param base base value
         * @param overlay overlay value
         */
        private static function applyOverlay(base:Object, overlay:Object):void
        {
            for (var id:String in overlay)
            {
                var overlayValue:Object = overlay[id];

                if (id in base)
                {
                    var baseValue:Object = base[id];

                    if (baseValue is Array && overlayValue is Array)
                    {
                        base[id] = baseValue.concat(overlayValue);
                    }
                    else if (ObjectUtil.isObject(baseValue) && ObjectUtil.isObject(overlayValue))
                    {
                        applyOverlay(baseValue, overlayValue);
                    }
                    else
                    {
                        base[id] = overlayValue;
                    }
                }
                else
                {
                    base[id] = overlayValue;
                }
            }
        }

        public static function saveExternalTemplate(workspace:File):void
        {
            if (shouldOverride)
            {
                var file:File = workspace.resolvePath("settings/editor_template.json");

                var fs:FileStream = new FileStream();
                fs.open(file, FileMode.WRITE);
                fs.writeUTFBytes(StableJSONEncoder.stringify(editor_template));
                fs.close();
            }
        }

        private static function handleLegacyField(customTemplate):void
        {
            if ("custom_components" in customTemplate)
            {
                customTemplate.supported_components = customTemplate.custom_components;
                delete customTemplate.custom_components;
            }
        }
    }
}
