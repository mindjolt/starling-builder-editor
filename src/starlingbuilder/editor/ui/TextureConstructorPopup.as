/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import starlingbuilder.editor.controller.ComponentRenderSupport;
    import starlingbuilder.editor.controller.IComponentRenderSupport;

    public class TextureConstructorPopup extends TexturePropertyPopup
    {
        public function TextureConstructorPopup(owner:Object, target:Object, targetParam:Object, onComplete:Function)
        {
            super(owner, target, targetParam, onComplete);
        }

        override protected function setCustomParam(textureName:String):void
        {
            var param:Object = ComponentRenderSupport.support.extraParamsDict[_owner];

            var param1:Object = param ? param.constructorParams[0] : null;

            if (param1 && param1.textureName)
            {
                param1.textureName = textureName;
            }

            if (_owner.hasOwnProperty(_targetParam.name))
                _owner[_targetParam.name] = _assetMediator.getTexture(textureName);

            if (_owner.hasOwnProperty("readjustSize"))
                _owner["readjustSize"]();

            ComponentRenderSupport.support.setChanged();
        }
    }
}
