# -*- coding: utf-8 -*-

class Title
  BACKGROUND_IMG1 = File.join(File.dirname(__FILE__), "images", "title.png")
  BACKGROUND_IMG2 = File.join(File.dirname(__FILE__), "images", "start.png")
  BACKGROUND_IMG3 = File.join(File.dirname(__FILE__), "images", "exit.png")

  def initialize 
#BGM
    @sound_bgm = Sound.new("scenes/title/sound/bgm.mid")
    @title_image1 = Image.load(BACKGROUND_IMG1)
    @title_image2 = Image.load(BACKGROUND_IMG2)
    @title_image3 = Image.load(BACKGROUND_IMG3)
    @items = []
    @items << @title_image2
    @items << @title_image3
    init
  end

  def init
    @select = 1
    @sound_bgm.play
  end

  def draw
    Window.draw(0, 0, @title_image1)
    @items.size.times{|i|
      if i+1 == @select
        Window.drawScale(290, 350+i*100, @items[i],1.5,1.5)
      else
        Window.draw(290, 350+i*100, @items[i])
      end
    }
  end

  # 
  # 
  def play
    draw 
    if Input.keyPush?( K_UP ) || Input.keyPush?( K_DOWN )
      @select = -@select + 3
    end
  
    if Input.keyPush?(K_SPACE)
      if @select == 1
        Scene.set_current_scene(:game)
        @sound_bgm.stop
      else 
        Scene.set_exit(true)
      end
    end
  end
end
