/**
 * Created with IntelliJ IDEA.
 * User: hyh
 * Date: 5/30/13
 * Time: 11:03 PM
 * To change this template use File | Settings | File Templates.
 */
package starlingbuilder.util.feathers.popup
{
    import feathers.controls.Header;
    import feathers.controls.Panel;
    import feathers.core.PopUpManager;
    import feathers.layout.VerticalLayout;

    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Quad;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class BasePopupDev extends Panel
    {
        public function BasePopupDev()
        {
            super();

            Starling.current.stage.addEventListener(Event.RESIZE, onResize);

            addEventListener(TouchEvent.TOUCH, onTouch);
        }

        protected function onResize(event:Event):void
        {
            PopUpManager.centerPopUp(this);
            this.invalidate(INVALIDATION_FLAG_LAYOUT);
        }

        override protected function initialize():void
        {
            var layout:VerticalLayout = new VerticalLayout();
            layout.gap = 3;
            layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
            this.layout = layout;

            super.initialize();
        }

        private function onTouch(event:TouchEvent):void
        {
            if (!(header as DisplayObjectContainer).contains(event.target as DisplayObject)) return;

            var touch:Touch = event.getTouch(event.target as DisplayObject);

            if (touch)
            {
                switch (touch.phase)
                {
                    case TouchPhase.MOVED:
                        this.x += touch.globalX - touch.previousGlobalX;
                        this.y += touch.globalY - touch.previousGlobalY;
                        break;
                }
            }
        }



        override public function dispose():void
        {
            Starling.current.stage.removeEventListener(Event.RESIZE, onResize);

            removeEventListener(TouchEvent.TOUCH, onTouch);

            super.dispose();
        }
    }
}
