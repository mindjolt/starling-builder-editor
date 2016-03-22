/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.data.TemplateData;
    import starlingbuilder.editor.helper.FontHelper;
    import starlingbuilder.editor.helper.UIComponentHelper;

    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.controls.PickerList;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import starling.events.Event;
    import starling.utils.AssetManager;

    public class TextTab extends LayoutGroup
    {
        public static const DEFAULT_TEXT:String = "Abc123";
        public static const DEFAULT_SIZE:int = 46;
        public static const DEFAULT_COLOR:uint = 0xffffff;

        private var _assetManager:AssetManager;

        private var _list:List;

        private var _typePicker:PickerList;

        private var _supportedTypes:Array;

        public function TextTab()
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

        private function createPickerList():void
        {
            _typePicker = new PickerList();

            _supportedTypes = TemplateData.getSupportedComponent("text");

            _typePicker.dataProvider = new ListCollection(_supportedTypes);
            _typePicker.selectedIndex = 0;

            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.bottom = 0;
            _typePicker.layoutData = anchorLayoutData;

            addChild(_typePicker);
        }

        private function onListChange(event:Event):void
        {
            if (_list.selectedIndex != -1)
            {
                var cls:String = _supportedTypes[_typePicker.selectedIndex];
                var name:String = _list.selectedItem.label;

                var editorData:Object = {cls:cls, font:name, name:name, text:DEFAULT_TEXT, size:DEFAULT_SIZE, color:DEFAULT_COLOR};

                UIComponentHelper.createComponent(editorData);

                _list.selectedIndex = -1;
            }
        }

        private function listAssets():void
        {
            _list = new List();
            _list.itemRendererFactory = function():IListItemRenderer
            {
                return new TextItemRenderer();
            }

            _list.width = 280;
            _list.height = 800;
            _list.selectedIndex = -1;

            var fonts:Array = FontHelper.getBitmapFontNames();

            var data:ListCollection = new ListCollection();

            for each (var name:String in fonts)
            {
                data.push({label:name});
            }

            _list.dataProvider = data;

            _list.addEventListener(Event.CHANGE, onListChange);

            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.top = 0;
            anchorLayoutData.bottom = 0;
            anchorLayoutData.bottomAnchorDisplayObject = _typePicker;
            _list.layoutData = anchorLayoutData;

            addChild(_list);
        }





    }
}
