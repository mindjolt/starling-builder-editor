# Starling Builder Release Notes:

## 0.8.7
* [editor] Implement FilesTab to be able to quickly open layout files in a specific path
* [editor] Implement multiple resolution support for TestPanel
* [editor] Implement fitBackground in BackgroundTab and TestPanel
* [extensions] Fix bug of pixel mask not working correctly with starling 1.7+ when stencil buffer is enabled (especially web build)
* [extensions] Fix interaction issue of FFParticleSprite
* [demo] Add pixelmask to demo project

## 0.8.6
* [editor] Implement workspace setting UI and save to settings/workspace_setting.json
* [editor] Change copy/paste shortcut to ctrl+c and ctrl+v
* [editor] Fix some DocumentManager focus issues
* [editor] Improve error handling
* [editor] Memory optimization
* [demo_workspace] Removed fonts folders by default, asset folders can be added through main menu -> workspace -> workspace setting

## 0.8.5
* [engine] Extends IAssetMediator to support getXml() and getObject()
* [engine] Support feathers.data.ListColletion and feathers.data.HierarchicalCollection
* [engine] Fixed that localization doesn’t work on external layout
* [template] Support dataProvider property for feathers Components
* [template] Support more feathers components: ButtonGroup, SpinnerList and TabBar
* [template] Add leading and batchable property to TextField
* [extensions] Reimplement ContainerButton
* [extensions] Integrate with FFParticleSystem through FFParticleSprite

## 0.8.4
* [engine] UIElementFactory set property order is now deterministic
* [engine] Add UIBuilder.findByTag()
* [editor] Fix performance problem when dragging UI component on canvas
* [editor] Arrow key UX improvement
* [editor] Localization and TweenBuilder implementation become configurable through editor_template.json
* [template] Add a tag field to customParams
* [extensions] Add new custom UI component: Gauge

## 0.8.3
* [engine] Add fromDelta field to DefaultTweenBuilder
* [engine] Add LayoutLoader.loadByClass()
* [engine] Add StageUtil.fitBackground() and StageUtil.fitNativeBackground()
* [editor] Added tween property editor to tween tab
* [template] Add scaleX and scaleY property for Scale3Image/Scale9Image/TiledImage

## 0.8.2
* [engine] Add LayoutLoader helper class
* [engine] Add ASDoc and documentation
* [editor] New UI components can be dragged to canvas
* [editor] Sort selectedObjects horizontally/vertically in PositionToolbar
* [editor] Add distribute horizontal/vertical buttons in PositionToolbar
* [editor] Add layout data compatibility check for Starling 2.0
* [editor] Add defaultHorizontalPivot and defaultVerticalPivot to SettingPopup
* [editor] Add shift key for multiple selection
* [editor] Fix ColorFilter limitation

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
