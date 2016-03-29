/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.upgrade
{
    public class AbstractLayoutConverter implements ILayoutConverter
    {
        public function AbstractLayoutConverter()
        {
        }

        public function getCurrentVersion():String
        {
            return null;
        }

        public function getUpgradePolicy(data:Object):String
        {
            return LayoutUpgradePolicy.NO_UPGRADE;
        }

        public function upgrade(data:Object):Object
        {
            data = JSON.parse(data as String);
            data.version = getCurrentVersion();

            traverseChildren(data.layout);

            return JSON.stringify(data);
        }

        private function traverseChildren(data:Object):void
        {
            process(data);

            for each (var child:Object in data.children)
            {
                traverseChildren(child);
            }
        }

        protected function process(data:Object):void
        {
        }
    }
}
