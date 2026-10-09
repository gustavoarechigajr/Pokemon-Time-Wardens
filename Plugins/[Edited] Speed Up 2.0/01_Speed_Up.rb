module Input

  def self.update
    update_KGC_ScreenCapture
    if trigger?(Input::F8)
      pbScreenCapture
    end
    if $CanToggle && trigger?(Input::AUX1) #remap your Q button on the F1 screen to change your speedup switch
      $GameSpeed += 1
      gametitle=System.game_title
      $GameSpeed = 0 if $GameSpeed >= SPEEDUP_STAGES.size
      pbSetWindowText(gametitle +" | Speed: x" + ($GameSpeed+1).to_s)
    end
    if $CanToggle && trigger?(Input::AUX2) #remap your Q button on the F1 screen to change your speedup switch
      $GameSpeed -= 1
      gametitle=System.game_title
      $GameSpeed = 4 if $GameSpeed < 0#= SPEEDUP_STAGES.size
      pbSetWindowText(gametitle +" | Speed: x" + ($GameSpeed+1).to_s)
    end
  end
end

SPEEDUP_STAGES = [1,2,3,4,5]
$GameSpeed = 0
$frame = 0
$CanToggle = true

module Graphics
  class << Graphics
    alias fast_forward_update update
  end

  def self.update
    $frame += 1
    return unless $frame % SPEEDUP_STAGES[$GameSpeed] == 0
    fast_forward_update
    $frame = 0
  end
end

$ScreenshotNum = 0
def pbScreenCapture
  if !safeIsDirectory?(RTP.getSaveFileName(sprintf("Screenshots/")))
    Dir.mkdir(RTP.getSaveFileName(sprintf("Screenshots"))) rescue nil
  end
  t = pbGetTimeNow
  filestart = t.strftime("[%Y-%m-%d] %H_%M_%S.%L")
  capturefile = RTP.getSaveFileName(sprintf("Screenshots/%s {#{$ScreenshotNum}}.png", filestart))
  Graphics.screenshot(capturefile)
  pbSEPlay("Pkmn exp full") if FileTest.audio_exist?("Audio/SE/Pkmn exp full")
  $ScreenshotNum += 1
end
