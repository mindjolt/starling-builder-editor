/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.serialize
{
    import com.sgn.starlingbuilder.editor.UIEditorApp;
    import com.sgn.tools.util.serialize.IDocumentMediator;

    import flash.filesystem.File;

    public class UIEditorDocumentMediator implements IDocumentMediator
    {
        public function UIEditorDocumentMediator()
        {
        }

        public function read(obj:Object, file:File):void
        {
            if (obj)
            {
                UIEditorApp.instance.documentManager.importData(obj, file);
            }
            else
            {
                UIEditorApp.instance.documentManager.clear();
            }
        }

        public function write():Object
        {
            return UIEditorApp.instance.documentManager.export();
        }

        public function get defaultSaveFilename():String
        {
            return "layout.json";
        }

    }
}
