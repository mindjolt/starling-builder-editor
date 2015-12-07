/**
 * Created by hyh on 12/7/15.
 */
package com.sgn.tools.util.ui.list
{
    import com.sgn.tools.util.ui.*;
    import feathers.controls.GroupedList;
    import feathers.controls.renderers.IGroupedListHeaderOrFooterRenderer;
    import feathers.controls.renderers.IGroupedListHeaderRenderer;
    import feathers.data.HierarchicalCollection;

    import org.as3commons.lang.ObjectUtils;

    import starling.events.Event;

    public class ExpandableGroupedList extends GroupedList
    {
        public static const HEADER_TRIGGER:String = "headerTrigger";

        private var _collapseMap:Object;

        private var _originalDataProvider:HierarchicalCollection;

        public function ExpandableGroupedList()
        {
            super();

            _collapseMap = {};

            headerRendererFactory = function():IGroupedListHeaderRenderer
            {
                return new ExpandableGroupListHeaderRenderer();
            }

            addEventListener(HEADER_TRIGGER, onHeaderTrigger);
        }

        public function expandAll():void
        {
            _collapseMap = {};

            updateDataProvider();
        }

        public function collapseAll():void
        {
            for each (var item:Object in _originalDataProvider.data)
            {
                _collapseMap[item.header.label] = true;
            }

            updateDataProvider();
        }

        override public function set dataProvider(value:HierarchicalCollection):void
        {
            if (_originalDataProvider == value)
            {
                return;
            }
            else
            {
                _originalDataProvider = value;

                updateDataProvider();
            }
        }

        private function updateDataProvider():void
        {
            if (_originalDataProvider)
            {
                var data:Object = ObjectUtils.clone(_originalDataProvider.data);

                for each (var item:Object in data)
                {
                    if (_collapseMap[item.header.label])
                    {
                        item.children = [];
                    }
                }

                super.dataProvider = new HierarchicalCollection(data);
            }
            else
            {
                super.dataProvider = null;
            }
        }

        private function onHeaderTrigger(event:Event):void
        {
            var name:String = event.data as String;

            if (_collapseMap[name])
            {
                delete _collapseMap[name];
            }
            else
            {
                _collapseMap[name] = true;
            }

            updateDataProvider();
        }

        override public function dispose():void
        {
            removeEventListener(HEADER_TRIGGER, onHeaderTrigger);

            super.dispose();
        }



    }
}
