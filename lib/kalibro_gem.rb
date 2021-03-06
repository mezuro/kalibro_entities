# This file is part of KalibroGem
# Copyright (C) 2013  it's respectives authors (please see the AUTHORS file)
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'yaml'
require 'logger'
require "kalibro_gem/version"
require "kalibro_gem/errors"
require "kalibro_gem/entities"

module KalibroGem
  @config = {
              address: "http://localhost:8080/KalibroService/"
            }

  @valid_config_keys = @config.keys

  @logger = Logger.new(STDOUT)

  # Configure through hash
  def KalibroGem.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  # Configure through yaml file
  def KalibroGem.configure_with(path_to_yaml_file)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      logger.warn("YAML configuration file couldn't be found. Using defaults."); return
    rescue Psych::SyntaxError
      logger.warn("YAML configuration file contains invalid syntax. Using defaults."); return
    end

    configure(config)
  end

  def KalibroGem.config
    @config
  end

  def KalibroGem.logger
    @logger
  end

  def KalibroGem.logger=(logger)
    @logger = logger
  end
end
