
#SingleInstance force
#Persistent
#UseHook On
SetBatchLines, -1
SetKeyDelay, -1, -1
SendMode, Input
SetWorkingDir, %A_ScriptDir%

;-------------------- CONFIG --------------------
Ativo := 1
UsarSetas := 0          ; 0 = WASD, 1 = Setas
WatchdogMS := 30         ; intervalo do watchdog (ms)
MetronomoOn := 0
MetronomoBPM := 300      ; ms entre beeps, ajuste pro ritmo do seu wj

; "o que foi de fato mandado pro jogo" por tecla fisica - vazio = solta
EnvW := ""
EnvA := ""
EnvS := ""
EnvD := ""

SetTimer, Watchdog, %WatchdogMS%
Menu, Tray, Tip, wj_assist_v1 - ATIVO
Menu, Tray, Icon, shell32.dll, 44
Menu, Tray, Add, Mostrar painel, MostrarPainel
Menu, Tray, Default, Mostrar painel
Menu, Tray, Click, 1

;-------------------- UI (painel com checkboxes) --------------------
Gui, Font, s9, Segoe UI
Gui, Add, Checkbox, vChkAtivo gGuiToggleAtivo Checked%Ativo%, Watchdog ativo (corrige tecla presa)
Gui, Add, Checkbox, vChkSetas gGuiToggleSetas Checked%UsarSetas%, Usar Setas (desmarcado = WASD)
Gui, Add, Checkbox, vChkMetro gGuiToggleMetro Checked%MetronomoOn%, Metronomo de treino ligado
Gui, Add, Text, x10 y+10, BPM do metronomo:
Gui, Add, Edit, vBPMEdit x+5 yp-3 w50
Gui, Add, UpDown, vBPMUpDown Range50-2000, %MetronomoBPM%
Gui, Add, Button, x10 y+10 gGuiAplicarBPM w120, Aplicar BPM
Gui, Add, Button, x+10 gGuiPanico w120, Panico (F1)
Gui, Add, Text, x10 y+15 vStatusText w280, Status: ATIVO - WASD - Metronomo OFF
Gui, +AlwaysOnTop
Gui, Show, w300, wj_assist_v1 - Painel

GoSub, AtualizarStatus
Goto, FimAuto

MostrarPainel:
    Gui, Show, , wj_assist_v1 - Painel
return


Watchdog:
    if (!Ativo)
        return

    GetKeyState, pw, w, P
    if (!pw && EnvW != "")
    {
        Send, {%EnvW% up}
        EnvW := ""
    }

    GetKeyState, pa, a, P
    if (!pa && EnvA != "")
    {
        Send, {%EnvA% up}
        EnvA := ""
    }

    GetKeyState, ps, s, P
    if (!ps && EnvS != "")
    {
        Send, {%EnvS% up}
        EnvS := ""
    }

    GetKeyState, pd, d, P
    if (!pd && EnvD != "")
    {
        Send, {%EnvD% up}
        EnvD := ""
    }
return

Metronomo:
    SoundBeep, 1800, 40
return


w::
    if (UsarSetas)
        alvo := "Up"
    else
        alvo := "w"
    if (EnvW != "" && EnvW != alvo)
        Send, {%EnvW% up}
    Send, {%alvo% down}
    EnvW := alvo
return

w up::
    if (EnvW != "")
        Send, {%EnvW% up}
    else if (UsarSetas)
        Send, {Up up}
    else
        Send, {w up}
    EnvW := ""
return

a::
    if (UsarSetas)
        alvo := "Left"
    else
        alvo := "a"
    if (EnvA != "" && EnvA != alvo)
        Send, {%EnvA% up}
    Send, {%alvo% down}
    EnvA := alvo
return

a up::
    if (EnvA != "")
        Send, {%EnvA% up}
    else if (UsarSetas)
        Send, {Left up}
    else
        Send, {a up}
    EnvA := ""
return

s::
    if (UsarSetas)
        alvo := "Down"
    else
        alvo := "s"
    if (EnvS != "" && EnvS != alvo)
        Send, {%EnvS% up}
    Send, {%alvo% down}
    EnvS := alvo
return

s up::
    if (EnvS != "")
        Send, {%EnvS% up}
    else if (UsarSetas)
        Send, {Down up}
    else
        Send, {s up}
    EnvS := ""
return

d::
    if (UsarSetas)
        alvo := "Right"
    else
        alvo := "d"
    if (EnvD != "" && EnvD != alvo)
        Send, {%EnvD% up}
    Send, {%alvo% down}
    EnvD := alvo
return

d up::
    if (EnvD != "")
        Send, {%EnvD% up}
    else if (UsarSetas)
        Send, {Right up}
    else
        Send, {d up}
    EnvD := ""
return



ToggleAtivo:
    Ativo := !Ativo
    if (Ativo)
    {
        SoundBeep, 1000, 80
        Menu, Tray, Tip, wj_assist_v1 - ATIVO
    }
    else
    {
        if (EnvW != "")
            Send, {%EnvW% up}
        if (EnvA != "")
            Send, {%EnvA% up}
        if (EnvS != "")
            Send, {%EnvS% up}
        if (EnvD != "")
            Send, {%EnvD% up}
        EnvW := ""
        EnvA := ""
        EnvS := ""
        EnvD := ""
        SoundBeep, 400, 150
        Menu, Tray, Tip, wj_assist_v1 - PAUSADO
    }
    GuiControl, , ChkAtivo, %Ativo%
    GoSub, AtualizarStatus
