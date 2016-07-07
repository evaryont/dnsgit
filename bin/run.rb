#!/usr/bin/env ruby

require_relative '../lib/environment'

# Create a temp directory for the workspace if it doesn't exist already
if !File.directory? File.join(Dir.pwd, 'tmp')
  Dir.mkdir('tmp')
end

generator = ZoneGenerator.new Dir.pwd
generator.generate
generator.deploy
