require 'fox16'
include Fox

class Settings < FXDialogBox
  def initialize(owner)
    # Invoke base class initialize function first
    super(owner, "Settings", DECOR_TITLE|DECOR_BORDER)

    # Bottom buttons
    buttons = FXHorizontalFrame.new(self,
      LAYOUT_SIDE_BOTTOM|FRAME_NONE|LAYOUT_FILL_X|PACK_UNIFORM_WIDTH,
      :padLeft => 40, :padRight => 40, :padTop => 20, :padBottom => 20)

    # Separator
    FXHorizontalSeparator.new(self,
      LAYOUT_SIDE_BOTTOM|LAYOUT_FILL_X|SEPARATOR_GROOVE)

    # Contents
    contents = FXHorizontalFrame.new(self,
      LAYOUT_SIDE_TOP|FRAME_NONE|LAYOUT_FILL_X|LAYOUT_FILL_Y|PACK_UNIFORM_WIDTH)

    submenu = FXMenuPane.new(self)
    FXMenuCommand.new(submenu, "One")
    FXMenuCommand.new(submenu, "Two")
    FXMenuCommand.new(submenu, "Three")

    # Menu
    menu = FXMenuPane.new(self)
    FXMenuCommand.new(menu, "&Accept", nil, self, ID_ACCEPT)
    FXMenuCommand.new(menu, "&Cancel", nil, self, ID_CANCEL)
    FXMenuCascade.new(menu, "Submenu", nil, submenu)
    FXMenuCommand.new(menu, "&Quit\tCtl-Q", nil, getApp(), FXApp::ID_QUIT)

    # Popup menu
    pane = FXPopup.new(self)
    %w{One Two Three Four Five Six Seven Eight Nine Ten}.each do |s|
      FXOption.new(pane, s, :opts => JUSTIFY_HZ_APART|ICON_AFTER_TEXT)
    end

    # Option menu
    FXOptionMenu.new(contents, pane, (FRAME_RAISED|FRAME_THICK|
      JUSTIFY_HZ_APART|ICON_AFTER_TEXT|LAYOUT_CENTER_X|LAYOUT_CENTER_Y))

    # Button to pop menu
    FXMenuButton.new(contents, "&Menu", nil, menu, (MENUBUTTON_DOWN|
      JUSTIFY_LEFT|LAYOUT_TOP|FRAME_RAISED|FRAME_THICK|ICON_AFTER_TEXT|
      LAYOUT_CENTER_X|LAYOUT_CENTER_Y))

    # Accept
    accept = FXButton.new(buttons, "&Accept", nil, self, ID_ACCEPT,
      FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)

    # Cancel
    FXButton.new(buttons, "&Cancel", nil, self, ID_CANCEL,
      FRAME_RAISED|FRAME_THICK|LAYOUT_RIGHT|LAYOUT_CENTER_Y)

    accept.setDefault
    accept.setFocus
  end
end
