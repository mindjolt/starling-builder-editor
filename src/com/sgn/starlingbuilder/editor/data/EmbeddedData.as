/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package com.sgn.starlingbuilder.editor.data
{
    public class EmbeddedData
    {
        public function EmbeddedData()
        {
        }

        [Embed(source="editor_template.json", mimeType="application/octet-stream")]
        public static const editor_template:Class;

        [Embed(source="horizontal_arrows.png")]
        public static const horizontal_arrows:Class;
        public static const HORIZONTAL_ARROWS:String = "horizontal_arrows";

    }
}
