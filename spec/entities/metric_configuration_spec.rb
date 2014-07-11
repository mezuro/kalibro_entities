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

describe KalibroGem::Entities::MetricConfiguration do
  describe 'id=' do
    it 'should set the id as an Integer' do
      subject.id = "42"
      expect(subject.id).to eq(42)
    end
  end

  describe 'reading_group_id=' do
    it 'should set the reading group id' do
      subject.reading_group_id = "1"
      expect(subject.reading_group_id).to eq(1)
    end
  end

  describe 'metric=' do
    let(:metric) { FactoryGirl.build(:metric) }
    
    before :each do
      KalibroGem::Entities::Metric.
        expects(:to_object).at_least_once.
        with(metric.to_hash).
        returns(metric)
    end

    it 'should convert the argument and set the metric' do
      subject.metric = metric.to_hash
      expect(subject.metric).to eq(metric)
    end
  end

  describe 'weight=' do
    it 'should set the weight' do
      subject.weight = "10"
      expect(subject.weight).to eq(10)
    end
  end

  describe 'update_attributes' do
    let(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
    
    before :each do
      KalibroGem::Entities::MetricConfiguration.any_instance.
        expects(:save).
        returns(true)
    end

    it 'should set the attributes and save' do
      subject.update_attributes(metric_configuration.to_hash)
      expect(subject.code).to eq(metric_configuration.code)
    end
  end

  describe 'to_hash' do
    subject {FactoryGirl.build(:metric_configuration)}

    it 'should not include the configuration_id' do
      expect(subject.to_hash[:configuration_id]).to be_nil
    end
  end

  describe 'find' do
    let(:metric_configuration) { FactoryGirl.build(:metric_configuration) }

    context 'with and existant MetricConfiguration' do
      before :each do
        KalibroGem::Entities::MetricConfiguration.
          expects(:request).
          with(:get_metric_configuration, {:metric_configuration_id => metric_configuration.id}).
          returns({metric_configuration: metric_configuration.to_hash})
      end

      it 'should return the metric_configuration' do
        expect(KalibroGem::Entities::MetricConfiguration.find(metric_configuration.id).
          id).to eq(metric_configuration.id)
      end
    end

    context 'with an inexistant MetricConfiguration' do
      before :each do
        any_code = rand(Time.now.to_i)
        any_error_message = ""
        KalibroGem::Entities::MetricConfiguration.
          expects(:request).
          with(:get_metric_configuration, {:metric_configuration_id => metric_configuration.id}).
          raises(Savon::SOAPFault.new(any_error_message, any_code))
      end

      it 'should raise the RecordNotFound error' do
        expect {KalibroGem::Entities::MetricConfiguration.find(metric_configuration.id)}.
          to raise_error(KalibroGem::Errors::RecordNotFound)
      end
    end
  end

  describe 'metric_configurations_of' do
    let(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
    let(:configuration) { FactoryGirl.build(:configuration) }

    before :each do
      KalibroGem::Entities::MetricConfiguration.
        expects(:request).
        with(:metric_configurations_of, {:configuration_id => configuration.id}).
        returns({metric_configuration: metric_configuration.to_hash})
    end

    it 'should return a array with a metric configuration' do
      metric_configurations = KalibroGem::Entities::MetricConfiguration.metric_configurations_of(configuration.id)

      expect(metric_configurations).to be_an(Array)
      expect(metric_configurations.first.id).to eq(metric_configuration.id)
    end
  end

  # The only purpose of this test is to cover the overrided save_params method
  describe 'save' do
    subject {FactoryGirl.build(:metric_configuration, {id: nil})}

    before :each do
      KalibroGem::Entities::MetricConfiguration.
        expects(:request).
        with(:save_metric_configuration, {:metric_configuration => subject.to_hash, :configuration_id => subject.configuration_id}).
        returns({:metric_configuration_id => 1})
    end

    it 'should make a request to save model with id and return true without errors' do
      expect(subject.save).to be(true)
      expect(subject.kalibro_errors).to be_empty
    end
  end
  
  describe 'exists?' do
    subject {FactoryGirl.build(:metric_configuration)}

    context 'when the metric configuration exists' do
      before :each do
        KalibroGem::Entities::MetricConfiguration.expects(:find).with(subject.id).returns(subject)
      end

      it 'should return true' do
        expect(KalibroGem::Entities::MetricConfiguration.exists?(subject.id)).to be_truthy
      end
    end

    context 'when the metric configuration does not exist' do
      before :each do
        KalibroGem::Entities::MetricConfiguration.expects(:find).with(subject.id).raises(KalibroGem::Errors::RecordNotFound)
      end

      it 'should return false' do
        expect(KalibroGem::Entities::MetricConfiguration.exists?(subject.id)).to be_falsey
      end
    end
  end
end
