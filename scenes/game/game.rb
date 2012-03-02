# -*- coding: utf-8 -*-
require_relative File.join('characters', 'player')
require_relative File.join('characters', 'player_shot')
require_relative File.join('characters', 'enemy')
require_relative File.join('characters', 'zako')
require_relative File.join('characters', 'zako2')
require_relative File.join('characters', 'big_boss')
require_relative File.join('characters', 'weapon')
require_relative File.join('characters', 'middle_boss')
require_relative File.join('characters', 'enemy_shot')
require_relative File.join('characters', 'life_gauge')
# require_relative 'map'

# 視覚効果クラスの読み込み
require_relative File.join('effects', 'effect_base')
require_relative File.join('effects', 'crash_effect')
require_relative File.join('effects', 'player_crash_effect')
require_relative File.join('effects', 'boss_crash_effect')
require_relative File.join('effects', 'enemy_damage_effect')

class Game
  HORIZONAL_MARGIN = 100
  attr_accessor :player, :enemies, :shots, :effects, :map, :is_gameover ,:is_player_crashing,:map_x
  attr_reader :game_sound_bgm,:game_sound

  ENEMY_TABLE_FILE = File.join(File.dirname(__FILE__), "enemy_table.dat")

  # シーン情報の初期化
  def initialize
    init
  end

  def init
    @frame    = 0                                               # 
    @player   = Player.new(self, 400, 550,nil,{life:3},13)      # プレイヤーオブジェクトを生成
    @enemies  = []     # 敵キャラオブジェクトの配列を作成  [Enemy.new(self, 250, 170)] 
    @shots    = []                              # 弾丸の配列を初期化
    @effects  = []                              # 視覚効果オブジェクトの配列を初期化
    @life_gauge = nil                           #体力ゲージ          
    # @map = Map.new(@player)                     # 背景マップ描画用オブジェクトを生成
    @map_image = Image.load(File.join(File.dirname(__FILE__), "images", "background.png"))
    @map_scroll_speed = 2
    @map_y = 0
    @map_x = 10
    @enemy_table      = Hash[]                  # 敵出現テーブル
    make_enemy_table

    @is_gameover = false       
    @game_sound_bgm = Sound.new("scenes/game/sound/bgm2.mid")
    @game_sound     = Sound.new("scenes/game/sound/sound.wav")
    @game_sound_bgm.play 
    @game_sound_bgm.setVolume(255)
                   
    @is_player_crashing = false
    
    @status_zone_image = Image.new(HORIZONAL_MARGIN,Window.height)
    @status_zone_image.boxFill(0, 0, HORIZONAL_MARGIN, Window.height, [0,0,0])
    
  end

  # 敵出現テーブルをファイルから作成
  def make_enemy_table
    File.open(ENEMY_TABLE_FILE) do |f|
      f.each do |line|
        # p line
        h = Hash[]
        ary = line.chomp.split("," ,5)
        
        # 必須項目の4項目を取得
        frame = ary[0].to_i
        @enemy_table[frame] = [] if @enemy_table[frame] == nil
        h  = { :name => ary[1], :x => ary[2], :y=> ary[3] }
        
        # オプション項目を取得
        if ary.size > 4
          options = ary[4]
          options = options.split(",")
          options.each do |opt|
            key,value = opt.split(":")
            h[key.to_sym] = value
          end
        end
#        p h
        @enemy_table[frame] << h
      end

    end
  end
  
  # 本シーンの主描画メソッド
  def play
    # まずは背景マップの描画を行う（drawメソッドはスクロール実行も兼ねる）
#    @map.draw
    
    Window.draw(@map_x,-(@map_image.height - @map_y),@map_image)
    Window.draw(@map_x,@map_y,@map_image)


    @map_y = (@map_y + @map_scroll_speed)%@map_image.height
    # 敵出現テーブルの処理
    if @enemy_table[@frame] != nil 
      @enemy_table[@frame].each do |e|
        # @enemies << Enemy.new(self,e[:x],e[:y])
        # @enemies << Object.const_get(e.delete(:name)).new(self,e.delete(:x).to_i,e.delete(:y).to_i,e)

        new_enemy = Object.const_get(e.delete(:name)).new(self,e.delete(:x).to_i,e.delete(:y).to_i,e)

	if new_enemy.need_life_gauge?
	  #ライフのオブジェクトを保存する。
	  @life_gauge = LifeGauge.new(self, new_enemy)
        end
        @enemies << new_enemy
      end
    end

    # 1400フレームになったら敵をすべて消す
    # if @frame == 550
    #    @enemies = [] 
    # elsif @frame == 880
    #    @enemies = []
    # end

    # 画面上に描画するべき全ての要素を処理する
    draw_items.each do |char|
      char.move  # キャラクタに移動を命じる
    end
    draw_items.each do |char|
      char.draw  # キャラクタの画像を画面に表示させる
    end

    Window.draw(0,0,@status_zone_image)
    Window.draw(Window.width-HORIZONAL_MARGIN,0,@status_zone_image)
    @player.life.times{|i|
      Window.draw(5,5+i*(@player.image.height+5),@player.image)
    }
    
    cheak_gameover  # 死亡条件の判定処理
    check_collision # 当たり判定の一括処理
    check_clear     # ゲームクリア条件の判定処理
    @frame +=1
  end


  private

  def add_object(obj)
    @draw_item << obj
  end

  # 画面上に描画するべき全ての要素を1つの配列として返す
  def draw_items
    return ([@player] + @enemies + @shots + @effects + [@life_gauge]).compact
  end

  # 画面上の全ての要素（キャラクタ）に対して、当たり判定を行う
  def check_collision
    collisions = draw_items.map{|c| c.collision }.compact
    Collision.check(collisions, collisions)
  end

  def cheak_gameover
    if  @is_gameover && !@player_is_crashing
        Scene.set_current_scene(:gameover)
        @game_sound_bgm.stop
    end
  end

  def create_image(file_name)
    image_file ||= File.join(File.dirname(__FILE__), ".",  "images", "#{file_name}.png")
    img = Image.load(image_file)
    img.setColorKey([0, 0, 0])
    return img
  end

  
  # ゲームのクリア条件を判定する
  # ※ ここでは単にリターンキーの押下でゲーム終了としている
  def check_clear
    if Input.keyPush?(K_RETURN)
      # シーンを切り替え、エンディングシーンへ遷移
      @game_sound_bgm.stop
      Scene.set_current_scene(:ending)
    end
  end
end
