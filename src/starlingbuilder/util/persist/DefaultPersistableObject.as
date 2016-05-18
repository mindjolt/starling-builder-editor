/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.persist
{
    import flash.net.SharedObject;
    import flash.utils.getQualifiedClassName;

    public class DefaultPersistableObject extends DefaultSerializableObject implements IPersistableObject
    {
        private var _defaultName:String = "persistable";

        public function DefaultPersistableObject(defaultName:String = null)
        {
            if (defaultName)
                _defaultName = defaultName;

            recover();
        }

        public function persist():void
        {
            var data:Object = save();
            var sharedObject:SharedObject = SharedObject.getLocal(_defaultName);
            sharedObject.setProperty(getQualifiedClassName(this), data);
        }

        protected function recover():void
        {
            var sharedObject:SharedObject = SharedObject.getLocal(_defaultName);
            load(sharedObject.data[getQualifiedClassName(this)]);
        }


    }
}
