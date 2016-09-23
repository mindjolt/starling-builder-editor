/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor
{
    import feathers.controls.*;
    import feathers.layout.FlowLayout;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.TiledColumnsLayout;
    import feathers.layout.TiledRowsLayout;
    import feathers.layout.VerticalLayout;
    import feathers.layout.VerticalSpinnerLayout;
    import feathers.layout.WaterfallLayout;
    import feathers.media.VideoPlayer;

    import starling.display.Button;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.display.Sprite3D;
    import starling.filters.BlurFilter;
    import starling.filters.DropShadowFilter;
    import starling.filters.GlowFilter;
    import starling.styles.DistanceFieldStyle;
    import starling.text.TextField;

    import starlingbuilder.extensions.filters.ColorFilter;

    public class SupportedWidget
    {
        /*
         * NOTE:
         *
         * Add to this linkers if you want your component to be officially supported by the editor, as well as adding meta data in editor_template.json
         * If you want to register custom component, then you should call TemplateData.registerCustomComponent instead
         *
         */

        public static const LINKERS:Array = [
            Image,
            TextField,
            starling.display.Button,
            Quad,
            List,
            Sprite,
            Sprite3D,

            Alert,
            AutoComplete,
            feathers.controls.Button,
            ButtonGroup,
            Callout,
            Check,
            DateTimeSpinner,
            Drawers,
            GroupedList,
            Header,
            ImageLoader,
            Label,
            LayoutGroup,
            List,
            MovieClip,
            NumericStepper,
            PageIndicator,
            Panel,
            PanelScreen,
            PickerList,
            ProgressBar,
            Radio,
            Screen,
            ScreenNavigator,
            ScreenNavigatorItem,
            ScrollBar,
            ScrollContainer,
            Scroller,
            ScrollScreen,
            ScrollText,
            SimpleScrollBar,
            Slider,
            SpinnerList,
            StackScreenNavigator,
            StackScreenNavigatorItem,
            TabBar,
            TextArea,
            TextInput,
            ToggleButton,
            ToggleSwitch,
            VideoPlayer,
            WebView,

            HorizontalLayout,
            VerticalLayout,
            FlowLayout,
            TiledRowsLayout,
            TiledColumnsLayout,
            VerticalSpinnerLayout,
            WaterfallLayout,

            BlurFilter,
            GlowFilter,
            DropShadowFilter,
            ColorFilter,

            DistanceFieldStyle,
        ]

        public static const DEFAULT_SCALE3_RATIO:Array = [0.49, 0.02, "horizontal"];
        public static const DEFAULT_SCALE9_RATIO:Array = [0.3, 0.3, 0.4, 0.4];

        public function SupportedWidget()
        {

        }
    }
}
