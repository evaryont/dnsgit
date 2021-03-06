soa minimumTTL: 3600*12

template "example-dns"

# Set the root domain A record
a "127.0.0.1"

# A records
a "a.ns", "192.168.1.2", 3600
a "b.ns", "192.168.1.3", 3600
a "mx1", "192.168.1.11"
a "mx2", "192.168.1.12"
a "sipserver", "192.168.1.200"
a "sipserver2", "192.168.2.200", 3600

# AAAA records
aaaa "2001:4860:4860::8888"

# MX records
mx "mx1", 10
mx "mx2", 20

# CNAME records
cname "www", "@"
txt "google-site-verification=vEj1ZcGtXeM_UEjnCqQEhxPSqkS9IQ4PBFuh48FP8o4"
cname "email", "mail.google.com"

# SRV records
srv :sip, :tcp, "sipserver.example.net.", 5060
srv :irc, :udp, "irc.freenode.net", 6667

# TLSA record
tlsa "@", 443, :tcp, 0, 0, 1, "e36d9e402c6308273375b68297f7ae207521238f0cd812622672f0f2ce67eb1c"

# Wildcard records
a "*.user", "192.168.1.100"
mx "*.user", "mail"

domainkey "google", "rsa", "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8it8iFFspQzey9IbqmjcmuYe9ScVCxnYKqdI+qCBIGy9rV+EqHqW6acjPcoIcodcJ4XQxIOUQ5XrC0ZNL68k7Vi6p0lwCgBpsIrHYDyujL2NHm11plVcCFCJKbWdu9v7eiWOeUCtPNX/QIaGLUDjGM0twXYaMuwvyd3RA8AXJ2QIDAQAB"
domainkey "google2", "rsa", "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8it8iFFspQzey9IbqmjcmuYe9ScVCxnYKqdI+qCBIGy9rV+EqHqW6acjPcoIcodcJ4XQxIOUQ5XrC0ZNL68k7Vi6p0lwCgBpsIrHYDyujL2NHm11plVcCFCJKbWdu9v7eiWOeUCtPNX/QIaGLUDjGM0twXYaMuwvyd3RA8AXJ2QIDAQAB", 2400

sshfp "@", 3, 1, "6ebd5d0a92eb1639ce59702da4afa29b8fa09a49"
sshfp "@", 3, 2, "ba7c07e606affd64fa4c782a11f552ba3138266fd51a7aaac7bc370c8fa2c112"
