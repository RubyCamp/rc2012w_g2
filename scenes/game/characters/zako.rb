require_relative 'character'

class Enemy2 < Enemy
  RADIUS = 5
  def initialize(director,x=400,y=550,image_file=nil,parameters)
    super(
          director,
          x,
          y,
          image_file ||  File.join(File.dirname(__FILE__), "..", "images", "zako1.png"),
          parameters)
    @frame = 0
    @life  = 20
  end

  def move
    # @x +=Math.cos(Math::PI/75*(@frame%150)) * RADIUS # (@frame.div(120)%2==0?1:-1) * 
    # @y +=Math.sin(Math::PI/75*(@frame%150)) * RADIUS
    @y += 10
    remove if @y > Window.height
    reset_collision_pos
    x = 9
    if @frame%10 == 1
      x.times{|i|
        @director.shots << EnemyShot.new(@director,@x,@y,nil,{angle:360/x*(i+1),speed:4},13)
      }
    end
    @frame += 1
    
  end

  def remove
    @director.enemies.delete_if {|e| e == self }
  end

  def damage
    if !@damaged
      @damaged = true
      damage_effect = EnemyDamageEffect.new(@director, @x, @y, self,File.join(File.dirname(__FILE__), "..", "images", "zako1_crashed.png"))
      @director.effects << damage_effect
    end
  end
end
