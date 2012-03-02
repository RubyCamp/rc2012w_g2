# -*- coding: utf-8 -*-
require_relative 'character'

class Enemy < Character
  attr_reader :life
  attr_accessor :damaged
  
  def initialize(director,x=400,y=550,image_file=nil,parameters)
    super(director,x,y,image_file,parameters)
    @frame = 0
    @life = 0
    @damaged_image = nil
  end

  def move
  end

  # ライフを減らす
  def dec_life()
    @life -= 1
  end

  # 何かにぶつかったら
  def hit(obj)
    #p obj.class
    if obj.class == Player
      dec_life
      # @director.is_gameover = true
      obj.crash
    elsif obj.class == PlayerShot
      #p @life
      dec_life
      if @life > 0
        damage
      else
        crash
      end
    else
      return
    end
  end
  
  def damage
    if !@damaged
      @damaged = true
      damage_effect = EnemyDamageEffect.new(@director, @x, @y, self,File.join(File.dirname(__FILE__), "..", "images", "enemy_crashed.png"))
      @director.effects << damage_effect
    end
  end

  def crash
    
    crash_effect = EnemyCrashEffect.new(@director, @x, @y,@crashed_image_name?{file:@crashed_image_name}:{})
    @director.effects << crash_effect
    @director.enemies.delete_if {|enemy| enemy == self }
  end
  
  
  #体力ゲージが必要か確認する
  def need_life_gauge?
    return false
  end

  private

  def char_image(image_file = nil)
    image_file ||= File.join(File.dirname(__FILE__), "..", "images", "enemy.png")
    img = Image.load(image_file)
    img.setColorKey([0, 255, 0])
    return img
  end
end
