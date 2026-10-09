TTS_ENABLED = false

class TextToSpeech
  def initialize
    @queue = []
    @command = []
    @process = nil
    @thread = nil

    if System.platform[/Windows/]
      if File.exist?('libTolk.dll')
        # Windows Speech API needs to be enabled explicitly. Uncomment this line to do so.
        # Win32API.new('libTolk.dll', 'Tolk_TrySAPI', 'b', 'v').call(true)
        Win32API.new('libTolk.dll', 'Tolk_Load', '', 'v').call()
        if Win32API.new('libTolk.dll', 'Tolk_HasSpeech', '', 'b').call()
          tolk = Win32API.new('libTolk.dll', 'Tolk_Speak', ['p', 'b'], 'v')
          @talk = ->(message, interrupt) {
            tolk.call(message.encode('utf-16le'), interrupt)
          }
        end
      elsif File.exist?('nvdaControllerClient.dll')
        unless Win32API.new('nvdaControllerClient.dll', 'nvdaController_testIfRunning', '', 'b').call()
          nvdaSpeak = Win32API.new('nvdaControllerClient.dll', 'nvdaController_speakText', 'p', 'v')
          nvdaCancel = Win32API.new('nvdaControllerClient.dll', 'nvdaController_cancelSpeech', '', 'v')
          @talk = ->(message, interrupt) {
            nvdaCancel.call if interrupt
            nvdaSpeak.call(message.encode('utf-16le'))
          }
        end
      end
    end

    # if System.platform[/macOS/]
      # if `defaults read com.apple.Accessibility VoiceOverTouchEnabled`.rstrip == '1'
        # self.createThread

        # @command = ["say", "--quality", "0"]
        # @talk = ->(message, interrupt) {
          # self.clear if interrupt
          # @queue.push(message)
          # self.createThread unless @thread.status
          # @thread.run
        # }
      # end
    # end
  end

  def createThread
    @thread = Thread.new {
      loop do
        if @queue.empty?
          sleep
        else
          message = @queue.shift
          @process = spawn(*@command, message)
          Process.wait(@process)
          @process = nil
        end
      end
    }
  end

  def clear
    @queue.clear
    Process.kill(:INT, @process) unless @process.nil?
    @thread.kill if @thread
    self.initialize
  end

  def enqueue(text, interrupt)
    return if text == ""
    Console.echoln("Interrupting?; #{interrupt}. Saying: #{text}")

    text = text.to_s if text.instance_of?(Integer)
    unless text.instance_of?(String)
      dp('Incorrect tts call: ' + text.class.to_s)
      return
    end
    @talk.call(text.downcase, interrupt) unless @talk.nil?
  end
end

if $tts.nil?
  $tts = TextToSpeech.new()
else
  $tts.clear
end

def tts(text, interrupt = false)
  $tts.enqueue(text, interrupt) if TTS_ENABLED
end
