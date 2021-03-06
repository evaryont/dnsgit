require 'minitest/autorun'
require_relative 'test_helper'

describe Zone do

  subject do
    Zone.new("example.com",nil)
  end

  describe "soa" do
    it "should create host" do
      subject.soa ttl: "42m"
      subject.zonefile.output.must_include "42m IN  SOA"
    end
  end

  describe "a record" do
    it "should create host" do
      subject.a "127.0.0.1"
      subject.zonefile.a.must_equal [{:class=>"IN", :name=>"@", :ttl=>nil, :host=>"127.0.0.1"}]
    end

    it "should create host, ttl" do
      subject.a "127.0.0.1", 600
      subject.zonefile.a.must_equal [{:class=>"IN", :name=>"@", :ttl=>600, :host=>"127.0.0.1"}]
    end

    it "should create name, host, ttl" do
      subject.a "www", "127.0.0.1", 600
      subject.zonefile.a.must_equal [{:class=>"IN", :name=>"www", :ttl=>600, :host=>"127.0.0.1"}]
    end

    it "should create name with ipv4 and ipv6" do
      subject.a "www", "127.0.0.1", "::ffff:7f00:1"
      subject.zonefile.a.must_equal  [{:class=>"IN", :name=>"www", :ttl=>nil, :host=>"127.0.0.1"}]
      subject.zonefile.aaaa.must_equal [{:class=>"IN", :name=>"www", :ttl=>nil, :host=>"::ffff:7f00:1"}]
    end

    it "should create name with ipv4, ipv6 and TTL" do
      subject.a "www", "127.0.0.1", "::ffff:7f00:1", 600
      subject.zonefile.a.must_equal  [{:class=>"IN", :name=>"www", :ttl=>600, :host=>"127.0.0.1"}]
      subject.zonefile.aaaa.must_equal [{:class=>"IN", :name=>"www", :ttl=>600, :host=>"::ffff:7f00:1"}]
    end
  end

  describe "cname record" do
    it "without args" do
      assert_raises ArgumentError do
        subject.cname
      end
    end

    it "with name" do
      subject.cname 'www'
      subject.zonefile.cname.must_equal [{:class=>"IN", :name=>"www", :ttl=>nil, :host=>"@"}]
    end

    it "with name, host" do
      subject.cname 'www', "other-server."
      subject.zonefile.cname.must_equal [{:class=>"IN", :name=>"www", :ttl=>nil, :host=>"other-server."}]
    end

    it "with name, ttl" do
      subject.cname 'www', 600
      subject.zonefile.cname.must_equal [{:class=>"IN", :name=>"www", :ttl=>600, :host=>"@"}]
    end

    it "with name, ttl, host" do
      subject.cname 'www', "other-server.", 600
      subject.zonefile.cname.must_equal [{:class=>"IN", :name=>"www", :ttl=>600, :host=>"other-server."}]
    end
  end

  describe "mx record" do
    it "should create without args" do
      subject.mx
      subject.zonefile.mx.must_equal [{:class=>"IN", :name=>"@", :ttl=>nil, :host=>"@", :pri=>10}]
    end

    it "should create with host" do
      subject.mx "mail"
      subject.zonefile.mx.must_equal [{:class=>"IN", :name=>"@", :ttl=>nil, :host=>"mail", :pri=>10}]
    end

    it "should create with host, priority" do
      subject.mx "mail", 20
      subject.zonefile.mx.must_equal [{:class=>"IN", :name=>"@", :ttl=>nil, :host=>"mail", :pri=>20}]
    end

    it "should create with host, priority, ttl " do
      subject.mx "mail", 20, 600
      subject.zonefile.mx.must_equal [{:class=>"IN", :name=>"@", :ttl=>600, :host=>"mail", :pri=>20}]
    end
  end

  describe "srv record" do
    it "without port" do
      assert_raises ArgumentError do
        subject.srv :ldap, :tcp, 'ldap01'
      end
    end

    it "should create srv record" do
      subject.srv :ldap, :tcp, 'ldap01', 389
      subject.zonefile.srv.must_equal [{:class=>"IN", :name=>"_ldap._tcp", :ttl=>nil, :pri=>10, :weight=>0, :host=>"ldap01", port: 389}]
    end

    it "should create srv record with ttl" do
      subject.srv :ldap, :tcp, 'ldap01', 389, 600
      subject.zonefile.srv.must_equal [{:class=>"IN", :name=>"_ldap._tcp", :ttl=>600, :pri=>10, :weight=>0, :host=>"ldap01", port: 389}]
    end

    it "should create srv record with pri and weight" do
      subject.srv :ldap, :tcp, 'ldap01', 389, pri: 15, weight: 3
      subject.zonefile.srv.must_equal [{:class=>"IN", :name=>"_ldap._tcp", :ttl=>nil, :pri=>15, :weight=>3, :host=>"ldap01", port: 389}]
    end

    it "should create srv record with name" do
      subject.srv "foo", :ldap, :tcp, 'ldap01', 389
      subject.zonefile.srv.must_equal [{:class=>"IN", :name=>"_ldap._tcp.foo", :ttl=>nil, :pri=>10, :weight=>0, :host=>"ldap01", port: 389}]
    end
  end

  describe "ptr record" do
    it "should create ptr record" do
      subject.ptr 127, "foobar.org"
      subject.zonefile.ptr.must_equal [{:class=>"IN", :name=>127, :ttl=>nil, :host=>"foobar.org."}]
    end
  end

  describe "ptr6 record" do
    it "with a double colon" do
      assert_raises ArgumentError do
        subject.ptr6 "1319::1", "example.com"
      end
    end

    it "should create ptr record" do
      subject.ptr6 "1319:8a2e:0370:7344", "example.com"
      subject.zonefile.ptr.must_equal [{:class=>"IN", :name=>"4.4.3.7.0.7.3.0.e.2.a.8.9.1.3.1", :ttl=>nil, :host=>"example.com."}]
    end

    it "should create ptr record with filled zeros" do
      subject.ptr6 "1319:8a2e:70:1", "example.com"
      subject.zonefile.ptr.must_equal [{:class=>"IN", :name=>"1.0.0.0.0.7.0.0.e.2.a.8.9.1.3.1", :ttl=>nil, :host=>"example.com."}]
    end
  end


  describe "tlsa record" do
    it "should create tlsa record" do
      subject.tlsa "www", 443, :tcp, 3, 0, 1, 'e31d9e402c6308273375b68297f7af207521238f0cd812622672f0f2ce67eb1c'
      subject.zonefile.tlsa.must_equal [{:class=>"IN", :name=>"_443._tcp.www", :ttl=>nil, :certificate_usage=>3, :selector=>0, :matching_type=>1, :data=>"e31d9e402c6308273375b68297f7af207521238f0cd812622672f0f2ce67eb1c"}]
    end

    it "should create tlsa record without subdomain" do
      subject.tlsa 443, :tcp, 3, 0, 1, 'e31d9e402c6308273375b68297f7af207521238f0cd812622672f0f2ce67eb1c', 3600
      subject.zonefile.tlsa.must_equal [{:class=>"IN", :name=>"_443._tcp", :ttl=>3600, :certificate_usage=>3, :selector=>0, :matching_type=>1, :data=>"e31d9e402c6308273375b68297f7af207521238f0cd812622672f0f2ce67eb1c"}]
    end

    it "with invalid port" do
      assert_raises ArgumentError do
        subject.tlsa "www", 123456, :tcp, 3, 0, 1, 'e31d9e402c6308273375b68297f7af207521238f0cd812622672f0f2ce67eb1c'
      end
    end
  end

  describe "domainkey helper" do
    it "should create a DKIM TXT record" do
      subject.domainkey "google", "rsa", "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8it8iFFspQzey9IbqmjcmuYe9ScVCxnYKqdI+qCBIGy9rV+EqHqW6acjPcoIcodcJ4XQxIOUQ5XrC0ZNL68k7Vi6p0lwCgBpsIrHYDyujL2NHm11plVcCFCJKbWdu9v7eiWOeUCtPNX/QIaGLUDjGM0twXYaMuwvyd3RA8AXJ2QIDAQAB"
      subject.zonefile.txt.must_equal [{:class=>"IN", :name=>"google._domainkey", :ttl=>nil, :text=>"v=DKIM1; k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC8it8iFFspQzey9IbqmjcmuYe9ScVCxnYKqdI+qCBIGy9rV+EqHqW6acjPcoIcodcJ4XQxIOUQ5XrC0ZNL68k7Vi6p0lwCgBpsIrHYDyujL2NHm11plVcCFCJKbWdu9v7eiWOeUCtPNX/QIaGLUDjGM0twXYaMuwvyd3RA8AXJ2QIDAQAB"}]
    end
  end

  describe "sshfp record" do
    it "should create a sshfp record" do
      subject.sshfp "@", 3, 1, "6ebd5d0a92eb1639ce59702da4afa29b8fa09a49"
      subject.zonefile.sshfp.must_equal [{:class=>"IN", :name=>"@", :ttl=>nil, :key_type=>3, :fingerprint_type=>1, :fingerprint=>"6ebd5d0a92eb1639ce59702da4afa29b8fa09a49"}]
    end
  end

  describe "spf record" do
    it "should create a spf record" do
      subject.spf "v=spf1 include:_spf.google.com include:acmeemailmarketing.com ~all"
      subject.zonefile.spf.must_equal [{:class=>"IN", :name=>"@", :ttl=>nil, :text=>"v=spf1 include:_spf.google.com include:acmeemailmarketing.com ~all"}]
      subject.zonefile.txt.must_equal [{:class=>"IN", :name=>"@", :ttl=>nil, :text=>"v=spf1 include:_spf.google.com include:acmeemailmarketing.com ~all"}]
    end

    it "fills in v=spf1" do
      subject.spf "include:_spf.google.com include:acmeemailmarketing.com ~all"
      subject.zonefile.spf[0][:text].must_equal "v=spf1 include:_spf.google.com include:acmeemailmarketing.com ~all"
    end
  end
end
