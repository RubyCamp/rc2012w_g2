require 'dxruby'

class EnemyCrashEffect < EffectBase
  def initialize(director, x, y, opts = {})
    super(director, x, y, opts)
    image_file = File.join(File.dirname(__FILE__), "..", "images", opts[:file] ? opts[:file] : "zako1_crashed.png")
    @image = Image.load(image_file)
    @image.setColorKey([0, 255, 0])
    @alpha = 255
    @speed = 3
    @sound = Sound.new("scenes/game/effects/sound/sound2.wav")
    @sound.setVolume(150)
  end

  def move
    if @alpha < 0
      remove
    end
      @sound.play
  end

  def draw
    Window.drawAlpha(@x, @y, @image, @alpha)
    @alpha -= @speed
  end
end
