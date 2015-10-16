/**
 * Created with IntelliJ IDEA.
 * User: hyh
 * Date: 5/31/13
 * Time: 3:37 PM
 * To change this template use File | Settings | File Templates.
 */
package com.sgn.tools.util.feathers.popup
{
    import com.sgn.tools.util.feathers.FeathersUIUtil;

    import feathers.controls.Button;
    import feathers.controls.LayoutGroup;
    import feathers.core.PopUpManager;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.VerticalLayout;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class InfoPopup extends BasePopupDev
    {
        private var _buttonContainer:LayoutGroup;

        public function InfoPopup(w:Number = 400, h:Number = 400)
        {
            super();

            /*width = w;
            height = h;*/

            init();
        }

        private function init():void
        {
            var container:LayoutGroup = new LayoutGroup();

            var layout:VerticalLayout = new VerticalLayout();
            layout.gap = 10;
            layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
            container.layout = layout;

            _buttonContainer = new LayoutGroup();//FeathersUIUtil.scrollContainerWithHorizontalLayout();
            _buttonContainer.layout = new HorizontalLayout();

            createContent(container);
            container.addChild(_buttonContainer);

            addChild(container);

            //width = width;
            //height = height;
        }

        public function set buttons(array:Array):void
        {
            removeButtons();

            for each (var label:String in array)
            {
                var button:Button = FeathersUIUtil.buttonWithLabel(label);
                button.addEventListener(Event.TRIGGERED, onButtonTrigger);
                _buttonContainer.addChild(button);
            }
        }

        private function onButtonTrigger(event:Event):void
        {
            for (var i:int = 0; i < _buttonContainer.numChildren; i++)
            {
                var button:DisplayObject = _buttonContainer.getChildAt(i);
                if (button === event.target)
                {
                    dispatchEventWith(Event.COMPLETE, false, i);
                }
            }

            PopUpManager.removePopUp(this);
        }

        private function removeButtons():void
        {
            for (var i:int = 0; i < _buttonContainer.numChildren; i++)
            {
                var button:DisplayObject = _buttonContainer.getChildAt(i);
                button.removeEventListener(Event.TRIGGERED, onButtonTrigger);
            }

            _buttonContainer.removeChildren();
        }


        public static function show(title:String, buttons:Array = null):InfoPopup
        {
            if (buttons == null) buttons = ["OK"];
            var popup:InfoPopup = new InfoPopup();
            popup.title = title;
            popup.buttons = buttons;
            PopUpManager.addPopUp(popup);
            return popup;
        }

        protected function createContent(container:LayoutGroup):void
        {


        }
    }
}
