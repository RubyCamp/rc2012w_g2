require_relative 'character'

class PlayerShot < Character

  def move
    @y -= 30
    reset_collision_pos
    remove if @y < -@image.height
  end

  def remove
    #puts "delete"
    @director.shots.delete_if {|shot| shot == self }
  end

  def hit(obj)
    return unless obj.is_a?(Enemy)
    obj.hit(self)
#    if(obj.life > 0)
#      obj.dec_life
#    end
#    obj.crash
    remove
  end


  private

  def char_image(image_file = nil)
    image_file ||= File.join(File.dirname(__FILE__), "..", "images", "player_shot2.png")
    img = Image.load(image_file)
    img.setColorKey([0, 0, 0])
    return img
  end
end
