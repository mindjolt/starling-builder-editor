/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.tools.util.feathers
{
    import feathers.controls.AutoComplete;
    import feathers.data.ListCollection;
    import feathers.events.FeathersEventType;

    import flash.utils.setTimeout;

    import starling.events.Event;

    public class AutoCompleteWithDropDown extends AutoComplete
    {
        public function AutoCompleteWithDropDown()
        {
            super();
        }

        public function set autoCompleteSource(data:Array):void
        {
            var listCollection:ListCollection = new ListCollection();

            for each (var item:Object in data)
            {
                listCollection.push(item);
            }

            source = new LocalAutoCompleteSourceWithDropDown(listCollection);
            minimumAutoCompleteLength = 0;
            autoCompleteDelay = 0;
            addEventListener(FeathersEventType.FOCUS_IN, onFocusIn);
        }

        private function onFocusIn(event:Event):void
        {
            setTimeout(function ():void
            {
                dispatchEventWith(Event.CHANGE);
            }, 1);
        }

        override public function dispose():void
        {
            removeEventListener(FeathersEventType.FOCUS_IN, onFocusIn);
            super.dispose();
        }
    }
}
