require Xerialize

defmodule Person do
   @behaviour Xerialize
   defstruct name: "", surname: ""

   @doc """
   Serialize person.

   iex> Person.serialize(%Person{name: "Mirek", surname: "Prymek"})
   {Person,"Mirek","Prymek"}
   """
   def serialize p do
      {Person,p.name,p.surname}
   end

   @doc """
   Deserialize person.

   iex> Person.deserialize({Person,"Mirek","Prymek"})
   %Person{name: "Mirek", surname: "Prymek"}
   """
   def deserialize {Person,name,surname} do
      %Person{name: name, surname: surname}
   end
end
Xerialize.serialization_impl Person

defimpl Serializable, for: TestStruct do
   def serialize obj do
      :test_struct_serialize
   end
   def deserialize data do
      :test_struct_deserialize
   end
end

defmodule PersonTest do
  use ExUnit.Case
  doctest Person
end

defmodule SerializationTest do
  use ExUnit.Case

  setup do
     p = %Person{name: "Mirek", surname: "Prymek"}
     {:ok,[p: p]}
  end

  test "specific serialization", meta do
     p = meta[:p]
     data = Person.serialize p
     p2 = Person.deserialize data
     assert p==p2
  end

  test "general serialization", meta do
     p = meta[:p]
     data = Serializable.serialize p
     p2 = Serializable.deserialize data
     assert p==p2
  end

  test "mixed serialization", meta do
     p = meta[:p]

     data = Serializable.serialize p
     p2 = Person.deserialize data
     assert p==p2

     data = Person.serialize p
     p2 = Serializable.deserialize data
     assert p==p2
  end

  test "serialization formats" do
     assert_raise Protocol.UndefinedError, fn ->
           Serializable.serialize %{__struct__: Nonexisten, a: :a, b: :b, c: :c}
     end
     assert_raise Protocol.UndefinedError, fn ->
        Serializable.deserialize {Nonexistent,:a,:b,:c}
     end

     assert Serializable.deserialize({TestStruct,:a,:b,:c}) == :test_struct_deserialize
     assert Serializable.deserialize(%{__struct__: TestStruct, a: :a, b: :b, c: :c}) == :test_struct_deserialize
     assert Serializable.serialize({TestStruct,:a,:b,:c}) == :test_struct_serialize
     assert Serializable.serialize(%{__struct__: TestStruct, a: :a, b: :b, c: :c}) == :test_struct_serialize
  end

end
