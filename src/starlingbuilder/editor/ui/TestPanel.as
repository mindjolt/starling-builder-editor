/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.ui
{
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

    public class TestPanel extends LayoutGroup
    {
        private var _exitButton:Button;

        private var _container:Sprite;

        private var _scrollContainer:ScrollContainer;

        private var _background:Quad;

        public function TestPanel(scale:Number)
        {
            layout = new AnchorLayout();

            var stage:Stage = Starling.current.stage;
            stage.addChild(this);
            stage.addEventListener(ResizeEvent.RESIZE, onResize);

            width = stage.stageWidth;
            height = stage.stageHeight;

            _background = new Quad(width, height, 0x4a4137);
            addChild(_background);

            _scrollContainer = new ScrollContainer();
            _scrollContainer.x = 200;
            _scrollContainer.width = 1000;
            _scrollContainer.height = 900;
            addChild(_scrollContainer);

            var layoutData:AnchorLayoutData = new AnchorLayoutData();
            layoutData.top = 0;
            layoutData.bottom = 0;
            _scrollContainer.layoutData = layoutData;

            _container = new Sprite();
            _container.scaleX = _container.scaleY = scale;
            _scrollContainer.addChild(_container);

            var canvasSize:Point = UIEditorApp.instance.documentManager.canvasSize;
            var canvas:Quad = new Quad(canvasSize.x, canvasSize.y);
            _container.clipRect = new Rectangle(0, 0, canvasSize.x, canvasSize.y);
            _container.addChild(canvas);

            _exitButton = FeathersUIUtil.buttonWithLabel("exit", onExit);
            addChild(_exitButton);
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
    }
}
