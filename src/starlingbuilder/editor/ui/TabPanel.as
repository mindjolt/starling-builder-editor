/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.controls.LayoutGroup;
    import feathers.controls.TabBar;
    import feathers.data.ListCollection;
    import feathers.layout.AnchorLayout;

    import starling.display.DisplayObject;
    import starling.display.Sprite;
    import starling.events.Event;

    public class TabPanel extends LayoutGroup
    {
        protected var _tabScreens:Array;

        protected var _tab:TabBar;

        protected var _currentTab:Sprite;

        public function TabPanel()
        {
            this.layout = new AnchorLayout();
        }

        protected function createTabs(data:Array, tabs:Array):void
        {
            _tabScreens = tabs;

            var listCollection:ListCollection = new ListCollection(data);

            _tab = new TabBar();
            _tab.dataProvider = listCollection;
            _tab.addEventListener(Event.CHANGE, onTabChange);
            addChild(_tab);

            onTabChange(null);
        }

        protected function onTabChange(event:Event):void
        {
            if (_currentTab)
            {
                _currentTab.removeFromParent();
            }

            _currentTab = _tabScreens[_tab.selectedIndex];

            addChild(_currentTab);
        }

        public function get currentTab():Sprite
        {
            return _currentTab;
        }

        override public function dispose():void
        {
            for each (var obj:DisplayObject in _tabScreens)
            {
                obj.removeFromParent(true);
            }

            super.dispose();
        }
    }
}
