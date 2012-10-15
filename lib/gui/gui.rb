require 'fox16'
include Fox

# Main Gui bootstrap
# Author: Andrei
# TODO : refactoring !

class Gui < FXMainWindow


  protected
  #create FXFont object

  def _create_font(weight = FONTWEIGHT_NORMAL)
    f = FXFontDesc.new()
    f.encoding = FONTENCODING_DEFAULT
    f.face = "Helvetica"
    f.flags = 0
    f.setwidth = FONTSETWIDTH_WIDE
    f.size = 200
    f.slant = FONTSLANT_REGULAR
    f.weight = weight

    return (f)
  end

  public
  # construct the FX app

  def initialize(app)
    @i = 1
    super(app, "Ftt YO", :width => 300, :height => 100)
    h_frame_1 = FXHorizontalFrame.new(self, :opts => LAYOUT_FIX_WIDTH|LAYOUT_FIX_HEIGHT ,:width => 300, :height => 45)
    h_frame_1_label = FXLabel.new(h_frame_1,"Task:")
    h_frame_1_label.font = FXFont.new(getApp(),_create_font())
    h_frame_1_text_field = FXTextField.new(h_frame_1,30, :opts => LAYOUT_FILL)
    v_frame_1 = FXVerticalFrame.new(self, :opts => LAYOUT_FILL)
    h_frame_2 = FXHorizontalFrame.new(v_frame_1)
    generate_button = FXButton.new(h_frame_2, "Start timer")
    setting_button = FXButton.new(h_frame_2, "Settings")
    @counter = FXLabel.new(h_frame_2,Time.at("#{@i}".to_i).gmtime.strftime('%R:%S'))
    @counter.hide
    @bar = FXProgressBar.new(self, :opts => PROGRESSBAR_NORMAL | LAYOUT_FILL_X)
    generate_button.connect(SEL_COMMAND) do |sender, selector, data|
      @counter.show
      @counter.recalc
      getApp().addTimeout(1000, method(:onTimeout))
    end

  end

  def onTimeout(sender, sel, ptr)
    puts @i = @i + 1
    @counter.text = Time.at("#{@i}".to_i).gmtime.strftime('%R:%S')
    getApp().addTimeout(1000, method(:onTimeout))
  end

  #create (display) the FX app
  def create
    super
    #getApp().addTimeout(80, method(:onTimeout))
    show(PLACEMENT_SCREEN)
  end
end