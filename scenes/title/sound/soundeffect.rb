require 'dxruby'


path = 'sound.wav'
sound_path = File.join(File.dirname(__FILE__), path)
sound = Sound.new(sound_path)  # sound.wav“Ç‚İ‚İ
bgm = Sound.new("bgm2.mid")  # bgm.mid“Ç‚İ‚İ

bgm.play

Window.loop do
  if Input.keyPush?(K_Z) then  # ZƒL[‚ÅÄ¶
    sound.play
  end
end
