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

    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.controls.TextInput;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;
    import feathers.layout.VerticalLayout;

    import starling.events.Event;
    import com.sgn.starlingbuilder.editor.utils.AssetManager;

    public class TexturePropertyPopup extends AbstractPropertyPopup
    {
        protected var _searchTextInput:TextInput;
        protected var _list:List;

        protected var _assetManager:AssetManager;

        public function TexturePropertyPopup(owner:Object, target:Object, targetParam:Object, onComplete:Function)
        {
            super(owner, target, targetParam, onComplete);

            _assetManager = UIEditorApp.instance.assetManager;

            title = "Select texture";
            buttons = ["OK", "Cancel"];

            addEventListener(Event.COMPLETE, onDialogComplete);
        }

        override protected function createContent(container:LayoutGroup):void
        {
            container.layout = new VerticalLayout();

            _searchTextInput = new TextInput();
            _searchTextInput.prompt = "Search...";
            _searchTextInput.addEventListener(Event.CHANGE, onSearch);

            addChild(_searchTextInput);

            _list = new List();
            _list.width = 200;
            _list.height = 400;
            _list.selectedIndex = -1;
            _list.itemRendererFactory = function():IListItemRenderer
            {
                return new IconItemRenderer();
            }

            addChild(_list);

            refreshAssets();
        }

        private function onSearch(event:Event):void
        {
            refreshAssets();
        }

        private function filterList(text:String, array:Vector.<String>):Vector.<String>
        {
            if (text.length)
            {
                var result:Vector.<String> = new Vector.<String>();

                for each (var s:String in array)
                {
                    if (s.indexOf(text) != -1)
                    {
                        result.push(s);
                    }
                }

                return result;
            }
            else
            {
                return array;
            }
        }

        private function refreshAssets():void
        {
            var data:ListCollection = new ListCollection();

            var array:Vector.<String> = filterList(_searchTextInput.text, AssetTab.assetList);

            for each (var name:String in array)
            {
                data.push({label:name});
            }

            _list.dataProvider = data;
        }

        protected function onDialogComplete(event:Event):void
        {
            var index:int = int(event.data);

            if (index == 0)
            {
                if (_list.selectedIndex >= 0)
                {
                    var textureName:String = _list.selectedItem.label;

                    _target = _assetManager.getTexture(textureName);

                    setCustomParam(textureName);
                }
                else
                {
                    _target = null;
                }

                _onComplete(_target);
            }
            else
            {
                _owner[_targetParam.name] = _oldTarget;
                _onComplete = null;
            }
        }

        protected function setCustomParam(textureName:String):void
        {
            /*
            TODO:
            this is a temparary solution to store a custom value since Texture doesn't contain it.
            This problem will be resolved when we use an intermediate format for the inspector in future version
             */

            var param:Object = _documentManager.extraParamsDict[_owner];

            if (param.params == undefined)
            {
                param.params = {};
            }

            param.params[_targetParam.name] =
            {
                cls:"starling.textures.Texture",
                textureName: textureName
            };
        }




    }
}
