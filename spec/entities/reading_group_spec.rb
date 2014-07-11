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

describe KalibroGem::Entities::ReadingGroup do
  describe "id=" do
    subject { FactoryGirl.build(:reading_group) }

    it 'should set the id attribute values as an integer' do
      subject.id = "222"
      expect(subject.id).to eq(222)
    end
  end

  describe 'all' do
    context 'with no reading_groups' do
      before :each do
        KalibroGem::Entities::ReadingGroup.
          expects(:request).
          with(:all_reading_groups).
          returns({:reading_group => nil})
      end

      it 'should return nil' do
        expect(KalibroGem::Entities::ReadingGroup.all).to be_empty
      end
    end

    context 'with many reading_groups' do
      let(:reading_group) { FactoryGirl.build(:reading_group) }
      before :each do
        KalibroGem::Entities::ReadingGroup.
          expects(:request).
          with(:all_reading_groups).
          returns({:reading_group => [reading_group.to_hash, reading_group.to_hash]})
      end

      it 'should return nil' do
        reading_groups = KalibroGem::Entities::ReadingGroup.all

        expect(reading_groups.first.name).to eq(reading_group.name)
        expect(reading_groups.last.name).to eq(reading_group.name)
      end
    end
  end

  # The only purpose of this test is to cover the overrided destroy_params private method
  describe 'destroy' do
    context 'when it gets successfully destroyed' do
      before :each do
        subject.expects(:id).at_least_once.returns(42)
        KalibroGem::Entities::ReadingGroup.
          expects(:request).
          with(:delete_reading_group,{:group_id => subject.id})
      end

      it 'should remain with the errors array empty' do
        subject.destroy
        expect(subject.kalibro_errors).to be_empty
      end
    end
  end

    # The only purpose of this test is to cover the overrided id_params private method
  describe 'exists?' do
    context 'with an inexistent id' do
      it 'should return false' do
        KalibroGem::Entities::ReadingGroup.
          expects(:request).
          with(:reading_group_exists,{:group_id=>0}).
          returns({:exists => false})
        KalibroGem::Entities::ReadingGroup.exists?(0)
      end
    end
  end
end