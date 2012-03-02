require_relative 'character'

class Enemy4 < Enemy
  RADIUS = 5
  def initialize(director,x=300,y=550,image_file=nil,parameters)
    super(
          director,
          x,
          y,
          image_file ||  File.join(File.dirname(__FILE__), "..", "images", "zako2.png"),
          parameters)
    @frame = 0
    @life  = 20
  end

  def move
    @x += rand(1) + (1/2)
    @y += rand(1) + (1/2)
    reset_collision_pos
    if @frame%100 == 1
      @director.shots << EnemyShot.new(@director,@x,@y,nil,{},13)
    end
    @frame += 1
  end

  def damage
    if !@damaged
      @damaged = true
      damage_effect = EnemyDamageEffect.new(@director, @x, @y, self,File.join(File.dirname(__FILE__), "..", "images", "zako2_crashed.png"))
      @director.effects << damage_effect
    end
  end
end
