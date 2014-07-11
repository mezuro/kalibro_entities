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

require 'spec_helper'

describe KalibroGem::Entities::Configuration do
  describe 'id=' do
    it 'should set the value of the attribute id as an Integer' do
      subject.id = "42"
      expect(subject.id).to eq(42)
    end
  end

  describe 'all' do
    context 'with no configurations' do
      before :each do
        KalibroGem::Entities::Configuration.
          expects(:request).
          with(:all_configurations).
          returns({:configuration => nil})
      end

      it 'should return nil' do
        expect(KalibroGem::Entities::Configuration.all).to be_empty
      end
    end

    context 'with many configurations' do
      let(:configuration) { FactoryGirl.build(:configuration) }
      let(:another_configuration) { FactoryGirl.build(:another_configuration) }

      before :each do
        KalibroGem::Entities::Configuration.
          expects(:request).
          with(:all_configurations).
          returns({:configuration => [configuration.to_hash, another_configuration.to_hash]})
      end

      it 'should return the two elements' do
        configurations = KalibroGem::Entities::Configuration.all

        expect(configurations.size).to eq(2)
        expect(configurations.first.name).to eq(configuration.name)
        expect(configurations.last.name).to eq(another_configuration.name)
      end
    end
  end
end