return

ToggleSetas:
    ; solta o que estiver preso no modo antigo antes de trocar
    if (EnvW != "")
    {
        Send, {%EnvW% up}
        EnvW := ""
    }
    if (EnvA != "")
    {
        Send, {%EnvA% up}
        EnvA := ""
    }
    if (EnvS != "")
    {
        Send, {%EnvS% up}
        EnvS := ""
    }
    if (EnvD != "")
    {
        Send, {%EnvD% up}
        EnvD := ""
    }
    UsarSetas := !UsarSetas
    if (UsarSetas)
    {
        SoundBeep, 900, 60
        SoundBeep, 1200, 60
    }
    else
    {
        SoundBeep, 1200, 60
        SoundBeep, 900, 60
    }
    GuiControl, , ChkSetas, %UsarSetas%
    GoSub, AtualizarStatus
return

ToggleMetronomo:
    MetronomoOn := !MetronomoOn
    if (MetronomoOn)
    {
        SetTimer, Metronomo, %MetronomoBPM%
        SoundBeep, 1500, 50
    }
    else
    {
        SetTimer, Metronomo, Off
        SoundBeep, 500, 50
    }
    GuiControl, , ChkMetro, %MetronomoOn%
    GoSub, AtualizarStatus
return

; espera a variavel NovoBPM setada antes de chamar
AplicarBPM:
    MetronomoBPM := NovoBPM
    if (MetronomoOn)
        SetTimer, Metronomo, %MetronomoBPM%
    ToolTip, Metronomo: %MetronomoBPM% ms
    SetTimer, RemoveToolTip, -800
    GoSub, AtualizarStatus
return

Panico:
    if (EnvW != "")
        Send, {%EnvW% up}
    if (EnvA != "")
        Send, {%EnvA% up}
    if (EnvS != "")
        Send, {%EnvS% up}
    if (EnvD != "")
        Send, {%EnvD% up}
    EnvW := ""
    EnvA := ""
    EnvS := ""
    EnvD := ""
    Send, {Up up}{Down up}{Left up}{Right up}{w up}{a up}{s up}{d up}
    SoundBeep, 600, 100
return

AtualizarStatus:
    if (Ativo)
        txtEstado := "ATIVO"
    else
        txtEstado := "PAUSADO"
    if (UsarSetas)
        txtModo := "Setas"
    else
        txtModo := "WASD"
    if (MetronomoOn)
        txtMetro := "ON " . MetronomoBPM . "ms"
    else
        txtMetro := "OFF"
    texto := "Status: " . txtEstado . " - " . txtModo . " - Metronomo " . txtMetro
    GuiControl, , StatusText, %texto%
return

RemoveToolTip:
    ToolTip
return


GuiToggleAtivo:
    GoSub, ToggleAtivo
return

GuiToggleSetas:
    GoSub, ToggleSetas
return

GuiToggleMetro:
    GoSub, ToggleMetronomo
return

GuiAplicarBPM:
    GuiControlGet, valorBPM, , BPMEdit
    if valorBPM is not integer
    {
        SoundBeep, 300, 150
        return
    }
    NovoBPM := valorBPM
    GoSub, AplicarBPM
return

GuiPanico:
    GoSub, Panico
return

; fechar o X do painel so esconde a janela, nao fecha o script
GuiClose:
GuiEscape:
    Gui, Hide
return



; --- Pausa/retoma o watchdog (Ctrl+P) ---
^p::
    GoSub, ToggleAtivo
return

; --- Panico: solta TODAS as teclas de movimento na hora (F1) ---
F1::
    GoSub, Panico
return

; --- Alterna WASD <-> Setas (Ctrl+Alt+M) ---
^!m::
    GoSub, ToggleSetas
return

; --- Liga/desliga metronomo de treino (Ctrl+T) ---
^t::
    GoSub, ToggleMetronomo
return

; --- Mostra/esconde o painel (Ctrl+G) ---
^g::
    Gui, Show, , wj_assist_v1 - Painel
return

; --- Ajusta o BPM do metronomo (+ / - no numpad) ---
NumpadAdd::
    NovoBPM := MetronomoBPM - 10
    if (NovoBPM < 50)
        NovoBPM := 50
    GoSub, AplicarBPM
    GuiControl, , BPMUpDown, %NovoBPM%
return

NumpadSub::
    NovoBPM := MetronomoBPM + 10
    GoSub, AplicarBPM
    GuiControl, , BPMUpDown, %NovoBPM%
return

; --- Recarrega o script (Ctrl+R) ---
^r::Reload


FimAuto:
return

OnExitFunc:
    SetTimer, Watchdog, Off
    SetTimer, Metronomo, Off
    if (EnvW != "")
        Send, {%EnvW% up}
    if (EnvA != "")
        Send, {%EnvA% up}
    if (EnvS != "")
        Send, {%EnvS% up}
    if (EnvD != "")
        Send, {%EnvD% up}
    Send, {Up up}{Down up}{Left up}{Right up}{w up}{a up}{s up}{d up}
    SetKeyDelay, 10, 10
    SendMode, Event
    ExitApp
return
OnExit, OnExitFunc
