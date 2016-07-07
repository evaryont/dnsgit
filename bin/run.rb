#!/usr/bin/env ruby

require_relative '../lib/environment'

generator = ZoneGenerator.new Dir.pwd
generator.generate
generator.deploy
