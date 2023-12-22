# smtpsmug

Script to help analyze mail servers for SMTP Smuggling vulnerabilities.

# docs

`smtpsmug` allows sending mails to an smtp server and ending it with various malformed
end of data symbol. This tests whether servers are affected by SMTP Smuggling
vulnerabilities. Please consider this preliminary and work in progress, I am still
trying to fully understand the issue myself.

By default, `smtpsmug` will send a test mail ending with a '\n.\n' symbol (Unix newlines
instead of Windows '\r\n' newlines). It supports multiple other malformed endings. Use
`--list-tests` to show them, `--test [testname]` to select one.

Please note that this script does currently not test whether servers support pipelining.
Postfix recommends to disable pipelining for unauthenticated connections, which mitigates
the vulnerability. This is a temporary mitigation, and it is what you probably should
do for the time being, but it is not the purpose of this script to test for that.

There are multiple behaviors of mail servers that enable the vulnerability:

* Mail servers accept malformed endings. This is in all cases a bug and a violation of
  [RFC 5321, section 4.4.1](https://www.rfc-editor.org/rfc/rfc5321#section-4.1.4).

* Mail servers accept malformed endings within mails and forward them to other mail
  servers. To test this, you need to monitor the receiving side. (The
  [fake-mail-server](https://github.com/Email-Analysis-Toolkit/fake-mail-server) by
  Damian Poddebniak, written for our previous STARTTLS research, can be used for this.)

* I believe (but am not 100% sure) that mail servers should never accept any solo '\r'
  or '\n' characters and always answer with an error if they see them not in the '\r\n'
  combination. It appears some mail servers will accept such characters, but transform
  them to '\r\n', and safely escape dots via dot stuffing. Rejecting them seems safer.
  [RFC 5321, section 3.2.8](https://datatracker.ietf.org/doc/html/rfc5321#section-2.3.8)
  states: "SMTP client implementations MUST NOT transmit these characters except when
  they are intended as line terminators and then MUST, as indicated above, transmit them
  only as a <CRLF> sequence." This appears clear that conforming clients must not send
  such stray characters, but it does not explicitly say what receiving servers should do
  in such a case.

# context

* [SMTP Smuggling](
  https://sec-consult.com/blog/detail/smtp-smuggling-spoofing-e-mails-worldwide/)
* [Postfix announcement](
  https://www.mail-archive.com/postfix-announce@postfix.org/msg00090.html),[Postfix
  info](https://www.postfix.org/smtp-smuggling.html)

# author

[Hanno Böck](https://hboeck.de/)
