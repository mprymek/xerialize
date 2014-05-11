# Xerialize

Simple Elixir implementation of serializable structs or records.

## Usage

Implement serializable object:

     require Xerialize
     
     defmodule Person do
        @behaviour Xerialize
        defstruct name: "", surname: ""
     
        def serialize p do
           {Person,p.name,p.surname}
        end
     
        def deserialize {Person,name,surname} do
           %Person{name: name, surname: surname}
        end
     end
     Xerialize.serialization_impl Person

Note: the serialized data *must* be:
* tuple where the first item is the type (Person here)
* map with type stored in ``__struct__`` attribute

If you use some other data type, the general deserialization would not work and you would have
to call specific type deserialization func like ``Person.deserialize(data)``

Use it:

     iex> p = %Person{name: "Mirek", surname: "Prýmek"}
     %Person{name: "Mirek", surname: "Prýmek"}
     iex> data = Serializable.serialize p
     {Person, "Mirek", "Prýmek"}
     iex> p = Serializable.deserialize data
     %Person{name: "Mirek", surname: "Prýmek"}

You can store serialized object to Mnesia or do whatever you want with it...
