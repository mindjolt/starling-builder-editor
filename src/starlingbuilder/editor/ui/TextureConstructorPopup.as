/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    public class TextureConstructorPopup extends TexturePropertyPopup
    {
        public function TextureConstructorPopup(owner:Object, target:Object, targetParam:Object, onComplete:Function)
        {
            super(owner, target, targetParam, onComplete);
        }

        override protected function setCustomParam(textureName:String):void
        {
            var param:Object = _documentManager.extraParamsDict[_owner];

            var param1:Object = param.constructorParams[0];

            if (param1.textureName)
            {
                param1.textureName = textureName;
            }

            if (_owner.hasOwnProperty(_targetParam.name))
                _owner[_targetParam.name] = _assetManager.getTexture(textureName);

            if (_owner.hasOwnProperty("readjustSize"))
                _owner["readjustSize"]();

            _documentManager.setChanged();
        }
    }
}
