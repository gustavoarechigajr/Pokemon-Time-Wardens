#DemICE make it so you cannot edit EVs during battle
class Battle
  alias mixed_ev_alloc_pbPartyScreen pbPartyScreen
  def pbPartyScreen(idxBattler, checkLaxOnly = false, canCancel = false, shouldRegister = false)
    $donteditEVs=true
    ret = mixed_ev_alloc_pbPartyScreen(idxBattler, checkLaxOnly, canCancel, shouldRegister)
    $donteditEVs=false
    return ret
  end  
end  

#DemICE implementing EV allocation system
class EVAllocationSprite < Sprite
  attr_reader :preselected
  attr_reader :index
  
  def initialize(viewport=nil,fifthmove=false)
    super(viewport)
    @EVsel=AnimatedBitmap.new("Graphics/Plugins/Level Based Mixed EV System and Allocator/EVsel")    
    @frame=0
    @index=0
    @fifthmove=fifthmove
    @preselected=false
    @updating=false
    @spriteVisible=true
    refresh
  end
  
  def dispose
    @EVsel.dispose
    super
  end
  
  def index=(value)
    @index=value
    refresh
  end
  
  def preselected=(value)
    @preselected=value
    refresh
  end
  
  def visible=(value)
    super
    @spriteVisible=value if !@updating
  end
  
  def refresh
    w=@EVsel.width
    h=@EVsel.height
    if PluginManager.installed?("BW Summary Screen")   
      self.x=0
      self.y=76
      self.y=94+(self.index*32) if self.index>0
    elsif PluginManager.installed?("EVs and IVs in Summary v20")   
      self.x=226
      self.y=76
      self.y=88+(self.index*32) if self.index>0
    else   
      self.x=102
      self.y=76
      self.y=88+(self.index*32) if self.index>0
    end  
    self.bitmap=@EVsel.bitmap
    if self.preselected
      self.src_rect.set(0,h,w,h)
    else
      self.src_rect.set(0,0,w,h)
    end
  end
  
  def update
    @updating=true
    super
    @EVsel.update
    @updating=false
    refresh
  end
end


class EVAllocationSprite2 < Sprite
  attr_reader :preselected
  attr_reader :index
  
  def initialize(viewport=nil,fifthmove=false)
    super(viewport)
    if PluginManager.installed?("BW Summary Screen")   
      @EVsel2=AnimatedBitmap.new("Graphics/Plugins/Level Based Mixed EV System and Allocator/EVsel2BW")
    elsif PluginManager.installed?("EVs and IVs in Summary v20")   
      @EVsel2=AnimatedBitmap.new("Graphics/Plugins/Level Based Mixed EV System and Allocator/EVsel2evsivs")
    else  
      @EVsel2=AnimatedBitmap.new("Graphics/Plugins/Level Based Mixed EV System and Allocator/EVsel2") 
    end  
    @frame=0
    @index=0
    @fifthmove=fifthmove
    @preselected=false
    @updating=false
    @spriteVisible=true
    refresh
  end
  
  def dispose
    @EVsel2.dispose
    super
  end
  
  def index=(value)
    @index=value
    refresh
  end
  
  def preselected=(value)
    @preselected=value
    refresh
  end
  
  def visible=(value)
    super
    @spriteVisible=value if !@updating
  end
  
  def refresh
    w=@EVsel2.width
    h=@EVsel2.height
    if PluginManager.installed?("BW Summary Screen")   
      self.x=134
      self.y=76
      self.y=94+(self.index*32) if self.index>0
    elsif PluginManager.installed?("EVs and IVs in Summary v20")   
      self.x=219
      self.y=76
      self.y=88+(self.index*32) if self.index>0
    else   
      self.x=237
      self.y=76
      self.y=88+(self.index*32) if self.index>0
    end  
    self.bitmap=@EVsel2.bitmap
    if self.preselected
      self.src_rect.set(0,h,w,h)
    else
      self.src_rect.set(0,0,w,h)
    end
  end
  
  def update
    @updating=true
    super
    @EVsel2.update
    @updating=false
    refresh
  end
