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

    import starlingbuilder.editor.controller.ComponentRenderSupport;

    import starlingbuilder.editor.controller.IComponentRenderSupport;

    public class ScaleTextureConstructorPopup1 extends TexturePropertyPopup
    {
        public function ScaleTextureConstructorPopup1(owner:Object, target:Object, targetParam:Object, customParam:Object, onComplete:Function)
        {
            super(owner, target, targetParam, customParam, onComplete);
        }

        override protected function setCustomParam(textureName:String):void
        {
            var param1:Object = _customParam ? _customParam.constructorParams[0] : null;

            if (param1 && param1.textureName)
            {
                param1.textureName = textureName;
            }
        }

        override protected function complete():void
        {
            var popup2:ScaleTextureConstructorPopup2 = new ScaleTextureConstructorPopup2(_owner, _targetParam.name, _customParam, _onComplete);
            PopUpManager.addPopUp(popup2);
        }
    }
}
