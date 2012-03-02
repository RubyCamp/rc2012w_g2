require 'dxruby'

class BossCrashEffect < EnemyCrashEffect
  def initialize(director, x, y, opts={})
    super(director, x, y, opts)
    image_file = File.join(File.dirname(__FILE__), "..", "images", "big_boss.png")
    @image = Image.load(image_file)
    # @image.setColorKey([0, 255, 0])
    @alpha = 255
    @speed = 1
  end
  
  def move
    @alpha -= @speed
    if @alpha < 0
      remove
      Scene.set_current_scene(:ending)
      @director.game_sound_bgm.stop
    end

  end
  
  def draw
    d = 255 - @alpha
    Window.drawMorph(
                     @x+@image.width+d/2, @y+d/3,
                     @x-d/2, @y+d/3,
                     @x-d/2, @y+@image.height-d/3,
                     @x+@image.width+d/2, @y+@image.height-d/3,
                     @image, :alpha =>@alpha)
  end
end
