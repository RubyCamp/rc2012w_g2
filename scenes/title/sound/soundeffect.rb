require 'dxruby'


path = 'sound.wav'
sound_path = File.join(File.dirname(__FILE__), path)
sound = Sound.new(sound_path)  # sound.wav読み込み
bgm = Sound.new("bgm2.mid")  # bgm.mid読み込み

bgm.play

Window.loop do
  if Input.keyPush?(K_Z) then  # Zキーで再生
    sound.play
  end
end
