/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.util.loader
{
    import org.flexunit.asserts.assertTrue;

    import starlingbuilder.engine.LayoutLoader;

    public class LayoutLoaderTest
    {
        private var _layoutLoader:LayoutLoader;

        [Before]
        public function setup():void
        {
            ParsedLayout.hello1 = null;
            ParsedLayout.hello2 = null;
        }

        [Test]
        public function shouldWorkWithPreload():void
        {
            _layoutLoader = new LayoutLoader(EmbeddedLayout, ParsedLayout);

            assertTrue(ParsedLayout.hello1 != null);
            assertTrue(ParsedLayout.hello2 != null);
        }

        [Test]
        public function shouldWorkWithoutPreload():void
        {
            _layoutLoader = new LayoutLoader(EmbeddedLayout, ParsedLayout, false);

            assertTrue(ParsedLayout.hello1 == null);
            assertTrue(ParsedLayout.hello2 == null);

            var hello1:Object = _layoutLoader.load("hello1");
            var hello2:Object = _layoutLoader.loadByClass(EmbeddedLayout.hello2)

            var hello3:Object = _layoutLoader.load("hello1");
            var hello4:Object = _layoutLoader.loadByClass(EmbeddedLayout.hello2);

            assertTrue(ParsedLayout.hello1 != null);
            assertTrue(ParsedLayout.hello2 != null);

            assertTrue(hello1 === ParsedLayout.hello1);
            assertTrue(hello2 === ParsedLayout.hello2);

            assertTrue(hello1 === hello3);
            assertTrue(hello2 === hello4);
        }
    }
}


class EmbeddedLayout
{
    [Embed(source="hello.json", mimeType="application/octet-stream")]
    public static const hello1:Class;

    [Embed(source="hello.json", mimeType="application/octet-stream")]
    public static const hello2:Class;
}


class ParsedLayout
{
    public static var hello1:Object;

    public static var hello2:Object;
}
