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
    import com.sgn.starlingbuilder.editor.controller.DocumentManager;
    import com.sgn.starlingbuilder.editor.data.TemplateData;
    import com.sgn.starlingbuilder.editor.events.DocumentEventType;
    import com.sgn.starlingbuilder.engine.localization.ILocalization;
    import com.sgn.starlingbuilder.engine.util.ParamUtil;
    import com.sgn.tools.util.ui.inspector.PropertyPanel;
    import com.sgn.tools.util.ui.inspector.UIMapperEventType;

    import feathers.controls.LayoutGroup;
    import feathers.layout.VerticalLayout;

    import starling.events.Event;
    import starling.utils.AssetManager;

    public class CustomParamsTab extends LayoutGroup
    {
        public static const LOCALIZE_KEYS:String = "customParams.localizeKey";

        private var _propertiesPanel:PropertyPanel;

        private var _documentManager:DocumentManager;

        private var _assetManger:AssetManager;

        private var _params:Array;

        public function CustomParamsTab()
        {
            _assetManger = UIEditorApp.instance.assetManager;

            _params = ParamUtil.getCustomParams(TemplateData.editor_template);

            _documentManager = UIEditorApp.instance.documentManager;
            _documentManager.addEventListener(DocumentEventType.CHANGE, onChange);

            width = 320;

            var layout:VerticalLayout = new VerticalLayout();
            layout.paddingTop = layout.gap = 20;
            this.layout = layout;

            initUI();
        }

        private function initUI():void
        {
            PropertyPanel.globalDispatcher.addEventListener(UIMapperEventType.PROPERTY_CHANGE, onPropertyChange);

            _propertiesPanel = new PropertyPanel({}, []);

            addChild(_propertiesPanel);
        }

        private function onChange(event:Event):void
        {
            if (_documentManager.selectedObject)
            {
                var target:Object = _documentManager.extraParamsDict[_documentManager.selectedObject];

                processParams(_params);

                _propertiesPanel.reloadData(target, _params);
            }
            else
            {
                _propertiesPanel.reloadData();
            }
        }

        private function processParams(params:Array):void
        {
            var localization:ILocalization = UIEditorApp.instance.localizationManager.localization;

            for each (var item:Object in params)
            {
                if (item.name == LOCALIZE_KEYS && localization)
                {
                    delete item.options;
                    item.options = localization.getKeys();
                }
            }
        }

        private function onPropertyChange(event:Event):void
        {
            if (event.data.propertyName == LOCALIZE_KEYS)
            {
                _documentManager.uiBuilder.localizeTexts(_documentManager.root, _documentManager.extraParamsDict);
            }
        }

        override public function dispose():void
        {
            PropertyPanel.globalDispatcher.removeEventListener(UIMapperEventType.PROPERTY_CHANGE, onPropertyChange);

            super.dispose();
        }
    }
}
