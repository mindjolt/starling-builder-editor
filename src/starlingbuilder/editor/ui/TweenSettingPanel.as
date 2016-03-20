package starlingbuilder.editor.ui
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.Label;
	import feathers.controls.LayoutGroup;
	import feathers.controls.Panel;
	import feathers.controls.TextInput;
	import feathers.core.PopUpManager;
	import feathers.layout.VerticalLayout;
	
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.events.Event;
	
	import starlingbuilder.util.feathers.FeathersUIUtil;
	import starlingbuilder.util.feathers.KeyValueDataGrid;
	
	public class TweenSettingPanel extends Panel
	{
		/**原始数据*/
		private var _editData:Object;
		private var _fromDataGrid:KeyValueDataGrid;
		private var _propertiesDataGrid:KeyValueDataGrid;
		private var _deltaDataGrid:KeyValueDataGrid;
		private var _timeInput:TextInput;
		public var onComplete:Function;
		
		public function TweenSettingPanel(editData:Object)
		{
			super();
			
			this._editData = editData;
		}
		
		override protected function initialize():void
		{
			super.initialize();
			var layout:VerticalLayout = new VerticalLayout();
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_TOP;
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_CENTER;
			layout.gap = 5;
			layout.paddingTop = 15;
			layout.paddingLeft = 20;
			layout.paddingBottom = 20;
			this.width = 480;
			this.height = 480;
			this.backgroundSkin = new Quad(480, 480, 0x333333);
			this.layout = layout;
			
			var closeBtn:Button = FeathersUIUtil.buttonWithLabel("X", onClose);
			closeBtn.width = 40;
			this.headerProperties.rightItems = new <DisplayObject>[closeBtn];
			
			var fromLayout:LayoutGroup = FeathersUIUtil.layoutGroupWithHorizontalLayout();
			var fromLabel:Label = FeathersUIUtil.labelWithText("         from:");
			fromLayout.addChild(fromLabel);
			_fromDataGrid = new KeyValueDataGrid();
			fromLayout.addChild(_fromDataGrid);
			_fromDataGrid.width = 200;
			_fromDataGrid.dataTemplate = 
				{
					"scaleX":  0, 
					"scaleY": 0,
					"repeatCount": 0, 
					"reverse": true,
					"alpha": 0, 
					"rotation": 0,
					"x": 0,
					"y": 0
				};
			addChild(fromLayout);
			
			var propLayout:LayoutGroup = FeathersUIUtil.layoutGroupWithHorizontalLayout();
			var propLabel:Label = FeathersUIUtil.labelWithText("properties:");
			propLayout.addChild(propLabel);
			_propertiesDataGrid = new KeyValueDataGrid();
			propLayout.addChild(_propertiesDataGrid);
			_propertiesDataGrid.width = 200;
			_propertiesDataGrid.dataTemplate = 
				{
					"scaleX":  0, 
					"scaleY": 0,
					"repeatCount": 0, 
					"reverse": true,
					"alpha": 0, 
					"rotation": 0,
					"x": 0,
					"y": 0
				};
			addChild(propLayout);
			
			var deltaLayout:LayoutGroup = FeathersUIUtil.layoutGroupWithHorizontalLayout();
			var deltaLabel:Label = FeathersUIUtil.labelWithText("        delta:");
			deltaLayout.addChild(deltaLabel);
			_deltaDataGrid = new KeyValueDataGrid();
			deltaLayout.addChild(_deltaDataGrid);
			_deltaDataGrid.width = 200;
			_deltaDataGrid.dataTemplate = 
				{
					"scaleX":  0, 
					"scaleY": 0,
					"repeatCount": 0, 
					"reverse": true,
					"alpha": 0, 
					"rotation": 0,
					"x": 0,
					"y": 0
				};
			addChild(deltaLayout);
			
			var timeGroup:LayoutGroup = FeathersUIUtil.layoutGroupWithHorizontalLayout();
			var timelabel:Label = FeathersUIUtil.labelWithText("time");
			_timeInput = new TextInput();
			_timeInput.width = 100;
			_timeInput.restrict = "0-9.";
			timeGroup.addChild(timelabel);
			timeGroup.addChild(_timeInput);
			addChild(timeGroup);
			var group:LayoutGroup = FeathersUIUtil.layoutGroupWithHorizontalLayout();
			var yesButton:Button = FeathersUIUtil.buttonWithLabel("Save", onYes);
			var noButton:Button = FeathersUIUtil.buttonWithLabel("Cancel", onCanel);
			group.addChild(yesButton);
			group.addChild(noButton);
			
			this.footerFactory = function():Header
			{
				var header:Header = new Header();
				header.styleName = Header.DEFAULT_CHILD_STYLE_NAME_TITLE;
				header.centerItems = new <DisplayObject>[group];
				return header;
			}
			if(_editData != null)
				readObject(_editData);
		}
		
		private function onClose(e:Event):void
		{
			onCanel(null);
		}
		
		/**
		 * 解析数据
		 */
		private function readObject(o:Object):void
		{
			if(o.from != undefined)
				readFrom(o.from);
			
			if(o.properties != undefined)
				readProperties(o.properties);
			
			if(o.delta != undefined)
				readDela(o.delta);
			
			if(o.time != undefined)
				_timeInput.text = o.time.toString();
		}
		/**
		 * properties数据
		 */
		private function readProperties(properties:Object):void
		{
			_propertiesDataGrid.data = properties;
		}
		/**
		 *delta数据
		 */
		private function readDela(delta:Object):void
		{
			_deltaDataGrid.data = delta;
		}
		
		/**
		 * from数据
		 */
		private function readFrom(from:Object):void
		{
			_fromDataGrid.data = from;
		}
		
		private function onYes(e:Event):void
		{
			if(hasThing(_fromDataGrid.data)== true)
			{
//				trace("from="+_fromDataGrid.data);
				_editData.from = _fromDataGrid.data;
			}
			if(hasThing(_propertiesDataGrid.data) == true)
			{
//				trace("properties="+_propertiesDataGrid.data);
				_editData.properties = _propertiesDataGrid.data;
			}
			if(hasThing(_deltaDataGrid.data) == true)
			{
//				trace("delta="+_deltaDataGrid.data);
				_editData.delta = _deltaDataGrid.data;
			}
			_editData.time = _timeInput.text;
			if(onComplete != null)
				onComplete.call(this, _editData);
			onCanel(null);
		}
		
		/**
		 * 判断object是否有值
		 */
		private function hasThing(obj:Object):Boolean
		{
			var bol:Boolean = false;
			if(obj == null)
				return bol;
			for(var key:Object in obj)
			{
				bol = true;
			}        
			return bol;
		}
		
		private function onCanel(e:Event):void
		{
			if(PopUpManager.isPopUp(this))
			{
				PopUpManager.removePopUp(this);
			}
		}
		
	}
}