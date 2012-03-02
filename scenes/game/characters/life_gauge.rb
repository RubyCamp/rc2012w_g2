# -*- coding: utf-8 -*-
require_relative 'character'

class LifeGauge < Character
  BASIC_LIFE = 500
  
  def initialize(director, enemy)
    super(director,100,100)
    @enemy = enemy
    puts @enemy.life
  end

  #ライフを描画しているメソッド
  def draw
    #バーの色は青→緑→赤となる
    x2 = @enemy.life*5
    #敵のHPがなくなった時の処理
    if x2 < 0
       x2 = 0
    end
      image = Image.new(800,600)
      image.boxFill(0, 0, x2, 10, [255,255, 0, 0])
      Window.draw(10, 10, image)
    if x2 > BASIC_LIFE
      image = Image.new(800,600)
      image.boxFill(0, 0, x2-BASIC_LIFE, 10, [255,0,255, 0])
      Window.draw(10, 10, image)
    end
    if x2 > 2*BASIC_LIFE
      image = Image.new(800,600)
      image.boxFill(0, 0, x2-2*BASIC_LIFE, 10, [255,0,0,255])
      Window.draw(10, 10, image)
    end
  end

  def move
  end

  private

  def char_image(image_file = nil)
    image_file ||= File.join(File.dirname(__FILE__), "..", "images", "life.jpg")
    img = Image.load(image_file)
    img.setColorKey([0, 0, 0])
    return img
  end
end
