# coding: Windows-31J

class Ending
  BACKGROUND_IMG = File.join(File.dirname(__FILE__), "images", "ending.png")
  ENDING_ROLL_TEXT = File.join(File.dirname(__FILE__), "ending_roll.txt")

  def initialize
    # 背景画像の読み込み
    @ending_image = Image.load(BACKGROUND_IMG)
    # エンディングロールとして流すテキストを配列に格納する
    @staff_roll = File.read(ENDING_ROLL_TEXT).split(/\n/)
    @sound_bgm = Sound.new("scenes/ending/sound/bgm4.mid")
  end

  def init
    @sound_bgm.play
    # 定義したスタッフロールを、画面最下部から最上部までスクロールさせる。
    # その際、色は黄色で描画するように設定を変えてみる。
    @scroll_text = ScrollText.new(@staff_roll, :color => [255, 255, 0])
  end

  def draw
    # 背景画像表示後に、スクロールするテキストを描画する
    Window.draw(0, 0, @ending_image)
    @scroll_text.draw
  end

  # シーン描画
  # スペースキーまたはエンターキーが押下されたらプログラムを終了する
  def play
    draw  # エンディング画面を描画
    #exit if Input.keyPush?(K_SPACE) || Input.keyPush?(K_RETURN)
    if Input.keyPush?(K_SPACE) || Input.keyPush?(K_RETURN)
    @sound_bgm.stop
    Scene.set_current_scene(:title)
  end
end
end
