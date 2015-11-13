/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.ui
{
    import starling.display.Image;
    import starling.events.Event;

    public class DisplayObjectPropertyPopup extends TexturePropertyPopup
    {
        public function DisplayObjectPropertyPopup(owner:Object, target:Object, targetParam:Object, onComplete:Function)
        {
            super(owner, target, targetParam, onComplete);
        }

        override protected function onDialogComplete(event:Event):void
        {
            var index:int = int(event.data);

            if (index == 0)
            {
                if (_list.selectedIndex >= 0)
                {
                    var textureName:String = _list.selectedItem.label;

                    _target = new Image(_assetManager.getTexture(textureName));

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
                cls:"starling.display.Image",
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
