package starlingbuilder.editor.ui
{
    import feathers.controls.Alert;
    import feathers.controls.Button;
    import feathers.controls.Header;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.List;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.core.PopUpManager;
    import feathers.data.ListCollection;
    import feathers.layout.VerticalLayout;
    
    import starling.display.DisplayObject;
    import starling.events.Event;
    
    import starlingbuilder.engine.format.StableJSONEncoder;
    import starlingbuilder.util.feathers.FeathersUIUtil;
    import starlingbuilder.util.feathers.popup.InfoPopup;

    public class TweenSettingListPanel extends InfoPopup
    {
        private var _editData:Object;
        private var _tweenList:List;
        public var onComplete:Function;

        public function TweenSettingListPanel(editData:Object)
        {
            this._editData=editData;
            super();
            title="Tween Property Editor";
        }

        override protected function createContent(container:LayoutGroup):void
        {
            container.visible = false;
            var closeBtn:Button=FeathersUIUtil.buttonWithLabel("X", onClose);
            closeBtn.width=40;
            this.headerProperties.rightItems=new <DisplayObject>[closeBtn];

            var btnLayout:LayoutGroup=FeathersUIUtil.layoutGroupWithHorizontalLayout();
            var addBtn:Button=FeathersUIUtil.buttonWithLabel("add", onAdd);
            _deleteBtn=FeathersUIUtil.buttonWithLabel("delete", onDelete);
            _deleteBtn.isEnabled=false;
            _editBtn=FeathersUIUtil.buttonWithLabel("edit", onEdit);
            _editBtn.isEnabled=false;
            btnLayout.addChild(addBtn);
            btnLayout.addChild(_deleteBtn);
            btnLayout.addChild(_editBtn);
            addChild(btnLayout);

            var v:VerticalLayout=new VerticalLayout();
            v.gap=1;
            v.hasVariableItemDimensions=true;
            v.horizontalAlign=VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
            _tweenList=new List();
            _tweenList.width=380;
            _tweenList.height=320;
            _tweenList.horizontalScrollPolicy=List.SCROLL_POLICY_OFF;
            _tweenList.layout=v;
            addChild(_tweenList);

            _tweenList.addEventListener(Event.CHANGE, onTweenListChange);
            _tweenList.itemRendererFactory=function():IListItemRenderer
            {
                var renderer:DefaultListItemRenderer=new DefaultListItemRenderer();
                renderer.labelField="text";
                renderer.labelFactory=function():Label
                {
                    var label:Label=new Label();
                    label.styleName=Label.ALTERNATE_STYLE_NAME_HEADING;
                    label.wordWrap=true;
                    label.validate();
                    return label;
                }
                renderer.validate();
                return renderer;
            }
            _tweenList.dataProvider=new ListCollection();
            var str:String;
            if (_editData != null)
            {
                if (_editData.length > 1)
                {
                    for (var i:int=0; i < _editData.length; ++i)
                    {
                        str=StableJSONEncoder.stringify(_editData[i]);
                        _tweenList.dataProvider.addItem({text: str});
                    }
                }
                else
                {
                    str=StableJSONEncoder.stringify(_editData);
                    _tweenList.dataProvider.addItem({text: str});
                }
            }

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
        }

        private var _index:int;
        private var _tweenStr:String;
        private var _deleteBtn:Button;
        private var _editBtn:Button;

        private function onTweenListChange(e:Event):void
        {
            if (_tweenList.selectedItem == null)
                return;
            if (_tweenList.selectedIndex == -1)
                _tweenList.selectedIndex=_index;
            _index=_tweenList.selectedIndex;
            _tweenStr=_tweenList.selectedItem.text;
            _deleteBtn.isEnabled=true;
            _editBtn.isEnabled=true;
        }

        private function onAdd(e:Event):void
        {
            var tweenPanel:TweenSettingPanel=new TweenSettingPanel(null);
            tweenPanel.onComplete=onComplete;
            PopUpManager.addPopUp(tweenPanel);

            function onComplete(data:Object):void
            {
                var str:String=StableJSONEncoder.stringify(data);
                _tweenList.dataProvider.addItem({text: str});
            }
        }

        private function onDelete(e:Event):void
        {
            Alert.show("delete this item ?", "warning", new ListCollection([{label: "Ok", triggered: onOk}, {label: "Cancel"}]));
            function onOk(e:Event):void
            {
                _tweenList.dataProvider.removeItemAt(_index);
            }
        }

        private function onEdit(e:Event):void
        {
            var editData:Object=JSON.parse(_tweenStr);
            var tweenPanel:TweenSettingPanel=new TweenSettingPanel(editData);
            tweenPanel.onComplete=onComplete;
            PopUpManager.addPopUp(tweenPanel);

            function onComplete(data:Object):void
            {
                var str:String=StableJSONEncoder.stringify(data);
                _tweenList.dataProvider.setItemAt({text: str}, _index);
            }

        }

        private function onClose(e:Event):void
        {
            onCanel(null);
        }

        private function onYes(e:Event):void
        {
            var resultData:Object=null;
            var str:String;
            if (_tweenList.dataProvider.length == 1)
            {
                str=_tweenList.dataProvider.getItemAt(i).text;
                resultData=JSON.parse(str);
            }
            else if (_tweenList.dataProvider.length > 1)
            {
                resultData=new Array();
                for (var i:int=0; i < _tweenList.dataProvider.length; ++i)
                {
                    str=_tweenList.dataProvider.getItemAt(i).text;
                    resultData[i]=JSON.parse(str);
                }
            }
            if (onComplete != null)
                onComplete.call(this, resultData);
            onCanel(null);
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
