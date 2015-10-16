/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.serialize
{
    import com.sgn.starlingbuilder.editor.controller.DocumentManager;
    import com.sgn.tools.util.serialize.IDocumentMediator;

    import flash.filesystem.File;

    public class LoadExternalDocumentMediator implements IDocumentMediator
    {
        private var _documentManager:DocumentManager;

        public function LoadExternalDocumentMediator(documentManager:DocumentManager)
        {
            _documentManager = documentManager;
        }

        public function read(obj:Object, file:File):void
        {
            _documentManager.loadExternal(obj, file);
        }

        public function write():Object
        {
            throw new Error("Feature not supported!");
        }


        public function get defaultSaveFilename():String
        {
            throw new Error("Feature not supported!");
        }
    }
}
