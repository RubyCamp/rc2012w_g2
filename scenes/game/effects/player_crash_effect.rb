# -*- coding: cp932 -*-
require 'dxruby'

class PlayerCrashEffect < EffectBase
  def initialize(director, x, y, opts = {})
    super(director, x, y, opts = {})
    image_file = File.join(File.dirname(__FILE__), "..", "images", "new_player.png")
    @image = Image.load(image_file)
    @image.setColorKey([0, 255, 0])
    @timer   = 0
    @counter = 0
    # @crush_x = x
    # @crush_y = y
    @timer = 3
  end
  
  def move
  end
  
  def draw
    if @counter <= 60*@timer  # 最初の数秒は点滅
      if @counter/10 % 2 == 1
        Window.draw(@director.player.x, @director.player.y, @image)
      end
    else
      @director.is_player_crashing = false
      remove
      # @director.effects.delete_if {|effect| effect == self }
      # Scene.set_current_scene(:gameover)
    end
    @counter += 1

  end
end
