

# JavaZOOM Sound-API Projects
#  - Shared lib
require 'tritonus_share.jar'
#  - MP3 lib
require 'mp3spi1.9.5.jar'
require 'jl1.0.1.jar'
#  - Ogg/Vorbis lib
require 'jogg-0.0.7.jar'
require 'jorbis-0.0.15.jar'
require 'vorbisspi1.0.3.jar'


module Shoes
  class Sound


    JFile = java.io.File
    import java.io.BufferedInputStream
    import javax.sound.sampled
    import java.io.IOException

    BufferSize = 4096

    attr_accessor :gui_container
    attr_accessor :filepath, :blk
    attr_accessor :mixer_channel, :audio_input_stream, :audio_format

    def initialize(gui_container, filepath, opts={}, &blk)
      self.gui_container = gui_container
      self.filepath = filepath
      opts.stringify_keys!

      #self.blk = blk

      gui_sound_init

      #instance_eval &blk unless blk.nil?

    end

    def gui_sound_init
      # noop for java.sound.SourceDataLine implementation
    end


    def play
      gui_sound_play
    end

    def gui_sound_play


      Thread.new do
        begin
          sound_file = JFile.new(self.filepath)

          audio_input_stream = AudioSystem.getAudioInputStream(sound_file)
          audio_format = audio_input_stream.getFormat

          decoded_audio_format, decoded_audio_input_stream = decode_input_stream(audio_format, audio_input_stream)

          # Play now.
          rawplay(decoded_audio_format, decoded_audio_input_stream)
          audio_input_stream.close

        rescue UnsupportedAudioFileException => uafex
          puts uafex.inspect, uafex.backtrace
        rescue IOException => ioex
          puts ioex.inspect, ioex.backtrace
            #rescue JIOException => jioex
            #  jioex.stacktrace
        rescue LineUnavailableException => luex
          puts luex.inspect, luex.backtrace
        rescue Exception => e
          puts e.inspect, e.backtrace
        end
      end


    end

    def decode_input_stream(audio_format, audio_input_stream)
      case audio_format.encoding
        when Java::JavazoomSpiVorbisSampledFile::VorbisEncoding, Java::JavazoomSpiMpegSampledFile::MpegEncoding
          decoded_format = AudioFormat.new(AudioFormat::Encoding::PCM_SIGNED,
                                           audio_format.getSampleRate(),
                                           16,
                                           audio_format.getChannels(),
                                           audio_format.getChannels() * 2,
                                           audio_format.getSampleRate(),
                                           false)
          decoded_audio_input_stream = AudioSystem.getAudioInputStream(decoded_format, audio_input_stream)

          return decoded_format, decoded_audio_input_stream

        else
          return audio_format, audio_input_stream
      end
    end

    def rawplay(decoded_audio_format, decoded_audio_input_stream)

      #throws IOException, LineUnavailableException


      sampled_data = Java::byte[BufferSize].new

      line = getLine(decoded_audio_format)
      if line != nil

        # Start
        line.start()
        bytes_read = 0, bytes_written = 0
        while bytes_read != -1

          bytes_read = decoded_audio_input_stream.read(sampled_data, 0, sampled_data.length)
          if bytes_read != -1

            bytes_written = line.write(sampled_data, 0, bytes_read)
          end
        end
        # Stop
        line.drain()
        line.stop()
        line.close()
        decoded_audio_input_stream.close()
      end
    end

    def getLine(audioFormat)

      #throws LineUnavailableException

      res = nil
      info = DataLine::Info.new(SourceDataLine.java_class, audioFormat)
      res = AudioSystem.getLine(info)
      res.open(audioFormat)
      res

    end


  end
end