class Character
  attr_accessor :collision, :x, :y
  attr_reader :image
  
  def initialize(director, x = 400, y = 550, image_file = nil,parameters={},collision_margin=0)
    @crashed    = false
    @director   = director
    @x, @y      = x, y
    @image      = char_image(image_file)
    @distance   = 2
    @parameters = parameters
    @collision  = CollisionBox.new(
                                   self, 
                                   collision_margin,
                                   collision_margin,
                                   @image.width-collision_margin, @image.height-collision_margin)
  end

  def move
  end                 

  def draw
    Window.draw(@x, @y, @image)
  end

  private

  def reset_collision_pos
    self.collision.set(@x, @y)
  end

  def valid_x_range?(dx=0)
    !((@x + dx +  Game::HORIZONAL_MARGIN) > Window.width   || (@x + dx + @image.width - Game::HORIZONAL_MARGIN) < 0)
  end

  def valid_y_range?(dy=0)
    !((@y + dy  ) > Window.height || (@y + dy + @image.height) < 0)
  end
end
