require_relative 'character'

class Zako2 < Enemy
  RADIUS = 5
  def initialize(director,x=400,y=550,image_file=nil,parameters)
    super(
          director,
          x,
          y,
          image_file ||  File.join(File.dirname(__FILE__), "..", "images", "zako2.png"),
          parameters)
    @speed    = @parameters[:speed] ? @parameters[:speed].to_i : 3
    @angle    = @parameters[:angle] ? @parameters[:angle].to_i : 0
    @interval = @parameters[:interval] ? @parameters[:interval].to_i : 100

    @frame = 0
    @life  = 10
  end

  def move
    @x += Math.cos(Math::PI*@angle/180) * @speed # (@frame.div(120)%2==0?1:-1) * 
    @y += Math.sin(Math::PI*@angle/180) * @speed
    reset_collision_pos
    if @frame%@interval == 1
      @director.shots << EnemyShot.new( @director ,@x ,@y ,nil ,{} ,13 )
    end
    @frame += 1
    remove if  !valid_x_range? || !valid_y_range?
  end

  def damage
    if !@damaged
      @damaged = true
      damage_effect = EnemyDamageEffect.new(@director, @x, @y, self,File.join(File.dirname(__FILE__), "..", "images", "zako2_crashed.png"))
      @director.effects << damage_effect
    end
  end

  def crash
    crash_effect = EnemyCrashEffect.new(@director, @x, @y,{:file=>"zako2_crashed.png"})
    @director.effects << crash_effect
    @director.enemies.delete_if {|enemy| enemy == self }
  end

  def remove
    @director.enemies.delete_if {|e| e == self }
  end
end
