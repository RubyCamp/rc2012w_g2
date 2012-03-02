class EffectBase
  attr_accessor :collision

  def initialize(director, x, y, opts = {})
    @director = director
    @x = x
    @y = y
    # image_file = "images/effect.png"
    # chip_size=32
    # temp = Image.load(image_file)
    # chip_width = temp.width / chip_size
    # chip_height = temp.height / chip_size
    # @images = Image.loadToArray(image_file, chip_width, chip_height)
    # @images = @images.map{|i| i.setColorKey([0,0,0])}
    # @counter = 0.0
  end

  def move
  end

  def remove
    @director.effects.delete_if{|e| e == self }
  end

  def draw
    Window.draw(@x, @y, @image)
  end
end
