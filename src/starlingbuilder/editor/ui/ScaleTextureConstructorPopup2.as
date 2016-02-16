/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.editor.controller.DocumentManager;

    public class ScaleTextureConstructorPopup2 extends ScaleTexturePopup
    {
        private var _documentManager:DocumentManager;
        private var _target:Object;

        public function ScaleTextureConstructorPopup2(target:Object, data:Object, onComplete:Function)
        {
            super(data, onComplete);
            _target = target;
            _documentManager = UIEditorApp.instance.documentManager;
        }

        override protected function complete():void
        {
            if (_target.hasOwnProperty("textures"))
                _target["textures"] = _documentManager.uiBuilder.createUIElement(_data.constructorParams[0]).object;

            _documentManager.setChanged();

            super.complete();
        }
    }
}
