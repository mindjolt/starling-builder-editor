/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.ui
{
    import com.sgn.starlingbuilder.editor.UIEditorApp;
    import com.sgn.starlingbuilder.editor.UIEditorScreen;
    import com.sgn.starlingbuilder.editor.controller.DocumentManager;
    import com.sgn.starlingbuilder.editor.data.TemplateData;
    import com.sgn.starlingbuilder.editor.events.DocumentEventType;
    import com.sgn.starlingbuilder.editor.history.ResetOperation;
    import com.sgn.starlingbuilder.editor.themes.UIEditorStyleProvider;
    import com.sgn.starlingbuilder.engine.util.ParamUtil;
    import com.sgn.tools.util.ui.inspector.DefaultPropertyRetriever;
    import com.sgn.tools.util.ui.inspector.IPropertyRetriever;
    import com.sgn.tools.util.ui.inspector.PropertyComponentType;
    import com.sgn.tools.util.ui.inspector.PropertyPanel;
    import com.sgn.tools.util.ui.inspector.WidthAndHeightPropertyRetriever;

    import feathers.controls.Button;
    import feathers.controls.ButtonGroup;
    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;
    import feathers.core.FeathersControl;
    import feathers.data.ListCollection;
    import feathers.layout.VerticalLayout;

    import flash.utils.Dictionary;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.events.Event;
    import starling.utils.AssetManager;

    public class PropertyTab extends LayoutGroup
    {
        private var _propertiesPanel:PropertyPanel;

        private var _template:Object;

        private var _documentManager:DocumentManager;

        private var _assetManager:AssetManager;

        private var _pivotTool:PivotTool;
        private var _movieClipTool:MovieClipTool;

        private var _paramCache:Dictionary;

        public function PropertyTab()
        {
            _paramCache = new Dictionary();

            _assetManager = UIEditorApp.instance.assetManager;

            _documentManager = UIEditorApp.instance.documentManager;
            _documentManager.addEventListener(DocumentEventType.CHANGE, onChange);

            width = 320;

            var layout:VerticalLayout = new VerticalLayout();
            layout.paddingTop = layout.gap = 20;
            this.layout = layout;

            _template = TemplateData.editor_template;

            initUI();

        }

        private function initUI():void
        {
            _propertiesPanel = new PropertyPanel({}, [], displayObjectPropertyFactory);

            addChild(_propertiesPanel);

            var buttonGroup:ButtonGroup = new ButtonGroup();
            buttonGroup.dataProvider = new ListCollection(createButtons());
            addChild(buttonGroup);

            _pivotTool = new PivotTool();
            addChild(_pivotTool);

            _movieClipTool = new MovieClipTool();
            addChild(_movieClipTool);
        }

        private function displayObjectPropertyFactory(target:Object, param:Object):IPropertyRetriever
        {
            if (param.name == "styleName" && target is FeathersControl)
            {
                param.options = getStyleNames(target as FeathersControl);
            }

            if (target is DisplayObject && (param.name == "width" || param.name == "height"))
            {
                return new WidthAndHeightPropertyRetriever(target, param);
            }
            else
            {
                return new DefaultPropertyRetriever(target, param);
            }
        }

        private function createButtons():Array
        {
            return [
                {label:"reset", triggered:onButtonClick},
//                {label:"readjust layout", triggered:onButtonClick},
            ]
        }

        private function onButtonClick(event:Event):void
        {
            var button:Button = event.target as Button;

            switch (button.label)
            {
                case "reset":
                    reset();
                    break;
                case "readjust layout":
                    readjust(_documentManager.container);
                    break;
            }
        }

        private function reset():void
        {
            var obj:DisplayObject = _documentManager.selectedObject;

            if (obj)
            {
                var oldValue:Object = {rotation:obj.rotation, scaleX:obj.scaleX, scaleY:obj.scaleY};

                obj.rotation = 0;
                obj.scaleX = 1;
                obj.scaleY = 1;
                _documentManager.setChanged();

                var newValue:Object = {rotation:obj.rotation, scaleX:obj.scaleX, scaleY:obj.scaleY};
                _documentManager.historyManager.add(new ResetOperation(obj, oldValue, newValue));
            }

        }

        private function getObjectParams(target:Object):Array
        {
            if (target)
            {
                if (!_paramCache[target.constructor])
                {
                    var params:Array = ParamUtil.getParams(_template, _documentManager.selectedObject);

                    processParamsWithFonts(params);
                    processParamsWithWidthAndHeight(params);

                    _paramCache[target.constructor] = params;
                }

                return _paramCache[target.constructor];
            }
            else
            {
                return null;
            }
        }



        private function onChange(event:Event):void
        {
            var params:Array;

            if (UIEditorScreen.instance.leftPanel.currentTab is BackgroundTab)
            {
                if (_documentManager.background)
                {
                    params = _template.background.params;
                    _propertiesPanel.reloadData(_documentManager.background, params);
                }
                else
                {
                    _propertiesPanel.reloadData();
                }
            }
            else
            {
                if (_documentManager.selectedObject)
                {
                    params = getObjectParams(_documentManager.selectedObject);

                    _propertiesPanel.reloadData(_documentManager.selectedObject, params);
                }
                else
                {
                    _propertiesPanel.reloadData();
                }
            }

            _movieClipTool.updateMovieClipTool();
        }

        private function processParamsWithFonts(params:Array):void
        {
            var fonts:Array = UIEditorScreen.instance.getBitmapFontNames();

            for each (var item:Object in params)
            {
                if ((item.component == PropertyComponentType.TEXT_INPUT || item.component == PropertyComponentType.PICKER_LIST) && item.name == "fontName")
                {
                    delete item.options;
                    item.options = fonts;
                }
            }
        }

        private function processParamsWithWidthAndHeight(params:Array):void
        {
            var i:int;

            var array:Array;
            var param:Object;

            for (i = 0; i < params.length; ++i)
            {
                param = params[i];

                if (param.name == "width")
                {
                    array = [param];
                    params.splice(i, 1, array);
                }
            }

            for (i = 0; i < params.length; ++i)
            {
                param = params[i];

                if (param.name == "height")
                {
                    params.splice(i, 1);
                    array.push(param);
                }
            }
        }

        private function readjust(container:DisplayObjectContainer):void
        {
            for (var i:int = 0; i < container.numChildren; ++i)
            {
                var child:DisplayObject = container.getChildAt(i);

                if (child is LayoutGroup)
                {
                    LayoutGroup(child).readjustLayout();
                }
                else if (child is ScrollContainer)
                {
                    ScrollContainer(child).readjustLayout();
                }

                if (child is DisplayObjectContainer)
                {
                    readjust(child as DisplayObjectContainer);
                }
            }
        }

        private function getStyleNames(fc:FeathersControl):Array
        {
            var array:Array = [];

            if (fc.styleProvider is UIEditorStyleProvider)
            {
                var styleNameMap:Object = (fc.styleProvider as UIEditorStyleProvider).styleNameMap;

                for (var name:String in styleNameMap)
                {
                    array.push(name);
                }
            }

            return array;
        }


    }
}
