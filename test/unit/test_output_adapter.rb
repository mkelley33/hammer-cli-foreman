require 'hammer_cli/output/adapter/abstract'


class TestAdapter < HammerCLI::Output::Adapter::Abstract

  def print_record(fields, record)
    print_collection(fields, [record].flatten(1))
  end


  def print_collection(fields, data)
    @separator = '#'
    puts @separator+fields.collect{|f| f.label.to_s}.join(@separator)+@separator

    data.collect do |d|
      puts @separator+fields.collect{ |f| f.get_value(d).to_s }.join(@separator)+@separator
    end
  end

end

HammerCLI::Output::Output.register_adapter(:test, TestAdapter)


