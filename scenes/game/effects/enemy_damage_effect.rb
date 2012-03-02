require 'dxruby'

class EnemyDamageEffect < EffectBase
  def initialize(director, x, y, enemy,image_file_name=nil)
    super(director, x, y)

    @image_file = image_file_name || File.join(File.dirname(__FILE__), "..", "images", "enemy_crashed.png")
    p @image_file
    @image = Image.load(@image_file)
    # @image.setColorKey([0, 255, 0])
    @counter = 0
    @enemy = enemy
    @sound = Sound.new("scenes/game/effects/sound/sound3.wav")
    @sound.setVolume(150)
  end

  def move
    @sound.play
  end

  def draw
    if @counter <= 10
      if @counter / 2 % 2 == 1
        Window.drawEx(@enemy.x, @enemy.y,@image, :angle=>(@enemy.instance_of?(Enemy5)?@enemy.rot : 0 ), :blend=>:add)  

      else
        Window.drawEx(@enemy.x, @enemy.y,@image, :angle=>(@enemy.instance_of?(Enemy5)?@enemy.rot : 0) )  
        # Window.draw(@enemy.x, @enemy.y, @image)
      end
      @counter += 1
    else
      @enemy.damaged = false
      remove
    end
  end
end
