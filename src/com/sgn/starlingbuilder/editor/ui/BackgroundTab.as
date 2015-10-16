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
    import com.sgn.starlingbuilder.editor.helper.FileListingHelper;
    import com.sgn.tools.util.feathers.FeathersUIUtil;

    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import starling.display.Image;
    import starling.events.Event;
    import starling.utils.AssetManager;

    public class BackgroundTab extends LayoutGroup
    {
        private var _assetManager:AssetManager;
        private var _documentManager:DocumentManager;

        private var _list:List;

        private var _resetButton:Button;

        public function BackgroundTab()
        {
            _assetManager = UIEditorApp.instance.assetManager;
            _documentManager = UIEditorApp.instance.documentManager;

            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.top = 25;
            anchorLayoutData.bottom = 0;
            this.layoutData = anchorLayoutData;

            layout = new AnchorLayout();

            createResetButton();

            listAssets();
        }

        override protected function feathersControl_addedToStageHandler(event:Event):void
        {
            super.feathersControl_addedToStageHandler(event);

            UIEditorApp.instance.documentManager.setChanged();
        }

        private function onListChange(event:Event):void
        {
            if (_list.selectedIndex != -1)
            {
                createComponent(_list.selectedItem.label);
                _list.selectedIndex = -1;
            }
        }

        private function createResetButton():void
        {
            _resetButton = FeathersUIUtil.buttonWithLabel("reset background", function(event:Event):void{
                _documentManager.background = null;
                _documentManager.setChanged();
            });

            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.bottom = 0;
            _resetButton.layoutData = anchorLayoutData;

            addChild(_resetButton);
        }

        private function listAssets():void
        {
            _list = new List();
            _list.width = 280;
            _list.height = 800;
            _list.selectedIndex = -1;
            _list.itemRendererFactory = function():IListItemRenderer
            {
                return new IconItemRenderer();
            }

            var array:Array = FileListingHelper.getFileList(UIEditorScreen.instance.workspaceDir, "backgrounds", ["png", "jpg", "atf"]);

            var data:ListCollection = new ListCollection();

            for each (var name:String in array)
            {
                data.push({label:name});
            }

            _list.dataProvider = data;

            _list.addEventListener(Event.CHANGE, onListChange);

            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.top = 0;
            anchorLayoutData.bottom = 0;
            anchorLayoutData.bottomAnchorDisplayObject = _resetButton;
            _list.layoutData = anchorLayoutData;

            addChild(_list);



        }

        private function createComponent(name:String):void
        {
            var image:Image = new Image(_assetManager.getTexture(name));
            image.name = name;
            _documentManager.background = image;
            _documentManager.setChanged();
        }
    }
}
