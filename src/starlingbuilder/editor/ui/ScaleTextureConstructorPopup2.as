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

    public class ScaleTextureConstructorPopup2 extends ScaleTexturePopup
    {
        private var _target:Object;
        private var _propertyName:String;

        public function ScaleTextureConstructorPopup2(target:Object, propertyName:String, data:Object, onComplete:Function)
        {
            super(data, onComplete);
            _target = target;
            _propertyName = propertyName;
        }

        override protected function complete():void
        {
            if (_target.hasOwnProperty(_propertyName))
                _target[_propertyName] = ComponentRenderSupport.support.uiBuilder.createUIElement(_data.constructorParams[0]).object;

            ComponentRenderSupport.support.setChanged();

            super.complete();
        }
    }
}
