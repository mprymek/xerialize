# serialized data MUST be:
#     - tuple with object type as a first item
#     - map with __struct__ correctly defined
# --> then the correct implementation of the protocol will
#     be called for Serialize.deserialize(data)

defmodule Xerialize do
   use Behaviour
   defcallback deserialize(data :: term) :: term
   defcallback serialize(object :: term) :: term

   defmacro serialization_impl(type) do
      quote do
         defimpl Serializable, for: unquote(type) do
            def serialize obj do
               unquote(type).serialize obj
            end
            def deserialize data do
               unquote(type).deserialize data
            end
         end
      end
   end
end

defprotocol Serializable do
   def serialize o
   def deserialize data
end
