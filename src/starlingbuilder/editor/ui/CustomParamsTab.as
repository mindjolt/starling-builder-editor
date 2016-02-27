/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.controls.ScrollContainer;

    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.controller.DocumentManager;
    import starlingbuilder.editor.data.TemplateData;
    import starlingbuilder.editor.events.DocumentEventType;
    import starlingbuilder.engine.localization.ILocalization;
    import starlingbuilder.engine.util.ParamUtil;
    import starlingbuilder.util.feathers.FeathersUIUtil;
    import starlingbuilder.util.ui.inspector.PropertyPanel;
    import starlingbuilder.util.ui.inspector.UIMapperEventType;

    import feathers.controls.LayoutGroup;
    import feathers.layout.VerticalLayout;

    import starling.events.Event;
    import starling.utils.AssetManager;

    public class CustomParamsTab extends ScrollContainer
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
            processParams(_params);

            _documentManager = UIEditorApp.instance.documentManager;
            _documentManager.addEventListener(DocumentEventType.CHANGE, onChange);

            width = 350;

            var layout:VerticalLayout = new VerticalLayout();
            layout.paddingTop = layout.gap = 20;
            this.layout = layout;

            layoutData = FeathersUIUtil.anchorLayoutData(60, 0);

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
