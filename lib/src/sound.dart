part of convenience_xl;


/**
 * Provides easy to use sounds with predefined playback settings.
 *
 * It does not provide new functionality, instead simplifies the main
 * game code by allowing the developer to combine the definitions for
 * sounds and playback settings as reusable classes.
 *
 * The class preserves the playback interface of the [sxl.Sound] class,
 * stripping the settings and loop options only.
 */
class GameSound {

  /// The sound source to use.
  Sound sound;
  /// The playback settings to use when playing the sound source.
  SoundTransform settings;

  /**
   * Initializes an instance with a sound (usually provided from the resource
   * manager) and optional settings for the playback.
   */
  GameSound(this.sound, [this.settings]);

  /// Plays back the sounds with the settings defined on initialization.
  void play() {
    sound.play(false, settings);
  }
}