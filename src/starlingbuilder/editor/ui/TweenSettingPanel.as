package starlingbuilder.editor.ui
{
    import flash.utils.Dictionary;

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
        public static const TIME:String = "time";
        private static const TEMPLATE_GRID_DATA:Object=
        {
            properties: {scaleX:0, scaleY:0, repeatCount:0, reverse:true, delay:0, alpha:0, rotation:0, x:0, y: 0, transition:Transitions.LINEAR},
            from: {scaleX:0, scaleY:0, alpha:0, rotation:0, x:0, y:0},
            delta: {scaleX:0, scaleY:0, alpha:0, rotation:0, x:0, y:0},
            fromDelta: {scaleX:0, scaleY:0, alpha:0, rotation:0, x:0, y:0}
        };


        /**origin data*/
        private var _editData:Object;
        private var _dataGridDic:Dictionary=new Dictionary();
        private var _timeInput:TextInput;
        public var onComplete:Function;

        public function TweenSettingPanel(editData:Object)
        {
            this._editData=editData;
            super();
            title = "Edit Tween Property";
        }

        override protected function createContent(container:LayoutGroup):void
        {
            var closeBtn:Button=FeathersUIUtil.buttonWithLabel("X", onClose);
            closeBtn.width=40;
            this.headerProperties.rightItems=new <DisplayObject>[closeBtn];

            for (var key:String in TEMPLATE_GRID_DATA)
            {
                var layout:LayoutGroup=FeathersUIUtil.layoutGroupWithHorizontalLayout();
                var label:Label=FeathersUIUtil.labelWithText(key + ":");
                layout.addChild(label);
                var dataGrid:KeyValueDataGrid=new KeyValueDataGrid();
                layout.addChild(dataGrid);
                dataGrid.width=200;
                dataGrid.dataTemplate=TEMPLATE_GRID_DATA[key];
                addChild(layout);
                _dataGridDic[key]=dataGrid;
            }

            var timeGroup:LayoutGroup=FeathersUIUtil.layoutGroupWithHorizontalLayout();
            var timelabel:Label=FeathersUIUtil.labelWithText(TIME);
            _timeInput=new TextInput();
            _timeInput.width=100;
            _timeInput.restrict="0-9.";
            timeGroup.addChild(timelabel);
            timeGroup.addChild(_timeInput);
            addChild(timeGroup);
            _dataGridDic[TIME]=_timeInput;
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
            for (var key:String in o)
            {
                //time is special
                    if (_dataGridDic[key] != null && key != TIME)
                {
                    (_dataGridDic[key] as KeyValueDataGrid).data=o[key];
                }
                else if (key == TIME)
                {
                    (_dataGridDic[key] as TextInput).text=o.time.toString();
                }
            }
        }

        private function onYes(e:Event):void
        {
            if (_editData == null)
                _editData=new Object();
            for (var key:String in _dataGridDic)
            {
                if (key != TIME)
                {
                    if (hasThing(_dataGridDic[key].data) == true)
                    {
                        _editData[key]=_dataGridDic[key].data;
                    }
                    else
                    {
                        delete _editData[key];
                    }
                }
            }
            if ((_timeInput.text == null || _timeInput.text == ""))
            {
                Alert.show("Please input time", "warning", new ListCollection([{label: "OK"}]));
                return;
            }
            _editData.time=Number(_timeInput.text);
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
                PopUpManager.removePopUp(this, true);
            }
        }

    }
}
