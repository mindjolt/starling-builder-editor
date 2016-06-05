/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.controls.TextInput;
    import feathers.data.ListCollection;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import flash.filesystem.File;

    import starling.events.Event;

    import starlingbuilder.editor.UIEditorScreen;
    import starlingbuilder.editor.helper.FileListingHelper;
    import starlingbuilder.util.feathers.FeathersUIUtil;

    public class FilesTab extends LayoutGroup
    {
        private var _list:List;

        private var _searchTextInput:TextInput;
        private var _refreshButton:Button;

        public function FilesTab()
        {
            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.top = 25;
            anchorLayoutData.bottom = 0;
            this.layoutData = anchorLayoutData;

            layout = new AnchorLayout();


            createTopContainer();

            listAssets();

            addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
        }

        private function createTopContainer():void
        {
            var topContainer:LayoutGroup = FeathersUIUtil.layoutGroupWithHorizontalLayout();

            _searchTextInput = new TextInput();
            _searchTextInput.prompt = "Search...";
            _searchTextInput.addEventListener(Event.CHANGE, onSearch);

            _refreshButton = FeathersUIUtil.buttonWithLabel("refresh", updateData);

            topContainer.addChild(_searchTextInput);
            topContainer.addChild(_refreshButton);

            addChild(topContainer);
        }

        private function onSearch(event:Event):void
        {
            updateData();
        }

        private function onListChange(event:Event):void
        {
            if (_list.selectedIndex != -1)
            {
                var layoutPath:String = UIEditorScreen.instance.workspaceSetting.layoutPath;
                var file:File = UIEditorScreen.instance.workspaceDir.resolvePath(layoutPath + "/" + _list.selectedItem.label);
                UIEditorScreen.instance.toolbar.documentSerializer.openWithFile(file);

                //_list.selectedIndex = -1;
            }
        }

        private function listAssets():void
        {
            _list = new List();
            //_list.isFocusEnabled = false;
            _list.itemRendererProperties.height = 50;

            _list.width = 330;
            _list.height = 800;
            _list.selectedIndex = -1;

            _list.addEventListener(Event.CHANGE, onListChange);

            var anchorLayoutData:AnchorLayoutData = new AnchorLayoutData();
            anchorLayoutData.top = 0;
            anchorLayoutData.bottom = 0;
            anchorLayoutData.topAnchorDisplayObject = _searchTextInput;
            _list.layoutData = anchorLayoutData;

            addChild(_list);
        }

        private function onAddToStage(event:Event):void
        {
            updateData();
        }

        private function updateData():void
        {
            var files:Array;

            var layoutPath:String = UIEditorScreen.instance.workspaceSetting.layoutPath;

            if (layoutPath)
            {
                files = FileListingHelper.getFilesRecursive(UIEditorScreen.instance.workspaceDir.resolvePath(layoutPath));
                files = files.filter(function(value:String, index:int, arr:Array):Boolean{
                    return _searchTextInput.text == "" || value.indexOf(_searchTextInput.text) != -1;
                });
                _list.isEnabled = true;
            }
            else
            {
                files = ["Layout path not found.\nOpen Workspace Setting to edit."];
                _list.isEnabled = false;
            }

            var data:ListCollection = new ListCollection();

            for each (var name:String in files)
            {
                data.push({label:name});
            }

            _list.dataProvider = data;
        }
    }
}
