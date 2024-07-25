add_executable(winmine WIN32
  winmine.c
  grafix.c
  pref.c
  rtns.c
  sound.c
  util.c
  res.rc
)

target_compile_definitions(winmine PUBLIC -DWIN32 -D_UNICODE -DUNICODE)

target_link_libraries(winmine
  "shell32.lib"
  "winmm.lib"
  "htmlhelp.lib"
  "comctl32.lib"

  # implicitly linked? idk
  "user32.lib"
  "advapi32.lib"
  "gdi32.lib"
  "bufferoverflowu.lib"
)

target_link_options(winmine PUBLIC "-entry:WinMainCRTStartup")
