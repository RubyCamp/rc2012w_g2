require_relative 'character'

class Enemy5 < Enemy
  RADIUS = 5
  attr_reader :rot
  def initialize(director,x=300,y=550,image_file=nil,parameters)
    super(
          director,
          x,
          y,
          image_file ||  File.join(File.dirname(__FILE__), "..", "images", "middle_boss.png"),
          parameters)
    @frame = 0
    @life  = 500
    @x     = 400-33
    @y     = -65
    @x_s   = 3
    @y_s   = 2
    @rot   = 0
    @crashed_image_name = "middle_boss_crashed.png"
  end

  def move
    if(@frame<60)
      @y += 2
    else
      if(valid_x_range?(@x_s > 0 ? @x_s+@image.width : -@image.width))
        @x += @x_s
      else
        @x_s = -@x_s
      end
      if(valid_y_range?(@y_s > 0 ? @y_s+@image.height+300 : -@image.height))
        @y += @y_s
      else
        @y_s = -@y_s
      end

      if(@frame % 45 == 0 && @life <200)
        4.times{|i|
          r = Math.atan2((@director.player.y+20)-(@y+33),(@director.player.x+16)-(@x+50))*180/Math::PI
          @director.shots << EnemyShot.new(@director,@x,@y,nil,{angle:r,speed:4+i},13)
        }
      end
      
      if(@frame % 50 == 0)
        8.step(13,4){|x|
          x.times{|i|
            @director.shots << EnemyShot.new(@director,@x,@y,nil,{angle:360/x*(i+1),speed:4},13)
          }
        }
      end
    end


    # @x +=Math.cos(Math::PI/45*(@frame%150)) * RADIUS # (@frame.div(120)%2==0?1:-1) * 
    # @y +=Math.sin(Math::PI/75*(@frame%150)) * RADIUS
    reset_collision_pos
    # if @frame%100 == 1
    #   @director.shots << EnemyShot.new(@director,@x,@y,nil,{},15)
    # end
    @frame += 1
    @rot   = @frame%180*2
  end

  def damage
    if !@damaged
      @damaged = true
      damage_effect = EnemyDamageEffect.new(@director, @x, @y, self,File.join(File.dirname(__FILE__), "..", "images", "middle_boss_crashed.png"))
      @director.effects << damage_effect
    end
  end

  def draw
    Window.drawRot(@x, @y, @image, @rot)
  end
end
