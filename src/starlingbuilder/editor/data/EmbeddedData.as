/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.editor.data
{
    public class EmbeddedData
    {
        [Embed(source="editor_template.json", mimeType="application/octet-stream")]
        public static const editor_template:Class;

        [Embed(source="texture_options.json", mimeType="application/octet-stream")]
        public static const texture_options:Class;

        [Embed(source="workspace_setting.json", mimeType="application/octet-stream")]
        public static const workspace_setting:Class;
    }
}
