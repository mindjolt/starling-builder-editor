/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.controls.LayoutGroup;
    import feathers.controls.PickerList;
    import feathers.core.PopUpManager;
    import feathers.data.ListCollection;

    import flash.geom.Rectangle;

    import starling.display.Image;
    import starling.events.Event;

    public class DisplayObjectPropertyPopup extends TexturePropertyPopup
    {
        private static const NONE:String         = "none";
        private static const SCALE_9_GRID:String = "scale9Grid";
        private static const TILE_GRID:String    = "tileGrid";

        public static const SUPPORTED_TYPES:Array = [NONE, SCALE_9_GRID, TILE_GRID];

        private var _typePicker:PickerList;

        public function DisplayObjectPropertyPopup(owner:Object, target:Object, targetParam:Object, customParam:Object, onComplete:Function)
        {
            super(owner, target, targetParam, customParam, onComplete);
        }

        override protected function createContent(container:LayoutGroup):void
        {
            _typePicker = new PickerList();
            _typePicker.dataProvider = new ListCollection(SUPPORTED_TYPES);
            addChild(_typePicker);

            super.createContent(container);
        }

        override protected function onDialogComplete(event:Event):void
        {
            var index:int = int(event.data);

            if (index == 0)
            {
                if (_list.selectedIndex >= 0)
                {
                    var textureName:String = _list.selectedItem.label;
                    _target = new Image(_assetMediator.getTexture(textureName));
                    setCustomParam(textureName);

                    var popupType:String = _typePicker.selectedItem.toString();

                    if (popupType != NONE) {
                        var popupData:Object = {
                            "name"             : popupType,
                            "supportedClasses" : ["null", "flash.geom.Rectangle"]
                        };
                        var imageData:Object =  getImageTemplate(textureName);
                        PopUpManager.addPopUp(new ImageGridPopup(_target, null, popupData, imageData, function(data:Object) : void {
                            var rect:Rectangle = data as Rectangle;
                            if (rect)
                            switch (popupType) {
                                case SCALE_9_GRID: (_target as Image).scale9Grid = rect; break;
                                case TILE_GRID:    (_target as Image).tileGrid   = rect; break;
                            }
                            complete();
                        }));
                    } else {
                        complete();
                    }
                }
                else
                {
                    _target = null;
                    complete();
                }


            }
            else
            {
                _owner[_targetParam.name] = _oldTarget;
                _onComplete = null;
            }
        }

        override protected function setCustomParam(textureName:String):void
        {
            /*
             TODO:
             this is a temparary solution to store a custom value since Texture doesn't contain it.
             This problem will be resolved when we use an intermediate format for the inspector in future version
             */

            if (_customParam)
            {
                if (_customParam.params == undefined)
                {
                    _customParam.params = {};
                }

                _customParam.params[_targetParam.name] = getImageTemplate(textureName);

            }
        }

        private function getImageTemplate(textureName:String) : Object {
            return {
                "cls":"starling.display.Image",
                "constructorParams":[
                    {
                        "cls":"starling.textures.Texture",
                        "textureName":textureName
                    }
                ],
                "customParams":{},
                "params":{}
            };
        }

    }
}
