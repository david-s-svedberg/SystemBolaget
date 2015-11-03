require_relative 'object_graph_factory'

if __FILE__ == $PROGRAM_NAME
  ObjectGraphFactory.new().create_app().run()
end
