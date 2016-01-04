/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.serialize
{
    import starlingbuilder.util.feathers.popup.InfoPopup;

    import feathers.core.PopUpManager;

    import flash.events.Event;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    import starling.core.Starling;
    import starling.events.EventDispatcher;

    public class DocumentSerializer extends EventDispatcher
    {
        public static const CREATE:String = "create";
        public static const SAVE:String = "save";
        public static const OPEN:String = "open";
        public static const CLOSE:String = "close";
        public static const READ:String = "read";
        public static const READ_WITH_FILE:String = "readWithFile";

        public static const CHANGE:String = "change";

        private var _isDirty:Boolean = false;

        private var _file:File;

        private var _currentDirectory:File;

        private var _pendingActions:Array = [];

        private var _mediator:IDocumentMediator;

        private var _pendingFile:File;

        public function DocumentSerializer(documentMediator:IDocumentMediator)
        {
            _mediator = documentMediator;
        }

        public function create():void
        {
            if (isDirty())
            {
                actionForOldFile();
                _pendingActions.push(CREATE);
            }
            else
            {
                doCreate();
            }
        }



        public function save():Boolean
        {
            if (isSelected())
            {
                doSave();
                continuePendingActions();
                return true;
            }
            else
            {
                chooseFileToSave();
                _pendingActions.push(SAVE);
                return false;
            }
        }

        public function saveAs():void
        {
            chooseFileToSave();
            _pendingActions.push(SAVE);
        }


        private function selectFile():void
        {
            var file:File = new File();
            file.addEventListener(Event.SELECT, onFileSelected);
            file.addEventListener(Event.CANCEL, onFileCanceled);
            file.browseForOpen("Please select a file to open");
        }

        private function chooseFileToSave():void
        {
            var file:File = new File();
            file.addEventListener(Event.SELECT, onFileSelected);
            file.addEventListener(Event.CANCEL, onFileCanceled);
            file.browseForSave("Please select a file to save");
        }

        private function onFileSelected(event:Event):void
        {
            var file:File = event.target as File;
            file.removeEventListener(Event.SELECT, onFileSelected);
            file.removeEventListener(Event.CANCEL, onFileCanceled);

            _file = file;
            continuePendingActions();
        }

        private function onFileCanceled(event:Event):void
        {
            var file:File = event.target as File;
            file.removeEventListener(Event.SELECT, onFileSelected);
            file.removeEventListener(Event.CANCEL, onFileCanceled);

            _pendingActions = [];
            _pendingFile = null;
        }


        private function doSave():void
        {
            _isDirty = false;

            var data:Object = _mediator.write();

            var fs:FileStream = new FileStream();
            fs.open(_file, FileMode.WRITE);
            fs.writeUTFBytes(data.toString());
            fs.close();

            setChange(_file.url);
        }

        public function openWithFile(file:File):void
        {
            _pendingFile = file;
            if (isDirty())
            {
                actionForOldFile();
                _pendingActions.push(READ_WITH_FILE);
            }
            else
            {
                readWithFile();
            }
        }

        public function open():void
        {
            if (isDirty())
            {
                actionForOldFile();
                _pendingActions.push(OPEN);
            }
            else
            {
                selectFile();
                _pendingActions.push(READ);
            }
        }

        public function read():void
        {
            var fs:FileStream = new FileStream();
            fs.open(_file, FileMode.READ);
            var data:Object = fs.readUTFBytes(fs.bytesAvailable);
            fs.close();

            _mediator.read(data, _file);

            _isDirty = false;

            setChange(_file.url);
        }

        public function readWithFile():void
        {
            _file = _pendingFile;
            _pendingFile = null;
            read();
        }

        public function close():void
        {
            if (isDirty())
            {
                actionForOldFile();
                _pendingActions.push(CLOSE);
            }
            else
            {
                doClose();
            }
        }

        private function doClose():void
        {
            Starling.current.nativeStage.nativeWindow.close();
        }

        public function discard():void
        {
            _isDirty = false;
        }

        public function isDirty():Boolean
        {
            return _isDirty;
        }

        public function isSelected():Boolean
        {
            return _file != null;
        }

        public function getFile():File
        {
            return _file;
        }

        private function actionForOldFile():void
        {
            var text:String = "Your current document is not saved.\nWould you like to";

            var popup:InfoPopup = new InfoPopup(300, 200);
            popup.title = text;
            popup.buttons = ["Cancel", "Save", "Discard"];
            popup.addEventListener(Event.COMPLETE, onPopup);

            PopUpManager.addPopUp(popup);
            PopUpManager.centerPopUp(popup);

        }

        private function onPopup(e:*):void
        {
            var index:int = e.data;
            switch (index)
            {
                case 0:
                    _pendingActions = [];
                    break;
                case 1:
                    if (save())
                        continuePendingActions();
                    break;
                case 2:
                    discard();
                    continuePendingActions();
                    break;
            }
        }

        private function doCreate():void
        {
            _file = null;
            _mediator.read(null, null);
            _isDirty = false;
        }

        private function continuePendingActions():void
        {
            if (_pendingActions.length)
            {
                var action:String = _pendingActions.pop();

                if (hasOwnProperty(action))
                {
                    this[action]();
                }
                else
                {
                    doCustomAction(action);
                }
            }
        }

        public function markDirty(value:Boolean):void
        {
            _isDirty = value;
        }

        public function customAction(customEventType:String):void
        {
            if (isDirty())
            {
                actionForOldFile();
                _pendingActions.push(customEventType);
            }
            else
            {
                doCustomAction(customEventType);
            }
        }

        private function doCustomAction(customEventType:String):void
        {
            dispatchEventWith(customEventType);
        }

        private function setChange(url:String):void
        {
            dispatchEventWith(CHANGE, false, url);
        }

    }
}
