/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.feathers
{
    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;
    import feathers.core.FeathersControl;
    import feathers.layout.AnchorLayout;
    import feathers.layout.AnchorLayoutData;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.ILayout;
    import feathers.layout.VerticalLayout;

    import starling.display.DisplayObjectContainer;
    import starling.events.Event;

    public class FeathersUIUtil
    {
        public function FeathersUIUtil()
        {
        }

        public static function labelWithText(text:String):Label
        {
            var label:Label = new Label;
            label.text = text;
            return label;
        }

        public static function scrollContainerWithLayout(layout:ILayout):ScrollContainer
        {
            var container:ScrollContainer = new ScrollContainer();
            container.layout = layout;
            return container;
        }

        public static function scrollContainerWithHorizontalLayout(gap:int = 10):ScrollContainer
        {
            var container:ScrollContainer = new ScrollContainer();
            var layout:HorizontalLayout = new HorizontalLayout();
            layout.gap = gap;
            container.layout = layout;
            return container;
        }

        public static function scrollContainerWithVerticalLayout(gap:int = 10):ScrollContainer
        {
            var container:ScrollContainer = new ScrollContainer();
            var layout:VerticalLayout = new VerticalLayout();
            layout.gap = gap;
            container.layout = layout;
            return container;
        }

        public static function layoutGroupWithHorizontalLayout(gap:int = 10):LayoutGroup
        {
            var group:LayoutGroup = new LayoutGroup();
            var layout:HorizontalLayout = new HorizontalLayout();
            layout.gap = gap;
            group.layout = layout;
            return group;
        }

        public static function layoutGroupWithVerticalLayout(gap:int = 10):LayoutGroup
        {
            var group:LayoutGroup = new LayoutGroup();
            var layout:VerticalLayout = new VerticalLayout();
            layout.gap = gap;
            group.layout = layout;
            return group;
        }

        public static function layoutGroupWithAnchorLayout():LayoutGroup
        {
            var group:LayoutGroup = new LayoutGroup();
            group.layout = new AnchorLayout();
            return group;
        }

        public static function buttonWithLabel(label:String, onTrigger:Function = null):Button
        {
            var button:Button = new Button;
            button.label = label;

            if (onTrigger)
                button.addEventListener(Event.TRIGGERED, onTrigger);

            return button;
        }

        public static function anchorLayoutData(top:Number = NaN, bottom:Number = NaN, left:Number = NaN, right:Number = NaN):AnchorLayoutData
        {
            var layoutData:AnchorLayoutData = new AnchorLayoutData();
            layoutData.top = top;
            layoutData.bottom = bottom;
            layoutData.left = left;
            layoutData.right = right;
            return layoutData;
        }

        public static function anchorToBottom(container:DisplayObjectContainer, gap:Number = 10):void
        {
            var layoutData:AnchorLayoutData;

            for (var i:int = container.numChildren - 1; i >= 0; --i)
            {
                var fc:FeathersControl = container.getChildAt(i) as FeathersControl;

                if (fc)
                {
                    layoutData = new AnchorLayoutData();

                    if (i == 0)
                    {
                        layoutData.top = 0;
                    }

                    layoutData.bottom = gap;

                    if (i + 1 < container.numChildren)
                    {
                        layoutData.bottomAnchorDisplayObject = container.getChildAt(i + 1);
                    }
                    fc.layoutData = layoutData;
                }
                else
                {
                    return;
                }
            }
        }


    }
}

