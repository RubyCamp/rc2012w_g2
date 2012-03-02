# -*- coding: utf-8 -*-
require_relative 'character'

class EnemyShot < Character
  attr_reader :deleted
  def move
    if @parameters[:angle]
      angle = @parameters[:angle] 
      speed = @parameters[:speed]?@parameters[:speed] : 3
      @x += speed*Math.cos(Math::PI*angle/180.0)
      @y += speed*Math.sin(Math::PI*angle/180.0)
    else
      @y += 3
    end
    reset_collision_pos
    remove if !valid_x_range? || !valid_y_range? 
  end

  def remove
    @director.shots.delete_if {|shot| shot == self }
  end

  def hit(obj)
    return unless obj.class == Player
    remove
    obj.crash
  end

  private
  #イメージファイルの設定
  def char_image(image_file = nil)
    image_file ||= File.join(File.dirname(__FILE__), "..", "images", "bullet3.png")
    img = Image.load(image_file)
    img.setColorKey([0, 0, 0])
    return img
  end
end
