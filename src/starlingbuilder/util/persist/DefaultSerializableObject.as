/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.persist
{
    import starling.events.Event;
    import starling.events.EventDispatcher;

    import starlingbuilder.util.ObjectUtil;

    public class DefaultSerializableObject extends EventDispatcher implements ISerializableObject
    {
        public function load(data:Object):void
        {
            if (data)
                ObjectUtil.fromJSONObject(this, data);
        }

        public function save():Object
        {
            return ObjectUtil.toJSONObject(this);
        }

        public function setChanged():void
        {
            dispatchEventWith(Event.CHANGE);
        }
    }
}
