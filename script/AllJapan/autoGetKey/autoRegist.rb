require 'mechanize'

def checkMailAddress(text)
  wsp           = '[\x20\x09]'
  vchar         = '[\x21-\x7e]'
  quoted_pair   = "\\\\(?:#{vchar}|#{wsp})"
  qtext         = '[\x21\x23-\x5b\x5d-\x7e]'
  qcontent      = "(?:#{qtext}|#{quoted_pair})"
  quoted_string = "\"#{qcontent}*\""
  atext         = '[a-zA-Z0-9!#$%&\'*+\-\/\=?^_`{|}~]'
  dot_atom_text = "#{atext}+(?:[.]#{atext}+)*"
  dot_atom      = dot_atom_text
  local_part    = "(?:#{dot_atom}|#{quoted_string})"
  domain        = dot_atom
  addr_spec     = "#{local_part}[@]#{domain}"

  dot_atom_loose   = "#{atext}+(?:[.]|#{atext})*"
  local_part_loose = "(?:#{dot_atom_loose}|#{quoted_string})"
  addr_spec_loose  = "#{local_part_loose}[@]#{domain}"

  #input_addr_spec = 'foo@example.com'
  input_addr_spec = text

  if /\A#{addr_spec}\z/ =~ input_addr_spec then
    puts "valid addr-spec"
  end

  #input_text = 'ぼくの@メールアドレスはfoo@example.comです'
  input_text = text
  if /(#{addr_spec})/ =~ input_text then
    puts "My addr-spec is <#{$1}>";
  end
end



agent = Mechanize.new

#page = agent.get("http://10minutemail.com/10MinuteMail/index.html")
#body = page.body

#body = "e1162921@trbvm.com"

#result = []

#valid_address = /\A[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]+\z/


File.open("10minutesResult.txt") do |f|
  while line = f.gets
    checkMailAddress(line)
  end
end

#p body.scan(/\A[a-zA-Z0-9_\#!$%&`'*+\-{|}~^\/=?\.]+@[a-zA-Z0-9][a-zA-Z0-9\.-]+\z/)


=begin
page = agent.get('https://rekognition.com/user/create')

form = page.forms[0]

form.email = "f1766594@trbvm.com"
form.name  = "ws"
form.password = "P@ssw0rd"
form.passconf = "P@ssw0rd"
form.company  = "ws"
form.usecase = "app"
form.knowfrom = "internet"

agent.submit(form)

sleep(30)
=end
