# -*- coding: utf-8 -*-
require_relative  'character'

class Player < Character
  attr_reader :life
  def initialize(director,x,y,image_file=nil,parameters={},collision_margin=0)
    super(director,x,y,image_file,parameters,collision_margin)
    @life = parameters[:life] ? parameters[:life] : 3
  end

  def hit(obj)
    puts "Hit to #{obj} by Player"
    #Scene.set_current_scene(:gameover)
    crash if !@director.is_player_crashing
  end

  def shot(obj)
    puts "shot to #{obj} by Player"
  end

  def move
    if @life >= 0
      dx = Input.x * @distance
      dy = Input.y * @distance
      @x += dx if valid_x_range?(Input.x==1 ? dx+@image.width  : -@image.width)
      @y += dy if valid_y_range?(Input.y==1 ? dy+@image.height : -@image.height)
      
      @director.map_x -=1 if @director.map_x > -10 &&  Input.x < 0
      @director.map_x +=1 if @director.map_x <  10 &&  Input.x > 0
      reset_collision_pos

      # Zキーが押下されたらプレイヤーは弾を発射する
      if Input.keyDown?(K_Z)
        @director.shots << PlayerShot.new(@director, @x+15, @y - 30)
        @director.game_sound.play
        @director.game_sound.setVolume(180)
      end
    end
  end

  def crash
    if !@director.is_player_crashing
      @director.is_player_crashing = true
      crash_effect = PlayerCrashEffect.new(@director, @x, @y)

      @life -= 1
      p @life
      @director.is_gameover = true if @life < 0
      #puts "receive"
      #Scene.set_current_scene(:gameover)

      @director.effects << crash_effect
      # @director.player.delete #_if {|player| player == self }
    end
    
  end
  
  def draw
    if !@director.is_player_crashing
      super
    end
  end

  private

  def char_image(image_file = nil)
    image_file ||= File.join(File.dirname(__FILE__), "..", "images", "new_player.png")
    img = Image.load(image_file)
    img.setColorKey([0, 255, 0])
    return img
  end
end
