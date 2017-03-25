require 'pp'

require 'irb/completion'
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = File.expand_path("~/.irb-history")
IRB.conf[:INSPECT_MODE] = :pp
IRB.conf[:USE_READLINE] = true

IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => ">> ",
  :PROMPT_S => "%l>> ",
  :PROMPT_C => ".. ",
  :PROMPT_N => ".. ",
  :RETURN => "=> %s\n"
}
#IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:PROMPT_MODE] = :CUSTOM
IRB.conf[:AUTO_INDENT] = true

def t
  x = Time.now
  yield
  Time.now - x
end
