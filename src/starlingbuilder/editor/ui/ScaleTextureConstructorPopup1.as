/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.core.PopUpManager;

    public class ScaleTextureConstructorPopup1 extends TexturePropertyPopup
    {
        public function ScaleTextureConstructorPopup1(owner:Object, target:Object, targetParam:Object, onComplete:Function)
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
        }

        override protected function complete():void
        {
            var param:Object = _documentManager.extraParamsDict[_owner];

            var popup2:ScaleTextureConstructorPopup2 = new ScaleTextureConstructorPopup2(_owner, param, _onComplete);
            PopUpManager.addPopUp(popup2);
        }
    }
}
