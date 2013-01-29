# encoding: UTF-8
require 'spec_helper'

describe PaczkomatyInpost::FileAdapter do

    context 'given invalid data path' do
      
      before do
        @path = '/some/invalid/path'
      end

      it 'should raise Errno::ENOENT error after creation' do
        lambda { PaczkomatyInpost::FileAdapter.new(@path) }.should raise_error(Errno::ENOENT)
      end

    end


    context 'given non writable data path' do

      before do
        @path = '/'
      end

      it 'should raise Errno::EACCES error after creation' do
        lambda { PaczkomatyInpost::FileAdapter.new(@path) }.should raise_error(Errno::EACCES)
      end

    end


    context 'given valid data path' do

      before do
        @path = Dir::tmpdir
      end

      it 'shouldn\'t raise any errors after creation' do
        lambda { PaczkomatyInpost::FileAdapter.new(@path) }.should_not raise_error
      end


      before do
        @adapter = PaczkomatyInpost::FileAdapter.new(@path)
        machines = [{:name => "ALL992", :street => "Piłsudskiego", :buildingnumber => "2/4 ", :postcode => "95-070", :town => "Aleksandrów Łódzki",
                  :latitude => "51.81284", :longitude => "19.31626", :paymentavailable => false, :operatinghours => "Paczkomat: 24/7",
                  :locationdescription => "Przy markecie Polomarket", :paymentpointdescr => nil, :partnerid => 0, :paymenttype => 0, :type => "Pack Machine"}]
        prices = {"on_delivery_payment"=>"3.50", "on_delivery_percentage"=>"1.80", "on_delivery_limit"=>"5000.00",
                  "A"=>"6.99", "B"=>"8.99", "C"=>"11.99", "insurance"=>{"5000.00"=>"1.50", "10000.00"=>"2.50", "20000.00"=>"3.00"}}
        @adapter.save_machine_list(machines, "1359406800")
        @adapter.save_price_list(prices, "1359406810")
      end


      context 'save_machine_list' do

        it 'should save given data as json in machines.dat file' do
          content = File.read(Dir::tmpdir + '/machines.dat')

          content.should == "[{\"name\":\"ALL992\",\"street\":\"Piłsudskiego\",\"buildingnumber\":\"2/4 \",\"postcode\":\"95-070\",\"town\":\"Aleksandrów Łódzki\",\"latitude\":\"51.81284\",\"longitude\":\"19.31626\",\"paymentavailable\":false,\"operatinghours\":\"Paczkomat: 24/7\",\"locationdescription\":\"Przy markecie Polomarket\",\"paymentpointdescr\":null,\"partnerid\":0,\"paymenttype\":0,\"type\":\"Pack Machine\"}]"
        end

      end


      context 'save_price_list' do

        it 'should save given data as json in prices.dat file' do
          content = File.read(Dir::tmpdir + '/prices.dat')

          content.should == "{\"on_delivery_payment\":\"3.50\",\"on_delivery_percentage\":\"1.80\",\"on_delivery_limit\":\"5000.00\",\"A\":\"6.99\",\"B\":\"8.99\",\"C\":\"11.99\",\"insurance\":{\"5000.00\":\"1.50\",\"10000.00\":\"2.50\",\"20000.00\":\"3.00\"}}"
        end

      end


      context 'cached_machines' do

        it 'should get machines data from file' do
          content = @adapter.cached_machines

          content.should == [{"name" => "ALL992", "street" => "Piłsudskiego", "buildingnumber" => "2/4 ", "postcode" => "95-070", "town" => "Aleksandrów Łódzki",
                    "latitude" => "51.81284", "longitude" => "19.31626", "paymentavailable" => false, "operatinghours" => "Paczkomat: 24/7",
                    "locationdescription" => "Przy markecie Polomarket", "paymentpointdescr" => nil, "partnerid" => 0, "paymenttype" => 0, "type" => "Pack Machine"}]
        end

      end


      context 'cached_prices' do

        it 'should get prices data from file' do
          content = @adapter.cached_prices

          content.should == {"on_delivery_payment"=>"3.50", "on_delivery_percentage"=>"1.80", "on_delivery_limit"=>"5000.00", 
                  "A"=>"6.99", "B"=>"8.99", "C"=>"11.99", "insurance"=>{"5000.00"=>"1.50", "10000.00"=>"2.50", "20000.00"=>"3.00"}}
        end

      end


      context 'last_update_machines' do

        it 'should get last_update information from machines_date.dat' do
          content = @adapter.last_update_machines

          content.should == '1359406800'
        end

      end

      context 'last_update_prices' do

        it 'should get last_update information from prices_date.dat' do
          content = @adapter.last_update_prices

          content.should == '1359406810'
        end

      end

    end

end
