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
    import com.sgn.starlingbuilder.editor.data.TemplateData;
    import com.sgn.starlingbuilder.editor.helper.UIComponentHelper;
    import com.sgn.starlingbuilder.engine.util.ParamUtil;

    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.data.ListCollection;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import starling.events.Event;
    import com.sgn.starlingbuilder.editor.utils.AssetManager;

    public class ContainerTab extends LayoutGroup
    {
        private var _assetManager:AssetManager;

        private var _list:List;

        protected var _supportedTypes:Array;

        public function ContainerTab()
        {
            _assetManager = UIEditorApp.instance.assetManager;

            createPickerList();


            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.top = 25;
            anchorLayoutData.bottom = 0;
            this.layoutData = anchorLayoutData;

            layout = new AnchorLayout();

            listAssets();
        }

        protected function createPickerList():void
        {
            _supportedTypes = TemplateData.getSupportedComponent("container");
        }

        private function onListChange(event:Event):void
        {
            if (_list.selectedIndex != -1)
            {
                var cls:String = _list.selectedItem.label;
                var name:String = ParamUtil.getDisplayObjectName(cls);

                var editorData:Object = {cls:cls, name:name};

                UIComponentHelper.createComponent(editorData);

                _list.selectedIndex = -1;
            }
        }

        private function listAssets():void
        {
            _list = new List();

            _list.width = 280;
            _list.height = 800;
            _list.selectedIndex = -1;

            var data:ListCollection = new ListCollection();

            for each (var name:String in _supportedTypes)
            {
                data.push({label:name});
            }

            _list.dataProvider = data;

            _list.addEventListener(Event.CHANGE, onListChange);

            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.top = 0;
            anchorLayoutData.bottom = 0;
            _list.layoutData = anchorLayoutData;

            addChild(_list);
        }
    }
}
