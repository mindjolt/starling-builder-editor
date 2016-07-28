/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.data.HierarchicalCollection;

    import starlingbuilder.engine.util.ParamUtil;

    public class HierarchicalCollectionPopup extends ListCollectionPopup
    {
        public function HierarchicalCollectionPopup(owner:Object, target:Object, targetParam:Object, customParam:Object, onComplete:Function)
        {
            super(owner, target, targetParam, customParam, onComplete);
        }

        override protected function createData(data:Object):Object
        {
            return new HierarchicalCollection(data);
        }

        override protected function getClsName():String
        {
            return ParamUtil.getClassName(HierarchicalCollection);
        }
    }
}
