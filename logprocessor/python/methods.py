"""Testing methods."""


class MyClass:
    """An example class."""

    def method(self):
        """A standard method."""
        return('instance method called ', self)

    @classmethod
    def classmethod(cls):
        """A class method."""
        return('class method called', cls)

    @staticmethod
    def staticmethod():
        """A static method."""
        return('static method called')


# Create an instance object of MyClass
obj = MyClass()

# Call the standard method
print(obj.method())
print(MyClass.method(obj))

# Access the class method
print(MyClass.classmethod())
print(obj.classmethod())

# Access the static method
print(MyClass.staticmethod())
print(obj.staticmethod())
