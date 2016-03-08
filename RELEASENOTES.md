# Starling Builder Release Notes:

## 0.8.1
* [editor] Add filter support (BlurFilter, GlowFilter, DropShadowFilter, ColorFilter)
* [editor] Implement canvas snapshot
* [editor] New UI element position will default to center of the canvas
* [editor] Replace hidden and lock check to icons
* [editor] Upgrade to Starling 1.8 and AIR19
* [editor] Add default_option to texture_options.json
* [editor] Various bug fixes
* [template] Add scaleWhenDown property to starling.display.Button
* [extensions] Add a universal ContainerButton (A customized button you can add whatever you want inside. You need to download the new latest demo_workspace.zip to try it)

## 0.8.0
* [editor] Multiple selection support
* [editor] Multiple objects positioning tools
* [editor] Display object property can set Image/Scale3/Scale9/TiledImage
* [editor] Vertical arrow slide for fields like y
* [editor] Canvas color picker
* [editor] Add pretty/minimized JSON option to setting popup
* [editor] Various bug fixes
* [engine] Add delta field to DefaultTweenBuilder to support position offset tween
* [template] Add blendMode to all components, add textureScale to Scale3Image/Scale9Image/TiledImage

## 0.7.2
* [editor] Image, Button, Scale3Image, Scale9Image, TiledImage can change texture after creation

## 0.7.1
* [engine] Implement LocalizationHandler
* [editor] Persist hidden and lock flag to layout
* [template] Add backgroundSkin property to LayoutGroup, add layout property to Panel

## 0.7.0
* [engine] Add TweenBuilder support
* [editor] Add Tween preview tab
* [editor] Implement Unity liked slidable label
* [editor] Add explicit check box for feathers components
* [editor] Support more feathers layouts and components
* [editor] Various bug fixes

## 0.6.8
* [editor] Fix bug: open recent with dirty file override the newly open file
* [editor] Layout tab support drag and drop
* [editor] Right panel becomes scrollable
* [editor] Implement help button for quick documentation lookup

## 0.6.7
* [editor] Fix bug: theme pollution issue with EmbeddedTheme.swf
* [editor] add a drag box to be able to move container with 0 width and height on canvas
* [editor] Icon function will keep width/height ratio in IconItemRenderer

## 0.6.6
* [engine] Add helper function: UIBuilder.find()
* [engine] Better error detection when texture is not found
* [editor] Fix bug: link button not working sometimes
* [editor] Implement new link button
* [editor] Fix bug: customParams not setting value if there's no initial value

## 0.6.5
* [editor] Upgrade to Starling 1.7 and Feathers UI 2.3
* [editor] Collapsable layout tree component
* [editor] Collapsable asset group list component
* [editor] HD support for Macbook retina display
* [editor] Fix asian language characters not able to type in with input method
* [editor] Various bug fixes

## 0.6.2
* [engine] property won’t be saved when read-only flag is set
* [engine] text won’t be saved when localizedKey is set
* [editor] big performance improvement when selecting elements
* [editor] support Sprite3D and MovieClip
* [editor] group assets by atlases
* [editor] fix rotation issue when scale = 1

## 0.5.4
* [editor] Fix load external layout bug
* [editor] Fix bad delete shortcut on Windows

## 0.5.3
* [editor] Add Feathers tab to left panel
* [editor] Support more Feathers components

## 0.5.2
* First version
