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
    import starlingbuilder.util.feathers.popup.InfoPopup;

    public class AbstractPropertyPopup extends InfoPopup
    {
        protected var _documentManager:DocumentManager;

        protected var _onComplete:Function;

        protected var _target:Object;

        protected var _oldTarget:Object;

        protected var _owner:Object;

        protected var _targetParam:Object;


        public function AbstractPropertyPopup(owner:Object, target:Object, targetParam:Object, onComplete:Function)
        {
            _documentManager = UIEditorApp.instance.documentManager;
            _owner = owner;
            _targetParam = targetParam;
            _oldTarget = _target = target;
            _onComplete = onComplete;

            super();
        }
    }
}
