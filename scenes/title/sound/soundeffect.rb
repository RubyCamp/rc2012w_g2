require 'dxruby'


path = 'sound.wav'
sound_path = File.join(File.dirname(__FILE__), path)
sound = Sound.new(sound_path)  # sound.wav�ǂݍ���
bgm = Sound.new("bgm2.mid")  # bgm.mid�ǂݍ���

bgm.play

Window.loop do
  if Input.keyPush?(K_Z) then  # Z�L�[�ōĐ�
    sound.play
  end
end
