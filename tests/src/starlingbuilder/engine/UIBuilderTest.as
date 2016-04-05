/**
 * Created by hyh on 1/12/16.
 */
package starlingbuilder.engine
{
    import flash.utils.Dictionary;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertTrue;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.text.TextField;
    import starlingbuilder.engine.localization.MockLocalization;

    public class UIBuilderTest
    {
        private var _uiBuilder:UIBuilder;
        private var _assetMediator:MockAssetMediator;
        private var _localization:MockLocalization;

        private var _emptyLayout:Object = {
            "layout":{
                "children":[],
                "cls":"starling.display.Sprite",
                "customParams":{},
                "params":{
                    "name":"root"
                }
            }}

        private var _quadLayout:Object = {
            "layout":{
                "children":[
                    {
                        "cls":"starling.display.Quad",
                        "constructorParams":[
                            {
                                "type":"Number",
                                "value":50
                            },
                            {
                                "type":"Number",
                                "value":50
                            }
                        ],
                        "customParams":{},
                        "params":{
                            "color":6804084,
                            "name":"_quad",
                            "x":40,
                            "y":30
                        }
                    }
                ],
                "cls":"starling.display.Sprite",
                "customParams":{},
                "params":{
                    "name":"root"
                }
            },
            "setting":{
                "canvasSize":{
                    "x":640,
                    "y":960
                }
            },
            "version":"1.0"
        }

        private var _textLayout:Object = {
            "layout":{
                "children":[
                    {
                        "cls":"starling.text.TextField",
                        "constructorParams":[
                            {
                                "value":200
                            },
                            {
                                "value":100
                            },
                            {
                                "value":""
                            },
                            {
                                "name":"fontName",
                                "value":"Verdana"
                            },
                            {
                                "value":46
                            },
                            {
                                "value":16777215
                            }
                        ],
                        "customParams":{
                            "localizeKey":"hello"
                        },
                        "params":{
                            "color":2149253,
                            "fontName":"Verdana",
                            "fontSize":46,
                            "height":100,
                            "name":"text",
                            "width":200
                        }
                    }
                ],
                "cls":"starling.display.Sprite",
                "customParams":{},
                "params":{
                    "name":"root"
                }
            },
            "setting":{
                "canvasSize":{
                    "x":640,
                    "y":960
                }
            },
            "version":"1.0"
        }

        private var _externalLayout:Object = {
            "layout":{
                "children":[
                    {
                        "cls":"starling.display.Sprite",
                        "customParams":{
                            "source":"quad"
                        },
                        "params":{
                            "name":"quad"
                        }
                    }
                ],
                "cls":"starling.display.Sprite",
                "customParams":{},
                "params":{
                    "name":"root"
                }
            },
            "setting":{
                "canvasSize":{
                    "x":640,
                    "y":960
                }
            },
            "version":"1.0"
        }

        public function UIBuilderTest()
        {
        }

        [Before]
        public function setup():void
        {
            _assetMediator = new MockAssetMediator();
            _localization = new MockLocalization();
            _uiBuilder = new UIBuilder(_assetMediator, false, null, _localization);
        }

        [Test]
        public function shouldLoadEmptySprite():void
        {
            var res:Object = _uiBuilder.load(_emptyLayout);

            var data:Object = res.data;
            var object:DisplayObject = res.object;
            var params:Object = res.params;

            assertTrue(params is Dictionary);
            assertTrue(object is Sprite);
            assertEquals(object.name, "root");
            assertTrue(params is Dictionary);
            assertTrue(object in params);
        }

        [Test]
        public function shouldTrimLeadingSpace():void
        {
            var res:Object = _uiBuilder.load(_quadLayout);

            var data:Object = res.data;
            var object:DisplayObjectContainer = res.object;
            var params:Object = res.params;

            var quad:DisplayObject = object.getChildAt(0);
            assertEquals(object.numChildren, 1);
            assertTrue(quad is Quad);
            assertEquals(quad.width, 50);
            assertEquals(quad.height, 50);
            assertEquals(quad.x, 0);
            assertEquals(quad.y, 0);
        }

        [Test]
        public function shouldNotTrimLeadingSpace():void
        {
            var res:Object = _uiBuilder.load(_quadLayout, false);
            var object:DisplayObjectContainer = res.object;

            var quad:DisplayObject = object.getChildAt(0);
            assertEquals(quad.x, 40);
            assertEquals(quad.y, 30);
        }

        [Test]
        public function shouldLoadEditorSprite():void
        {
            var data:Object = UIBuilder.cloneObject(_quadLayout);
            data.layout.children[0].customParams.forEditor = true;

            _uiBuilder = new UIBuilder(_assetMediator, true);
            var sprite:Sprite = _uiBuilder.create(data) as Sprite;

            assertEquals(sprite.numChildren, 1);
        }

        [Test]
        public function shouldNotLoadEditorSprite():void
        {
            var data:Object = UIBuilder.cloneObject(_quadLayout);
            data.layout.children[0].customParams.forEditor = true;

            _uiBuilder = new UIBuilder(_assetMediator, false);
            var sprite:Sprite = _uiBuilder.create(data) as Sprite;

            assertEquals(sprite.numChildren, 0);
        }

        [Test]
        public function shouldLocalizeText():void
        {
            _localization.locale = "es_ES";
            _localization.expects("getLocalizedText").withArg("hello").willReturn("hola");

            var res:Object = _uiBuilder.load(_textLayout, false);

            var sprite:Sprite = res.object;
            var params:Dictionary = res.params;

            _uiBuilder.localizeTexts(sprite, params);

            var textField:TextField = sprite.getChildAt(0) as TextField;
            assertEquals(textField.text, "hola");
        }

        [Test]
        public function shouldLoadExternalLayout():void
        {
            _assetMediator.expects("getExternalData").withArg("quad").willReturn(_quadLayout);

            var sprite:Sprite = _uiBuilder.create(_externalLayout) as Sprite;

            var parentContainer:Sprite = sprite.getChildAt(0) as Sprite;
            var childRoot:Sprite = parentContainer.getChildAt(0) as Sprite;
            var quad:Quad = childRoot.getChildAt(0) as Quad;

            assertTrue(parentContainer is Sprite);
            assertTrue(childRoot is Sprite);
            assertTrue(quad is Quad);
            assertEquals(quad.name, "_quad");
        }

        [Test]
        public function shouldBind():void
        {
            var object:TestUIClass1 = new TestUIClass1();
            var sprite:Sprite = _uiBuilder.create(_quadLayout, true, object) as Sprite;

            assertTrue(object._quad != null);
            assertEquals(object._quad.width, 50);
            assertEquals(object._quad.height, 50);
        }

        [Test]
        public function shouldNotBind():void
        {
            var object:TestUIClass2 = new TestUIClass2();
            var sprite:Sprite = _uiBuilder.create(_textLayout, false, object) as Sprite;

            assertTrue(object.text == null);
        }
    }
}

import starling.display.Quad;
import starling.text.TextField;

class TestUIClass1
{
    public var _quad:Quad;
}

class TestUIClass2
{
    public var text:TextField;
}