end


class PokemonSummary_Scene
  alias mixed_ev_alloc_pbStartScene pbStartScene
  def pbStartScene(party, partyindex, inbattle = false)
  mixed_ev_alloc_pbStartScene(party, partyindex, inbattle)
  #DemICE implementing EV allocation system
  @sprites["EVsel"]=EVAllocationSprite.new(@viewport)
  @sprites["EVsel"].visible=false     
  @sprites["EVsel2"]=EVAllocationSprite2.new(@viewport)
  @sprites["EVsel2"].visible=false         
  @sprites["EVsel3"]=EVAllocationSprite2.new(@viewport)
  @sprites["EVsel3"].visible=false 
  $evalloc=false
  #DemICE end
  end
  
  #>>DemICE - Implementing the EV allocation system.
    #DemICE>>  
  def pbEVAllocation
    return if $donteditEVs
    $evalloc=true
    @sprites["EVsel"].visible=true
    @sprites["EVsel2"].visible=true
    @sprites["EVsel"].index=0
    @sprites["EVsel2"].index=0
    selEV=0
    editev=0
    evpool=80+@pokemon.level*8
    evpool=(evpool.div(4))*4      
    evpool=512 if evpool>512    
    evcap=40+@pokemon.level*4
    evcap=(evcap.div(4))*4
    evcap=252 if evcap>252
    evsum=@pokemon.ev[:HP]+@pokemon.ev[:ATTACK]+@pokemon.ev[:DEFENSE]+@pokemon.ev[:SPECIAL_DEFENSE]+@pokemon.ev[:SPEED]
    evsum+=@pokemon.ev[:SPECIAL_ATTACK] if Settings::PURIST_MODE
    drawPage(3) 
    loop do
      evpool=80+@pokemon.level*8
      evpool=(evpool.div(4))*4      
      evpool=512 if evpool>512    
      evcap=40+@pokemon.level*4
      evcap=(evcap.div(4))*4
      evcap=252 if evcap>252
      evsum=@pokemon.ev[:HP]+@pokemon.ev[:ATTACK]+@pokemon.ev[:DEFENSE]+@pokemon.ev[:SPECIAL_DEFENSE]+@pokemon.ev[:SPEED]   
      evsum+=@pokemon.ev[:SPECIAL_ATTACK] if Settings::PURIST_MODE    
      Graphics.update
      Input.update
      pbUpdate
      if Settings::PURIST_MODE
        case selEV
        when 0
          editev=@pokemon.ev[:HP]
        when 1
          editev=@pokemon.ev[:ATTACK]
        when 2
          editev=@pokemon.ev[:DEFENSE]
        when 3
          editev=@pokemon.ev[:SPECIAL_ATTACK]
        when 4
          editev=@pokemon.ev[:SPECIAL_DEFENSE]
        when 5
          editev=@pokemon.ev[:SPEED]
        end  
      else
        case selEV
        when 0
          editev=@pokemon.ev[:HP]
        when 1
          editev=@pokemon.ev[:ATTACK]
        when 2
          editev=@pokemon.ev[:DEFENSE]
        when 3
          editev=@pokemon.ev[:SPECIAL_DEFENSE]
        when 4
          editev=@pokemon.ev[:SPEED]
        end 
      end      
      if Input.trigger?(Input::B)
        @sprites["EVsel"].visible=false
        @sprites["EVsel2"].visible=false
               @sprites["EVsel3"].visible=false
        break
      end
      if Input.trigger?(Input::Y)
        # for i in 0...6
        #   @pokemon.ev[i]=0
        # end
        @pokemon.ev[:HP]=0
        @pokemon.ev[:ATTACK]=0
        @pokemon.ev[:DEFENSE]=0
        @pokemon.ev[:SPECIAL_ATTACK]=0
        @pokemon.ev[:SPECIAL_DEFENSE]=0
        @pokemon.ev[:SPEED]=0
        @pokemon.calc_stats(true)
        Graphics.update
        Input.update
        pbUpdate  
        drawPage(3)
      end
      if Input.trigger?(Input::DOWN)
        selEV+=1
        selEV=0 if selEV>5
        selEV=5 if selEV<0
        @sprites["EVsel"].index=selEV
        @sprites["EVsel2"].index=selEV
        if !Settings::PURIST_MODE
          if selEV==1
            @sprites["EVsel3"].visible=true
            @sprites["EVsel3"].index=3
          elsif selEV==3
            @sprites["EVsel3"].visible=true
            @sprites["EVsel3"].index=1
          else
            @sprites["EVsel3"].visible=false
          end 
        end  
        pbPlayCursorSE()
      end
      if Input.trigger?(Input::UP)
        selEV-=1
        selEV=0 if selEV>5
        selEV=5 if selEV<0
        @sprites["EVsel"].index=selEV
        @sprites["EVsel2"].index=selEV
        if !Settings::PURIST_MODE
          if selEV==1
            @sprites["EVsel3"].visible=true
            @sprites["EVsel3"].index=3
          elsif selEV==3
            @sprites["EVsel3"].visible=true
            @sprites["EVsel3"].index=1
          else
            @sprites["EVsel3"].visible=false
          end 
        end  
        pbPlayCursorSE( )
      end
      if Input.trigger?(Input::LEFT)
        case selEV
        when 0
          @pokemon.ev[:HP]-=4
          if @pokemon.ev[:HP]<0
            @pokemon.ev[:HP]=0
            if (evpool-evsum)>evcap
              @pokemon.ev[:HP]=evcap
            else
              @pokemon.ev[:HP]=evpool-evsum
            end
            @pokemon.ev[:HP]=(@pokemon.ev[:HP].div(4))*4
          end
          @pokemon.calc_stats(true)
        when 1
          @pokemon.ev[:ATTACK]-=4
          if @pokemon.ev[:ATTACK]<0
            @pokemon.ev[:ATTACK]=0
            if (evpool-evsum)>evcap
              @pokemon.ev[:ATTACK]=evcap
            else
              @pokemon.ev[:ATTACK]=evpool-evsum
            end
            @pokemon.ev[:ATTACK]=(@pokemon.ev[:ATTACK].div(4))*4
          end
          @pokemon.calc_stats(true)
        when 2
          @pokemon.ev[:DEFENSE]-=4
          if @pokemon.ev[:DEFENSE]<0
            @pokemon.ev[:DEFENSE]=0
            if (evpool-evsum)>evcap
              @pokemon.ev[:DEFENSE]=evcap
            else
              @pokemon.ev[:DEFENSE]=evpool-evsum
            end
            @pokemon.ev[:DEFENSE]=(@pokemon.ev[:DEFENSE].div(4))*4
          end
          @pokemon.calc_stats(true)
        when 3
          if Settings::PURIST_MODE  
            @pokemon.ev[:SPECIAL_ATTACK]-=4
            if @pokemon.ev[:SPECIAL_ATTACK]<0
              @pokemon.ev[:SPECIAL_ATTACK]=0
              if (evpool-evsum)>evcap
                @pokemon.ev[:SPECIAL_ATTACK]=evcap
              else
                @pokemon.ev[:SPECIAL_ATTACK]=evpool-evsum
              end
              @pokemon.ev[:SPECIAL_ATTACK]=(@pokemon.ev[:SPECIAL_ATTACK].div(4))*4
            end
          else    
            @pokemon.ev[:ATTACK]-=4
            if @pokemon.ev[:ATTACK]<0
              @pokemon.ev[:ATTACK]=0
              if (evpool-evsum)>evcap
                @pokemon.ev[:ATTACK]=evcap
              else
                @pokemon.ev[:ATTACK]=evpool-evsum
              end
              @pokemon.ev[:ATTACK]=(@pokemon.ev[:ATTACK].div(4))*4
            end
          end  
          @pokemon.calc_stats(true)
        when 4
          @pokemon.ev[:SPECIAL_DEFENSE]-=4
          if @pokemon.ev[:SPECIAL_DEFENSE]<0
            @pokemon.ev[:SPECIAL_DEFENSE]=0
            if (evpool-evsum)>evcap
              @pokemon.ev[:SPECIAL_DEFENSE]=evcap
            else
              @pokemon.ev[:SPECIAL_DEFENSE]=evpool-evsum
            end
            @pokemon.ev[:SPECIAL_DEFENSE]=(@pokemon.ev[:SPECIAL_DEFENSE].div(4))*4
          end
          @pokemon.calc_stats(true)
        when 5
          @pokemon.ev[:SPEED]-=4
          if @pokemon.ev[:SPEED]<0
            @pokemon.ev[:SPEED]=0
            if (evpool-evsum)>evcap
              @pokemon.ev[:SPEED]=evcap
            else
              @pokemon.ev[:SPEED]=evpool-evsum
            end
            @pokemon.ev[:SPEED]=(@pokemon.ev[:SPEED].div(4))*4
          end
          @pokemon.calc_stats(true)
        end  
        @pokemon.calc_stats(true)
        Graphics.update
        Input.update
        pbUpdate    
        dorefresh=true
        drawPage(3)            
      end
      if Input.trigger?(Input::RIGHT)
        case selEV
        when 0
          @pokemon.ev[:HP]+=4
          @pokemon.ev[:HP]=0 if @pokemon.ev[:HP]>evcap || evsum>=evpool
        when 1
          @pokemon.ev[:ATTACK]+=4
          @pokemon.ev[:ATTACK]=0 if @pokemon.ev[:ATTACK]>evcap || evsum>=evpool
        when 2
          @pokemon.ev[:DEFENSE]+=4
          @pokemon.ev[:DEFENSE]=0 if @pokemon.ev[:DEFENSE]>evcap || evsum>=evpool
        when 3
          if Settings::PURIST_MODE
            @pokemon.ev[:SPECIAL_ATTACK]+=4
            @pokemon.ev[:SPECIAL_ATTACK]=0 if @pokemon.ev[:SPECIAL_ATTACK]>evcap || evsum>=evpool
          else  
            @pokemon.ev[:ATTACK]+=4
            @pokemon.ev[:ATTACK]=0 if @pokemon.ev[:ATTACK]>evcap || evsum>=evpool
          end
        when 4
          @pokemon.ev[:SPECIAL_DEFENSE]+=4
          @pokemon.ev[:SPECIAL_DEFENSE]=0 if @pokemon.ev[:SPECIAL_DEFENSE]>evcap || evsum>=evpool
        when 5
          @pokemon.ev[:SPEED]+=4
          @pokemon.ev[:SPEED]=0 if @pokemon.ev[:SPEED]>evcap || evsum>=evpool
          @pokemon.ev[:SPEED]=(@pokemon.ev[:SPEED].div(4))*4
        end  
        @pokemon.calc_stats(true)
        Graphics.update
        Input.update
        pbUpdate    
        dorefresh=true
        drawPage(3)           
      end      
    end 
    $evalloc=false
    @sprites["EVsel"].visible=false
    @sprites["EVsel2"].visible=false
  end 

  # Edited by PDM20 to simplyfy code and added arrows to altered stats
  def drawPageThree
    overlay = @sprites["overlay"].bitmap
    base   = Color.new(248, 248, 248)
    shadow = Color.new(104, 104, 104)
    # Determine which stats are boosted and lowered by the Pokémon's nature
    statshadows, stat_text = {}, {}
    GameData::Stat.each_main { |s| 
	  statshadows[s.id] = shadow 
	  stat_text[s.id] = "" 
	}
    if !@pokemon.shadowPokemon? || @pokemon.heartStage <= 3
      @pokemon.nature_for_stats.stat_changes.each do |change|
      statshadows[change[0]] = Color.new(136, 96, 72) if change[1] > 0
      statshadows[change[0]] = Color.new(64, 120, 152) if change[1] < 0
      stat_text[change[0]] = " [+]" if change[1] > 0
      stat_text[change[0]] = " [-]" if change[1] < 0
      end
    end
    # Write various bits of text    
    if Settings::PURIST_MODE
      spatk=:SPECIAL_ATTACK
    else
      spatk=:ATTACK
    end
    textpos = [
      [_INTL("HP"), 243, 83, 2, base, statshadows[:HP]],
      [sprintf("%d/%d", @pokemon.hp, @pokemon.totalhp), 382, 83, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:HP]), 444, 83, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:HP]), 496, 83, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Atk{1}", stat_text[:ATTACK]), 225, 127, 0, base, statshadows[:ATTACK]],
      [sprintf("%d", @pokemon.attack), 382, 127, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:ATTACK]), 444, 127, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:ATTACK]), 496, 127, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Def{1}", stat_text[:DEFENSE]), 225, 159, 0, base, statshadows[:DEFENSE]],
      [sprintf("%d", @pokemon.defense), 382, 159, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:DEFENSE]), 444, 159, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:DEFENSE]), 496, 159, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Sp.A{1}", stat_text[:SPECIAL_ATTACK]), 225, 191, 0, base, statshadows[:SPECIAL_ATTACK]],
      [sprintf("%d", @pokemon.spatk), 382, 191, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:SPECIAL_ATTACK]), 444, 191, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)], 
      [sprintf("%d", @pokemon.ev[spatk]), 496, 191, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)], # DemICE edit
      [_INTL("Sp.D{1}", stat_text[:SPECIAL_DEFENSE]), 225, 223, 0, base, statshadows[:SPECIAL_DEFENSE]],
      [sprintf("%d", @pokemon.spdef), 382, 223, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:SPECIAL_DEFENSE]), 444, 223, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:SPECIAL_DEFENSE]), 496, 223, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [_INTL("Spe{1}", stat_text[:SPEED]), 225, 255, 0, base, statshadows[:SPEED]],
      [sprintf("%d", @pokemon.speed), 382, 255, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.iv[:SPEED]), 444, 255, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)],
      [sprintf("%d", @pokemon.ev[:SPEED]), 496, 255, 1, Color.new(64, 64, 64), Color.new(176, 176, 176)]#,
    ]
    #DemICE adding the unused EVs
    totalevs=80+@pokemon.level*8
    totalevs=(totalevs.div(4))*4      
    totalevs=512 if totalevs>512        
    evpool=totalevs-@pokemon.ev[:HP]-@pokemon.ev[:ATTACK]-@pokemon.ev[:DEFENSE]-@pokemon.ev[:SPECIAL_DEFENSE]-@pokemon.ev[:SPEED]
    evpool-=@pokemon.ev[:SPECIAL_ATTACK] if Settings::PURIST_MODE  
    #DemICE adding ev allocation instructions
    if $evalloc
      #pbDrawImagePositions(overlay,[["Graphics/Plugins/Level Based Mixed EV System and Allocator/hideAbilclear", 220, 285]])
      textpos.push(["EV Pool:",224,290,0,base, shadow])
      textpos.push([sprintf("%d", evpool), 344, 290, 1, base, shadow])
      textpos.push(["[S] resets EVs",362,290,0,Color.new(64,64,64),Color.new(176,176,176)])
      drawTextEx(overlay,224,322,282,2,"When EV is 0:     [<-] to max.  When EV is max: [->] to 0.",Color.new(64,64,64),Color.new(176,176,176))
    else
      # Draw ability name and description
      abildesc = @pokemon.ability.description
      fulldesc = @pokemon.ability.full_description
      abil_text = (abildesc != fulldesc) ? "FullDesc[Act]" : "Ability"
      textpos.push([_INTL(abil_text), 224, 290, 0, base, shadow])
      ability = @pokemon.ability
      if ability
        textpos.push([ability.name, 362, 290, 0, Color.new(64, 64, 64), Color.new(176, 176, 176)])
        drawTextEx(overlay, 224, 322, 282, 2, ability.description, Color.new(64, 64, 64), Color.new(176, 176, 176))
      end    
    end  
    # Draw all text
    pbDrawTextPositions(overlay, textpos)
    # Draw HP bar
    if @pokemon.hp > 0  
      w = @pokemon.hp * 96 / @pokemon.totalhp.to_f  
      w = 1 if w < 1  
      w = ((w / 2).round) * 2  
      hpzone = 0  
      hpzone = 1 if @pokemon.hp <= (@pokemon.totalhp / 2).floor  
      hpzone = 2 if @pokemon.hp <= (@pokemon.totalhp / 4).floor  
      imagepos = [  
      ["Graphics/Pictures/Summary/overlay_hp", 339, 111, 0, hpzone * 6, w, 6]  
      ]  
      pbDrawImagePositions(overlay, imagepos)
    end
  end   

  def pbScene
    @pokemon.play_cry
    loop do
      Graphics.update
      Input.update
      pbUpdate
      dorefresh = false
      if Input.trigger?(Input::ACTION)
        if @page == 3
          pbFullAbilityWindow(_INTL("{1}: {2}",@pokemon.ability.name,@pokemon.ability.full_description))
        else
          pbSEStop
          @pokemon.play_cry
        end
      elsif Input.trigger?(Input::BACK)
        pbPlayCloseMenuSE
        break
      elsif Input.trigger?(Input::USE)
        if @page == 3 && !$donteditEVs
          pbPlayDecisionSE
      pbEVAllocation
          dorefresh = true
        elsif @page == 4
          pbPlayDecisionSE
          pbMoveSelection
          dorefresh = true
        elsif @page == 5
          pbPlayDecisionSE
          pbRibbonSelection
          dorefresh = true
        elsif !@inbattle
          pbPlayDecisionSE
          dorefresh = pbOptions
        end
      elsif Input.trigger?(Input::UP) && @partyindex > 0
        oldindex = @partyindex
        pbGoToPrevious
        if @partyindex != oldindex
          pbChangePokemon
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.trigger?(Input::DOWN) && @partyindex < @party.length - 1
        oldindex = @partyindex
        pbGoToNext
        if @partyindex != oldindex
          pbChangePokemon
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.trigger?(Input::LEFT) && !@pokemon.egg?
        oldpage = @page
        @page -= 1
        @page = 1 if @page < 1
        @page = 5 if @page > 5
        if @page != oldpage   # Move to next page
          pbSEPlay("GUI summary change page")
          @ribbonOffset = 0
          dorefresh = true
        end
      elsif Input.trigger?(Input::RIGHT) && !@pokemon.egg?
        oldpage = @page
        @page += 1
        @page = 1 if @page < 1
        @page = 5 if @page > 5
        if @page != oldpage   # Move to next page
          pbSEPlay("GUI summary change page")
          @ribbonOffset = 0
          dorefresh = true
        end
      end
      if dorefresh
        drawPage(@page)
      end
    end
    return @partyindex
  end    
end  

def pbFullAbilityWindow(text, scene = nil)
  window = Window_AdvancedTextPokemon.new(text)
  window.width = Graphics.width
  window.x     = 0#Graphics.width - window.width
  window.y     = (Graphics.height - window.height)/2
  window.z     = 99999
  pbPlayDecisionSE
  loop do
    Graphics.update
    Input.update
    window.update
    scene&.pbUpdate
    break if Input.trigger?(Input::USE)
  end
  window.dispose
end
