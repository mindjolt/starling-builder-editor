/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
    import feathers.core.FeathersControl;

    import starling.display.DisplayObject;

    import starling.events.Event;

    import starlingbuilder.editor.TestSetting;
    import starlingbuilder.editor.UIEditorApp;
    import starlingbuilder.util.feathers.FeathersUIUtil;

    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.core.Starling;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.display.Stage;
    import starling.events.ResizeEvent;

    import starlingbuilder.util.ui.inspector.PropertyPanel;
    import starlingbuilder.util.ui.inspector.UIMapperEventType;

    public class TestPanel extends LayoutGroup
    {
        private var _exitButton:Button;

        private var _container:Sprite;

        private var _scrollContainer:ScrollContainer;

        private var _background:Quad;

        private var _setting:TestSetting;

        private var _propertyPanel:PropertyPanel;

        private var _designWidth:int;

        private var _designHeight:int;

        public function TestPanel(container:Sprite)
        {
            _container = container;

            layout = new AnchorLayout();

            var stage:Stage = Starling.current.stage;
            stage.addChild(this);
            stage.addEventListener(ResizeEvent.RESIZE, onResize);

            width = stage.stageWidth;
            height = stage.stageHeight;

            _background = new Quad(width, height, 0x4a4137);
            addChild(_background);

            _scrollContainer = new ScrollContainer();
            var layoutData:AnchorLayoutData = new AnchorLayoutData(0, 20, 0, 200);
            _scrollContainer.layoutData = layoutData;
            addChild(_scrollContainer);

            _container.scaleX = _container.scaleY = UIEditorApp.instance.documentManager.scale;

            var layoutGroup:LayoutGroup = new LayoutGroup();
            layoutGroup.addChild(_container);
            _scrollContainer.addChild(layoutGroup);

            var canvasSize:Point = UIEditorApp.instance.documentManager.canvasSize;
            _designWidth = canvasSize.x;
            _designHeight = canvasSize.y;

            _container.mask = new Quad(canvasSize.x, canvasSize.y);

            _exitButton = FeathersUIUtil.buttonWithLabel("exit", onExit);
            addChild(_exitButton);

            createSettingPanel();

            layoutData.rightAnchorDisplayObject = _propertyPanel;

            (_container.parent as FeathersControl).invalidate();
        }

        private function createSettingPanel():void
        {
            _setting = new TestSetting();
            _setting.deviceWidth = _designWidth;
            _setting.deviceHeight = _designHeight;
            _propertyPanel = new PropertyPanel(_setting, TestSetting.PARAMS);
            _propertyPanel.layoutData = new AnchorLayoutData(20, 20, 20);
            PropertyPanel.globalDispatcher.addEventListener(UIMapperEventType.PROPERTY_CHANGE, onPropertyChange);
            addChild(_propertyPanel);
        }

        private function onPropertyChange(event:Event):void
        {
            if (event.data.target !== _setting) return;

            var width:int = _setting.deviceWidth;
            var height:int = _setting.deviceHeight;

            var canvas:DisplayObject = _container.getChildAt(0);
            canvas.width = width;
            canvas.height = height;

            _container.mask = new Quad(width, height);

            scaleContent(_designWidth, _designHeight, width, height);

            fitBackground();

            //make sure anchor works
            var root:LayoutGroup = _container.getChildAt(_container.numChildren - 1) as LayoutGroup;
            if (root)
            {
                root.width = width / root.scaleX;
                root.height = height / root.scaleY;
            }

            (_container.parent as FeathersControl).invalidate();
        }

        private function onExit():void
        {
            removeFromParent(true);
        }

        public function get container():Sprite
        {
            return _container;
        }

        private function onResize(event:ResizeEvent):void
        {
            width = _background.width = event.width;
            height = _background.height =  event.height;
        }

        override public function dispose():void
        {
            PropertyPanel.globalDispatcher.removeEventListener(UIMapperEventType.PROPERTY_CHANGE, onPropertyChange);

            super.dispose();
        }

        private function fitBackground():void
        {
            if (_container.numChildren == 3)
                BackgroundTab.fitBackground(_container.getChildAt(1), _container.getChildAt(0));
        }

        private function scaleContent(designWidth:int, designHeight:int, deviceWidth:int, deviceHeight:int):void
        {
            switch (_setting.fitStrategy)
            {
                case TestSetting.FIT_ALL:
                    fitAll(designWidth, designHeight, deviceWidth, deviceHeight);
                    break;
            }
        }

        private function fitAll(designWidth:int, designHeight:int, deviceWidth:int, deviceHeight:int):void
        {
            var scale:Number = Math.min(1.0 * deviceWidth / designWidth, 1.0 * deviceHeight / designHeight);

            for (var i:int = 1; i < _container.numChildren; ++i)
            {
                var obj:DisplayObject = _container.getChildAt(i);
                obj.scaleX = obj.scaleY = scale;
            }
        }
    }
}
