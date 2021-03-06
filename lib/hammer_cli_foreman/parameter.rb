require 'hammer_cli'
require 'hammer_cli/messages'
require 'foreman_api'

module HammerCLIForeman

  module Parameter

    def self.get_parameters(resource_config, resource_type, resource)
      params = {
        resource_type.to_s+"_id" => resource["id"] || resource["name"]
      }

      params = ForemanApi::Resources::Parameter.new(resource_config).index(params)[0]
      HammerCLIForeman.collection_to_common_format(params)
    end

    class SetCommand < HammerCLI::Apipie::Command

      include HammerCLI::Messages

      option "--name", "NAME", "parameter name", :required => true
      option "--value", "VALUE", "parameter value", :required => true

      def self.command_name(name=nil)
        super(name) || "set_parameter"
      end

      def self.resource(resource=nil)
        super(resource) || HammerCLI::Apipie::ResourceDefinition.new(ForemanApi::Resources::Parameter)
      end

      def execute
        if parameter_exist?
          update_parameter
          print_message success_message_for :update if success_message_for :update
        else
          create_parameter
          print_message success_message_for :create if success_message_for :create
        end
        HammerCLI::EX_OK
      end

      def base_action_params
        {}
      end

      def parameter_exist?
        params = HammerCLIForeman.collection_to_common_format(resource.call(:index, base_action_params)[0])
        params.find { |p| p["name"] == name }
      end

      def update_parameter
        params = {
          "id" => name,
          "parameter" => {
            "value" => value
          }
        }.merge base_action_params

        HammerCLIForeman.record_to_common_format(resource.call(:update, params))
      end

      def create_parameter
        params = {
          "parameter" => {
            "name" => name,
            "value" => value
          }
        }.merge base_action_params

        HammerCLIForeman.record_to_common_format(resource.call(:create, params))
      end

    end


    class DeleteCommand < HammerCLI::Apipie::Command

      include HammerCLI::Messages

      option "--name", "NAME", "parameter name", :required => true

      def self.command_name(name=nil)
        super(name) || "delete_parameter"
      end

      def self.resource(resource=nil)
        super(resource) || HammerCLI::Apipie::ResourceDefinition.new(ForemanApi::Resources::Parameter)
      end

      def execute
        params = {
          "id" => name
        }.merge base_action_params

        HammerCLIForeman.record_to_common_format(resource.call(:destroy, params))
        print_message success_message if success_message
        HammerCLI::EX_OK
      end

      def base_action_params
        {}
      end

    end

  end
end


