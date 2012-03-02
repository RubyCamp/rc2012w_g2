class Scene
  @@scenes = {}

  @@current_scene_name = nil
  @@exit = false

  def self.set_exit(flag)
    @@exit = flag
  end

  def self.get_exit
    @@exit
  end

  def self.add_scene(scene_obj, scene_name)
    @@scenes[scene_name.to_sym] = scene_obj
  end


  def self.set_current_scene(scene_name)
    return if scene_name == @@current_scene_name
    @@current_scene_name = scene_name.to_sym
    @@scenes[@@current_scene_name].init
  end


  def self.play_scene
    @@scenes[@@current_scene_name].play
  end
end
