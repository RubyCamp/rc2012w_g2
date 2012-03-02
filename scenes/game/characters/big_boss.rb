# -*- coding: utf-8 -*-
require_relative 'character'

class Enemy3 < Enemy
  RADIUS = 5
  def initialize(director,x=400,y=550,image_file=nil,parameters)
    super(
          director,
          x,
          y,
          image_file ||  File.join(File.dirname(__FILE__), "..", "images", "big_boss.png"),
          parameters
          )
    @frame = 0
    @life  = 1000
    @v = 0
    @angle_c = 6
    @b_speed = 8
    @fallen = false
    @fall_count = 0
    @r = Math.atan2(@director.player.y-@y,@director.player.x-@x)*180/Math::PI
    
    @director.enemies.each{|enemy|
      enemy.crash
    }
  end

  def move
    @damaged = false
    if @life > 300 
      @x += @v #Math.cos(Math::PI/75*(@frame%150)) * RADIUS # (@frame.div(120)%2==0?1:-1) * 
      if @frame%50==0
        @v=-@v
      else
        @v+=0.1
      end
    else
      @x = @director.player.x - 60
      if @frame % 300 == 1
        @fallen = true
      end
      if @fallen && @fall_count < 180
        @y = Math.cos(@fall_count/180*Math::PI)
        @fall_count+=1
      end
      if(@fall_count >= 180)
        @fall_count = 0
        @fallen = false
      end
    end
    #    p @v
    #    @y += Math.sin(Math::PI/75*(@frame%150)) * RADIUS
    reset_collision_pos

    if @frame%50 == 1
      @angle_c = @angle_c >= 6 ? @angle_c = 1 : @angle_c+1
      @b_speed = @b_speed >= 8 ? @b_speed = 3 : @b_speed+1
      @r = Math.atan2(@director.player.y+16-(@y+94),@director.player.x+16-(@x+75))*180/Math::PI
      
      if (@angle_c+1)%2==0 
        first_angle = @r - (@angle_c.div(2)-1)*10 - 5
      else
        first_angle = @r - ( (@angle_c+1).div(2) -1)*10 
      end
      
      6.times{|i|
        @director.shots << EnemyShot.new(@director,@x+75,@y+94,File.join(File.dirname(__FILE__), "..", "images", "bullet2.png"),{angle:(@r+rand(i)*3),speed:(@b_speed+rand(i+1)-2)},6)
      }

      # @angle_c.times{|i|
      #   a = first_angle+i*10
      #   @director.shots << EnemyShot.new(@director,@x+75,@y+94,nil,{angle:a,speed:@b_speed},14)
      #   # ショットの引数の与え方(gameクラス,x座標,y座標,画像,パラメータ,当たり判定(上下左右からどれだけ縮める))
      # }
    end
    if @frame%30 == 1
      15.times{|i|
        @director.shots << EnemyShot.new(@director,@x,@y,nil,{angle:360/10*(i+1),speed:4},13)
      }
    end
    @frame += 1
  end
  
  def damage
    @damaged = true    
  end

  def draw
    Window.draw(@x, @y, @image)
    Window.drawAdd( @x, @y, @image ) if @damaged == true
  end

  def crash
    crash_effect = BossCrashEffect.new(@director, @x, @y)
    @director.effects << crash_effect
    @director.enemies.delete_if {|enemy| enemy == self }
    #    if life == 0
    #       Scene.set_current_scene(:ending)
    #       @director.game_sound_bgm.stop
    #    end
  end

  #体力ゲージが必要か確認する
  def need_life_gauge?
    return true
  end
end
