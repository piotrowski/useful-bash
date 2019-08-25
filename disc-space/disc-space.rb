require 'sys/filesystem'
require 'net/smtp'
require 'socket'

$min_mb_available = 1024 * 10 # 10 GB

$smtp_settings = [
  'smtp.gmail.com',
  '25',
  'localhost',
  'SMTP USER',
  'SMTP PASSWORD',
]

$send_from_to = ["FROM@mail.com", "TO@mail.com"]

ip = Socket.ip_address_list.detect{|intf| intf.ipv4_private?}

$mail_details = {
  "From" => "Best Server <#{$send_from_to[0]}>",
  "To" => "Ruby Lord <#{$send_from_to[1]}>",
  "Subject" => "Your server(#{ip.ip_address}) is out of space.",
  "Body" => "There is little space left. Please take care of this server.",
}

def send_mail()
  message = <<EOM
From: #{$mail_details["From"]}
To:  #{$mail_details["To"]}
Subject: #{$mail_details["Subject"]}

#{$mail_details["Body"]}
EOM

  Net::SMTP.start(*$smtp_settings) do |smtp|
    smtp.send_message message,
    *$send_from_to
  end
end

def main()

  stat = Sys::Filesystem.stat('/')

  mb_available = stat.block_size * stat.blocks_available / 1_024 / 1_024

  if mb_available < $min_mb_available
    send_mail()
  end
end

main()