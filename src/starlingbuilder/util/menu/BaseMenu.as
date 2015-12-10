/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.menu
{
    import flash.desktop.NativeApplication;
    import flash.display.NativeMenu;
    import flash.display.NativeMenuItem;
    import flash.display.NativeWindow;
    import flash.events.Event;

    import starling.core.Starling;
    import starling.events.EventDispatcher;

    public class BaseMenu
    {
        protected var _rootMenu:NativeMenu;
        protected var _subMenus:Array = [];

        protected var _eventDispatcher:EventDispatcher;

        public function BaseMenu()
        {
            _eventDispatcher = new EventDispatcher();

            addMenu();
        }

        protected function createRootMenu():void
        {
        }

        public function createSubMenu(content:Array, label:String):void
        {
            var menu:NativeMenu = new NativeMenu();

            for each (var data:Object in content)
            {
                var item:NativeMenuItem;

                if (data.menu)
                {
                    menu.addSubmenu(new NativeMenu(), data.label);
                    menu.getItemAt(menu.numItems - 1).name = data.label;
                }
                else
                {
                    if (data.separator)
                    {
                        item = new NativeMenuItem("", true);
                    }
                    else
                    {
                        item = new NativeMenuItem(data.label);
                        item.name = data.label;
                        item.addEventListener(Event.SELECT, onItemSelect);
                        if (data.key)
                        {
                            item.keyEquivalent = data.key;
                        }
                    }

                    if (data.disabled)
                    {
                        item.enabled = false;
                    }

                    if (data.checked)
                    {
                        item.checked = true;
                    }

                    menu.addItem(item);
                }
            }

            _rootMenu.addSubmenu(menu, label);

            _rootMenu.getItemAt(_rootMenu.numItems - 1).name = label;

            _subMenus.push(menu);
        }

        private function onItemSelect(event:Event):void
        {
            var item:NativeMenuItem = event.target as NativeMenuItem;

            //trace(item.name);
            _eventDispatcher.dispatchEventWith(item.name, false, item);
        }

        private function addMenu():void
        {
            createRootMenu();

            if (NativeApplication.supportsMenu)
            {
                attachMenu(NativeApplication.nativeApplication.menu);
            }
            else if (NativeWindow.supportsMenu)
            {
                Starling.current.nativeStage.nativeWindow.menu = _rootMenu;
            }
        }

        private function attachMenu(menu:NativeMenu):void
        {
            //keep the first menu item
            while (menu.numItems > 1)
            {
                menu.removeItemAt(1);
            }

            //replace the rest
            while (_rootMenu.numItems > 0)
            {
                var item:NativeMenuItem = _rootMenu.removeItemAt(0);
                menu.addItem(item);
            }

            _rootMenu = menu;
        }

        public function registerAction(id:String, listener:Function):void
        {
            _eventDispatcher.addEventListener(id, listener);
        }

        public function unregisterAction(id:String, listener:Function):void
        {
            _eventDispatcher.removeEventListener(id, listener);
        }

        public function unregisterAll():void
        {
            _eventDispatcher.removeEventListeners();
        }

        public function getItemByName(name:String):NativeMenuItem
        {
            for each (var menu:NativeMenu in _subMenus)
            {
                var item:NativeMenuItem = menu.getItemByName(name);
                if (item) return item;
            }

            return null;
        }

        public function get root():NativeMenu
        {
            return _rootMenu;
        }
    }
}
