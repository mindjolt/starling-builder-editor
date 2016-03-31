package starlingbuilder.editor.ui
{
    import feathers.controls.Alert;
    import feathers.controls.Button;
    import feathers.controls.Header;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.TextInput;
    import feathers.core.PopUpManager;
    import feathers.data.ListCollection;
    
    import starling.animation.Transitions;
    import starling.display.DisplayObject;
    import starling.events.Event;
    
    import starlingbuilder.util.feathers.FeathersUIUtil;
    import starlingbuilder.util.feathers.KeyValueDataGrid;
    import starlingbuilder.util.feathers.popup.InfoPopup;

    public class TweenSettingPanel extends InfoPopup
    {
        private static const FROM:String = "from";
        private static const PROPERTIES:String = "properties";
        private static const DELTA:String = "delta";
        private static const _templeteGridData:Object={from: {"scaleX": 0, "scaleY": 0, "alpha": 0, "rotation": 0, "x": 0, "y": 0}, properties: {"scaleX": 0, "scaleY": 0, "repeatCount": 0, "reverse": true, "alpha": 0, "rotation": 0, "x": 0, "y": 0, "transition": Transitions.LINEAR}, delta: {"scaleX": 0, "scaleY": 0, "alpha": 0, "rotation": 0, "x": 0, "y": 0}};
        /**origin data*/
        private var _editData:Object;
        private var _fromDataGrid:KeyValueDataGrid;
        private var _propertiesDataGrid:KeyValueDataGrid;
        private var _deltaDataGrid:KeyValueDataGrid;
        private var _timeInput:TextInput;
        public var onComplete:Function;

        public function TweenSettingPanel(editData:Object)
        {
            this._editData=editData;
            super();
        }

        override protected function createContent(container:LayoutGroup):void
        {
            var closeBtn:Button=FeathersUIUtil.buttonWithLabel("X", onClose);
            closeBtn.width=40;
            this.headerProperties.rightItems=new <DisplayObject>[closeBtn];

            var fromLayout:LayoutGroup=FeathersUIUtil.layoutGroupWithHorizontalLayout();
            var fromLabel:Label=FeathersUIUtil.labelWithText("         from:");
            fromLayout.addChild(fromLabel);
            _fromDataGrid=new KeyValueDataGrid();
            fromLayout.addChild(_fromDataGrid);
            _fromDataGrid.width=200;
            _fromDataGrid.dataTemplate=_templeteGridData.from;
            addChild(fromLayout);

            var propLayout:LayoutGroup=FeathersUIUtil.layoutGroupWithHorizontalLayout();
            var propLabel:Label=FeathersUIUtil.labelWithText("properties:");
            propLayout.addChild(propLabel);
            _propertiesDataGrid=new KeyValueDataGrid();
            propLayout.addChild(_propertiesDataGrid);
            _propertiesDataGrid.width=200;
            _propertiesDataGrid.dataTemplate=_templeteGridData.properties;
            addChild(propLayout);

            var deltaLayout:LayoutGroup=FeathersUIUtil.layoutGroupWithHorizontalLayout();
            var deltaLabel:Label=FeathersUIUtil.labelWithText("        delta:");
            deltaLayout.addChild(deltaLabel);
            _deltaDataGrid=new KeyValueDataGrid();
            deltaLayout.addChild(_deltaDataGrid);
            _deltaDataGrid.width=200;
            _deltaDataGrid.dataTemplate=_templeteGridData.delta;
            addChild(deltaLayout);

            var timeGroup:LayoutGroup=FeathersUIUtil.layoutGroupWithHorizontalLayout();
            var timelabel:Label=FeathersUIUtil.labelWithText("time");
            _timeInput=new TextInput();
            _timeInput.width=100;
            _timeInput.restrict="0-9.";
            timeGroup.addChild(timelabel);
            timeGroup.addChild(_timeInput);
            addChild(timeGroup);
            var group:LayoutGroup=FeathersUIUtil.layoutGroupWithHorizontalLayout();
            var yesButton:Button=FeathersUIUtil.buttonWithLabel("Save", onYes);
            var noButton:Button=FeathersUIUtil.buttonWithLabel("Cancel", onCanel);
            group.addChild(yesButton);
            group.addChild(noButton);

            this.footerFactory=function():Header
            {
                var header:Header=new Header();
                header.styleName=Header.DEFAULT_CHILD_STYLE_NAME_TITLE;
                header.centerItems=new <DisplayObject>[group];
                return header;
            }
            if (_editData != null)
                readObject(_editData);
        }

        private function onClose(e:Event):void
        {
            onCanel(null);
        }

        /**
         *  analytic data
         */
        private function readObject(o:Object):void
        {
            if (o.hasOwnProperty(FROM))
            {
                readFrom(o[FROM]);
            }
            if(o.hasOwnProperty(PROPERTIES))
            {
                readProperties(o[PROPERTIES]);
            }
            if(o.hasOwnProperty(DELTA))
            {
                readDela(o[DELTA]);
            }
            if (o.time != undefined)
                _timeInput.text=o.time.toString();
        }

        /**
         * properties data
         */
        private function readProperties(properties:Object):void
        {
            _propertiesDataGrid.data=properties;
        }

        /**
         *delta data
         */
        private function readDela(delta:Object):void
        {
            _deltaDataGrid.data=delta;
        }

        /**
         * from data
         */
        private function readFrom(from:Object):void
        {
            _fromDataGrid.data=from;
        }

        private function onYes(e:Event):void
        {
            if (hasThing(_fromDataGrid.data) == false && hasThing(_propertiesDataGrid.data) == false && hasThing(_deltaDataGrid.data) == false || (_timeInput.text == null || _timeInput.text == ""))
            {
                Alert.show("no data", "warning", new ListCollection([{label: "OK"}]));
                return;
            }

            if (_editData == null)
                _editData=new Object();
            if (hasThing(_fromDataGrid.data) == true)
            {
                _editData.from=_fromDataGrid.data;
            }
            else
            {
                delete _editData.from;
            }
            if (hasThing(_propertiesDataGrid.data) == true)
            {
                _editData.properties=_propertiesDataGrid.data;
            }
            else
            {
                delete _editData.properties;
            }
            if (hasThing(_deltaDataGrid.data) == true)
            {
                _editData.delta=_deltaDataGrid.data;
            }
            else
            {
                delete _editData.delta;
            }

            _editData.time=_timeInput.text;
            if (onComplete != null)
                onComplete.call(this, _editData);
            onCanel(null);
        }

        /**
         * judge if object has data
         */
        private function hasThing(obj:Object):Boolean
        {
            var bol:Boolean=false;
            if (obj == null)
                return bol;
            for (var key:Object in obj)
            {
                bol=true;
            }
            return bol;
        }

        private function onCanel(e:Event):void
        {
            if (PopUpManager.isPopUp(this))
            {
                PopUpManager.removePopUp(this);
            }
        }

    }
}
