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
    import feathers.display.Scale3Image;
    import feathers.display.Scale9Image;
    import feathers.textures.Scale3Textures;
    import feathers.textures.Scale9Textures;

    import flash.utils.getDefinitionByName;

    import starling.events.Event;

    import starlingbuilder.editor.SupportedWidget;

    import starlingbuilder.engine.util.ParamUtil;

    public class DisplayObjectPropertyPopup extends TexturePropertyPopup
    {
        public static const SUPPORTED_CLASSES:Array = ["starling.display.Image", "feathers.display.Scale3Image", "feathers.display.Scale9Image", "feathers.display.TiledImage"];

        private var _typePicker:PickerList;

        public function DisplayObjectPropertyPopup(owner:Object, target:Object, targetParam:Object, onComplete:Function)
        {
            super(owner, target, targetParam, onComplete);
        }

        override protected function createContent(container:LayoutGroup):void
        {
            _typePicker = new PickerList();
            _typePicker.dataProvider = new ListCollection(SUPPORTED_CLASSES);
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

                    var clsName:String = _typePicker.selectedItem.toString();

                    var cls:Class = getDefinitionByName(clsName) as Class;

                    if (cls == Scale3Image || cls == Scale9Image)
                    {
                        var textureData:Object = {
                            cls:(cls == Scale3Image) ? ParamUtil.getClassName(Scale3Textures) : ParamUtil.getClassName(Scale9Textures),
                            textureName: textureName,
                            scaleRatio: (cls == Scale3Image) ? SupportedWidget.DEFAULT_SCALE3_RATIO : SupportedWidget.DEFAULT_SCALE9_RATIO
                        };

                        var imageData:Object = {
                            cls:clsName,
                            constructorParams:[textureData],
                            customParams:{}
                        }

                        PopUpManager.addPopUp(new ScaleTexturePopup(imageData, function(data:Object):void{

                            _target = _documentManager.uiBuilder.createUIElement(data).object;

                            var param:Object = _documentManager.extraParamsDict[_owner];
                            param.params[_targetParam.name] = data;
                            complete();
                        }));
                    }
                    else
                    {
                        _target = new cls(_assetManager.getTexture(textureName));
                        setCustomParam(textureName);
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

            var param:Object = _documentManager.extraParamsDict[_owner];

            if (param.params == undefined)
            {
                param.params = {};
            }

            param.params[_targetParam.name] =
            {
                cls:_typePicker.selectedItem,
                constructorParams:[
                    {
                        cls:"starling.textures.Texture",
                        textureName: textureName
                    }
                ],
                customParams:{}
            };
        }

    }
}
