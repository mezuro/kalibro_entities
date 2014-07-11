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

describe KalibroGem::Entities::RepositoryObserver do
  describe 'id=' do
    it 'should set the value of the attribute id' do
      subject.id = 42
      expect(subject.id).to eq(42)
    end
  end

  describe 'all' do
    context 'with no repository observers' do
      before :each do
        KalibroGem::Entities::RepositoryObserver.
          expects(:request).
          with(:all_repository_observers).
          returns({:repository_observer => nil})
      end

      it 'should return nil' do
        expect(KalibroGem::Entities::RepositoryObserver.all).to be_empty
      end
    end

    context 'with many repository observers' do
      let(:repository_observer) { FactoryGirl.build(:repository_observer) }
      before :each do
        KalibroGem::Entities::RepositoryObserver.
          expects(:request).
          with(:all_repository_observers).
          returns({:repository_observer => [repository_observer.to_hash, repository_observer.to_hash]})
      end

      it 'should return the two elements' do
        repository_observers = KalibroGem::Entities::RepositoryObserver.all
        expect(repository_observers.size).to eq(2)
        expect(repository_observers.first.name).to eq(repository_observer.to_hash[:name])
        expect(repository_observers.last.name).to eq(repository_observer.to_hash[:name])
      end
    end
  end

  # FIXME: the index of the second parameter of the request of repository_observers of will be altered someday.
  describe 'repository_observers_of' do
    context 'with no repository observers' do
      let(:repository_without_observers) { FactoryGirl.build(:repository).to_hash }
      before :each do
        KalibroGem::Entities::RepositoryObserver.expects(:request).
          with(:repository_observers_of, {:repository_observer_id => repository_without_observers[:id]}).
          returns({:repository_observer => []})
      end

      it 'should get an empty array' do
        expect(KalibroGem::Entities::RepositoryObserver.
          repository_observers_of(repository_without_observers[:id])).to eq []
      end
    end

    context 'with many repository observers' do
      let(:repository) { FactoryGirl.build(:repository) }
      let(:repository_observer) { FactoryGirl.build(:repository_observer) }
      
      before :each do
        KalibroGem::Entities::RepositoryObserver.expects(:request).
          with(:repository_observers_of, {:repository_observer_id => repository.id}).
          returns({:repository_observer => [repository_observer.to_hash, repository_observer.to_hash]})
      end

      it 'should return the two elements' do
        repository_observers = KalibroGem::Entities::RepositoryObserver.
          repository_observers_of(repository.id)

        expect(repository_observers.size).to eq(2)
        expect(repository_observers.first.name).to eq(repository_observer.name)
        expect(repository_observers.last.name).to eq(repository_observer.name)
      end
    end
  end

  describe 'id=' do
    it 'should set the value of the attribute id' do
      subject.id = 65
      expect(subject.id).to eq(65)
    end
  end

  describe 'repository_id=' do
    it 'should set the value of the attribute repository_id' do
      subject.repository_id = 91
      expect(subject.repository_id).to eq(91)
    end
  end

  describe 'name=' do
    it 'should set the value of the attribute name' do
      subject.name = 'William'
      expect(subject.name).to eq('William')
    end
  end

  describe 'email=' do
    it 'should set the value of the attribute email' do
      subject.email = 'william@email.com'
      expect(subject.email).to eq('william@email.com')
    end
  end
end